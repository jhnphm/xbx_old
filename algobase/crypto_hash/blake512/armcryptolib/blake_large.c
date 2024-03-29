/* blake_large.c */
/*
    This file is part of the ARM-Crypto-Lib.
    Copyright (C) 2006-2010  Daniel Otte (daniel.otte@rub.de)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
/*
 * \file    blake_large.c
 * \author  Daniel Otte
 * \email   daniel.otte@rub.de
 * \date    2009-05-08
 * \license GPLv3 or later
 *
 */

#include <stdint.h>
#include <string.h>
#include "memxor.h"
#include "blake_large.h"
#include "blake_common.h"

static const
uint64_t blake_c[]  = {
   0x243F6A8885A308D3LL, 0x13198A2E03707344LL,
   0xA4093822299F31D0LL, 0x082EFA98EC4E6C89LL,
   0x452821E638D01377LL, 0xBE5466CF34E90C6CLL,
   0xC0AC29B7C97C50DDLL, 0x3F84D5B5B5470917LL,
   0x9216D5D98979FB1BLL, 0xD1310BA698DFB5ACLL,
   0x2FFD72DBD01ADFB7LL, 0xB8E1AFED6A267E96LL,
   0xBA7C9045F12C7F99LL, 0x24A19947B3916CF7LL,
   0x0801F2E2858EFC16LL, 0x636920D871574E69LL
};



#define ROTL64(a, n) (((a)<<(n))|((a)>>(64-(n))))
#define ROTR64(a, n) (((a)>>(n))|((a)<<(64-(n))))
#define CHANGE_ENDIAN32(a) (((a)<<24)| \
                            ((0x0000ff00&(a))<<8)| \
						    ((0x00ff0000&(a))>>8)| \
						    (a)>>24 )

static
void blake_large_expand(uint64_t* v, const blake_large_ctx_t* ctx){
	uint8_t i;
	memcpy(v, ctx->h, 8*8);
	for(i=0; i<8; ++i){
		v[8+i] = blake_c[i];
	}
	memxor((uint8_t*)v+8, ctx->s, 4*8);

}

static
void blake_large_changeendian(void* dest, const void* src){
	uint8_t i;
	uint32_t tmp;
	for(i=0; i<32; i+=2){
		tmp = CHANGE_ENDIAN32(((uint32_t*)src)[i]);
		((uint32_t*)dest)[i] = CHANGE_ENDIAN32(((uint32_t*)src)[i+1]);
		((uint32_t*)dest)[i+1] = tmp;
	}
}

#define A (v[idx.v8[0]])
#define B (v[idx.v8[1]])
#define C (v[idx.v8[2]])
#define D (v[idx.v8[3]])

static
void blake_large_compress(uint64_t* v,const void* m){
	uint8_t r,i;
	uint16_t s, *p=(uint16_t*)blake_sigma;
	union {
		uint32_t v32;
		uint8_t v8[4];
	}idx;
	for(r=0; r<16; ++r){
		for(i=0; i<8; ++i){
			idx.v32 = ((uint32_t*)blake_index_lut)[i];
			s = *p++;
			if(p==(uint16_t*)(blake_sigma + 160)){
				p=(uint16_t*)blake_sigma;
			}
			A += B + (((uint64_t*)m)[s&0xff] ^ blake_c[s>>8]);
			D  = ROTR64(D^A, 32);
			C += D;
			B  = ROTR64(B^C, 25);
			A += B + (((uint64_t*)m)[s>>8] ^ blake_c[s&0xff]);
			D  = ROTR64(D^A, 16);
			C += D;
			B  = ROTR64(B^C, 11);
		}
	}
}

static
void blake_large_collapse(blake_large_ctx_t* ctx, uint64_t* v){
	uint8_t i;
	for(i=0; i<8; ++i){
		ctx->h[i] ^= ctx->s[i%4] ^ v[i] ^ v[8+i];
	}
}

void blake_large_nextBlock(blake_large_ctx_t* ctx, const void* msg){
	uint64_t v[16];
	uint64_t m[16];
	union {
		uint64_t v64;
		uint32_t v32[2];
	}ctr;
	blake_large_expand(v,ctx);
	ctx->counter++;
	ctr.v64 = ctx->counter*1024;
	v[12] ^= ctr.v64;
	v[13] ^= ctr.v64;
	blake_large_changeendian(m, msg);
	blake_large_compress(v, m);
	blake_large_collapse(ctx, v);
}

void blake_large_lastBlock(blake_large_ctx_t* ctx, const void* msg, uint16_t length_b){
	while(length_b>=BLAKE_LARGE_BLOCKSIZE){
		blake_large_nextBlock(ctx, msg);
		msg = (uint8_t*)msg + BLAKE_LARGE_BLOCKSIZE_B;
		length_b -= BLAKE_LARGE_BLOCKSIZE;
	}
	uint8_t buffer[128];
	uint64_t v[16];
	uint64_t ctr;
	ctr = ctx->counter*1024+length_b;
	memset(buffer, 0, 128);
	memcpy(buffer, msg, (length_b+7)/8);
	buffer[length_b/8] |= 0x80 >> (length_b&0x7);
	blake_large_changeendian(buffer, buffer);
	blake_large_expand(v, ctx);
	if(length_b>1024-128-2){
		v[12] ^= ctr;
		v[13] ^= ctr;
		blake_large_compress(v, buffer);
		blake_large_collapse(ctx, v);
		memset(buffer, 0, 128-8);
		blake_large_expand(v, ctx);
	} else {
		if(length_b){
			v[12] ^= ctr;
			v[13] ^= ctr;
		}
	}
	if(ctx->appendone)
		buffer[128-16-8] |= 0x01;
	*((uint64_t*)(&(buffer[128-8]))) = ctr;
	blake_large_compress(v, buffer);
	blake_large_collapse(ctx, v);

}

static const
uint64_t blake512_iv[] = {
    0x6A09E667F3BCC908LL, 0xBB67AE8584CAA73BLL,
    0x3C6EF372FE94F82BLL, 0xA54FF53A5F1D36F1LL,
    0x510E527FADE682D1LL, 0x9B05688C2B3E6C1FLL,
    0x1F83D9ABFB41BD6BLL, 0x5BE0CD19137E2179LL
};

void blake512_init(blake512_ctx_t* ctx){
	uint8_t i;
	for(i=0; i<8; ++i){
		ctx->h[i] = blake512_iv[i];
	}
	memset(ctx->s, 0, 4*8);
	ctx->counter = 0;
	ctx->appendone = 1;
}

static const
uint64_t blake384_iv[] = {
    0xCBBB9D5DC1059ED8LL, 0x629A292A367CD507LL,
    0x9159015A3070DD17LL, 0x152FECD8F70E5939LL,
    0x67332667FFC00B31LL, 0x8EB44A8768581511LL,
    0xDB0C2E0D64F98FA7LL, 0x47B5481DBEFA4FA4LL
};

void blake384_init(blake384_ctx_t* ctx){
	uint8_t i;
	for(i=0; i<8; ++i){
		ctx->h[i] = blake384_iv[i];
	}
	memset(ctx->s, 0, 4*8);
	ctx->counter = 0;
	ctx->appendone = 0;
}

void blake512_ctx2hash(void* dest, const blake512_ctx_t* ctx){
	uint8_t i;
	for(i=0; i<8; ++i){
		((uint32_t*)dest)[2*i+0] = CHANGE_ENDIAN32((ctx->h[i])>>32);
		((uint32_t*)dest)[2*i+1] = CHANGE_ENDIAN32((uint32_t)ctx->h[i]);
	}
}

void blake384_ctx2hash(void* dest, const blake384_ctx_t* ctx){
	uint8_t i;
	for(i=0; i<6; ++i){
		((uint32_t*)dest)[2*i+0] = CHANGE_ENDIAN32((ctx->h[i])>>32);
		((uint32_t*)dest)[2*i+1] = CHANGE_ENDIAN32((uint32_t)ctx->h[i]);
	}
}

void blake512_nextBlock(blake512_ctx_t* ctx, const void* block){
	blake_large_nextBlock(ctx, block);
}

void blake384_nextBlock(blake384_ctx_t* ctx, const void* block){
	blake_large_nextBlock(ctx, block);
}

void blake512_lastBlock(blake512_ctx_t* ctx, const void* block, uint16_t length_b){
	blake_large_lastBlock(ctx, block, length_b);
}

void blake384_lastBlock(blake384_ctx_t* ctx, const void* block, uint16_t length_b){
	blake_large_lastBlock(ctx, block, length_b);
}

void blake512(void* dest, const void* msg, uint32_t length_b){
	blake_large_ctx_t ctx;
	blake512_init(&ctx);
	while(length_b>=BLAKE_LARGE_BLOCKSIZE){
		blake_large_nextBlock(&ctx, msg);
		msg = (uint8_t*)msg + BLAKE_LARGE_BLOCKSIZE_B;
		length_b -= BLAKE_LARGE_BLOCKSIZE;
	}
	blake_large_lastBlock(&ctx, msg, length_b);
	blake512_ctx2hash(dest, &ctx);
}

void blake384(void* dest, const void* msg, uint32_t length_b){
	blake_large_ctx_t ctx;
	blake384_init(&ctx);
	while(length_b>=BLAKE_LARGE_BLOCKSIZE){
		blake_large_nextBlock(&ctx, msg);
		msg = (uint8_t*)msg + BLAKE_LARGE_BLOCKSIZE_B;
		length_b -= BLAKE_LARGE_BLOCKSIZE;
	}
	blake_large_lastBlock(&ctx, msg, length_b);
	blake384_ctx2hash(dest, &ctx);
}

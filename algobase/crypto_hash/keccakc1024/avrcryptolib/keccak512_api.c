#include "keccak.h"


void keccak512(void* dest, void* msg, uint32_t length_b){
	keccak_ctx_t ctx;
        keccak512_init(&ctx);
       	while(length_b>=KECCAK512_BLOCKSIZE){
		keccak_nextBlock(&ctx, msg);
		msg = (uint8_t*)msg+KECCAK512_BLOCKSIZE_B;
		length_b -= KECCAK512_BLOCKSIZE;
	}
	keccak_lastBlock(&ctx, msg, length_b);
        keccak512_ctx2hash(dest, &ctx);
}

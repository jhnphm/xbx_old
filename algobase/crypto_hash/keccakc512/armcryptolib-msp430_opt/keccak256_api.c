#include "keccak.h"


void keccak256(void* dest, void* msg, uint32_t length_b){
	keccak_ctx_t ctx;
        keccak256_init(&ctx);
       	while(length_b>=KECCAK256_BLOCKSIZE){
		keccak_nextBlock(&ctx, msg);
		msg = (uint8_t*)msg+KECCAK256_BLOCKSIZE_B;
		length_b -= KECCAK256_BLOCKSIZE;
	}
	keccak_lastBlock(&ctx, msg, length_b);
        keccak256_ctx2hash(dest, &ctx);
}

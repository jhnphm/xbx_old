#include "jh_simple.h"


void jh256(void* dest, void* msg, uint32_t length_b){
	jh_ctx_t ctx;
        jh_init(256, &ctx);
       	while(length_b>=JH256_BLOCKSIZE){
		jh_nextBlock(&ctx, msg);
		msg = (uint8_t*)msg+JH256_BLOCKSIZE_B;
		length_b -= JH256_BLOCKSIZE;
	}
	jh_lastBlock(&ctx, msg, length_b);
        jh256_ctx2hash(dest, &ctx);
}

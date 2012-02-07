#include "jh_simple.h"


void jh512(void* dest, void* msg, uint32_t length_b){
	jh_ctx_t ctx;
        jh_init(512, &ctx);
       	while(length_b>=JH512_BLOCKSIZE){
		jh_nextBlock(&ctx, msg);
		msg = (uint8_t*)msg+JH512_BLOCKSIZE_B;
		length_b -= JH512_BLOCKSIZE;
	}
	jh_lastBlock(&ctx, msg, length_b);
        jh512_ctx2hash(dest, &ctx);
}

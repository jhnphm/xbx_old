#include "crypto_hash.h"
#include "blake256.h"

int crypto_hash(unsigned char *out, const unsigned char *in, unsigned long long inlen)
{
   unsigned char state[187]; // RAM required by assembly code, 64 bytes internal state, 64 bytes constants, 32 bytes chain value, 16 bytes salt, eight bytes for the counter and three bytes for temporary data.
   unsigned char last_block[64]; // since padding can not be done in-place, input is 'const'
   int i;

   blake_init(state);

   while(inlen>64ULL)
   {
	blake_compress(state, in , 512); 
	in+=64;
	inlen-=64;
   }

   // final message block
   for(i=0;i<inlen;i++)
   {
   		last_block[i] = in[i];
   }
   blake_compress(state, last_block, 32768+inlen*8); // setting MSB in 16-bit counter signals last block to assembly code
	
   for(i=0;i<32;i++)
   		out[i] = state[i];

   return 0;
}

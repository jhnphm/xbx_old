#include "crypto_hash.h"
#include "keccak512_api.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  keccak512(out, in, inlen*8);
  return 0;
}
      

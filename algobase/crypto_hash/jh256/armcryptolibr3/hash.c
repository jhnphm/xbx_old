#include "crypto_hash.h"
#include "jh256_api.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  jh256(out, in, inlen*8);
  return 0;
}
      

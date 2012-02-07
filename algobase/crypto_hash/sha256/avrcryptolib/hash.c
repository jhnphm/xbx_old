#include "crypto_hash.h"
#include "sha256.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  sha256(out, in, inlen*8);
  return 0;
}
      

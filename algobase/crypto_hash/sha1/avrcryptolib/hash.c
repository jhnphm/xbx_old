#include "crypto_hash.h"
#include "sha1.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  sha1(out, in, inlen*8);
  return 0;
}
      

#include "crypto_hash.h"
#include "groestl_small.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  groestl256(out, in, inlen*8);
  return 0;
}
      

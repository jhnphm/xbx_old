#include "crypto_hash.h"
#include "groestl_large.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  groestl512(out, in, inlen*8);
  return 0;
}
      

#include "crypto_hash.h"
#include "jh_api.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  jh512(out, in, inlen*8);
  return 0;
}
      

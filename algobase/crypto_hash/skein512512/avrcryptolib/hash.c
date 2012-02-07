#include "crypto_hash.h"
#include "skein512api.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  skein_a_512(out, in, inlen*8);
  return 0;
}
      

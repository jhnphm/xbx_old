#include "crypto_hash.h"
#include "blake_large.h"
  
int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  blake512(out, in, inlen*8);
  return 0;
}
      

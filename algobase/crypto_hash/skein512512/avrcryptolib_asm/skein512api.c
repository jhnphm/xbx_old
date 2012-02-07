#include "skein.h"


void skein_a_512(void* dest, void* msg, uint32_t length_b){
	skein512(dest,512, msg,length_b);
}

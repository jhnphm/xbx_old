#include "skein.h"


void skein_a_256(void* dest, void* msg, uint32_t length_b){
	skein512(dest,256, msg,length_b);
}

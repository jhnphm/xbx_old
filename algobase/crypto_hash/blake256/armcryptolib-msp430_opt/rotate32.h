#include<stdint.h>



#ifndef HOST
uint32_t rotr32_8(uint32_t in);
uint32_t rotr32_7(uint32_t in);
uint32_t rotr32_12(uint32_t in);
//uint32_t rotr32_16(uint32_t in);
#else
inline uint32_t rotr32_8(uint32_t in){
    return (in>>8)|(in<<24);
}
uint32_t rotr32_7(uint32_t in){
    return (in>>7)|(in<<25);
}
inline uint32_t rotr32_12(uint32_t in){
    return (in>>12)|(in<<20 );
}
#endif
inline uint32_t rotr32_16(uint32_t in){
    return (in<<16)|(in>>16 );
}


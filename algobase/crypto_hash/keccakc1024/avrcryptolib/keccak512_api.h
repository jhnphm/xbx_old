#ifndef KECCAK_API_H
#define KECCAK_API_H
#include <stdint.h>


void keccak512(void* dest, void* msg, uint32_t length_b);


#endif
#ifndef KECCAK_API_H
#define KECCAK_API_H
#include <stdint.h>


void keccak256(void* dest, void* msg, uint32_t length_b);


#endif
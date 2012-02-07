#include <stdint.h>

void blake_init(unsigned char *state);
void blake_compress(unsigned char *state, const unsigned char *in, uint16_t len);

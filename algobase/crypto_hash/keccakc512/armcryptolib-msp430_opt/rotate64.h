/* rotate64.h */
/*
    This file is part of the AVR-Crypto-Lib.
    Copyright (C) 2010 Daniel Otte (daniel.otte@rub.de)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef ROTATE64_H_
#define ROTATE64_H_

#include <stdint.h>

#define ROTL_0 0
#define ROTL_1 1
#define ROTL_2 2
#define ROTL_3 3
#define ROTL_4 4
#define ROTR_0 0
#define ROTR_1 (8+1)
#define ROTR_2 (8+2)
#define ROTR_3 (8+3)


#if defined(HOST) || defined(NO_OPTIMIZE)
#define ROT_CODE(a) a
#else
// Encode rotation parameter to specify word movements, left or right rotation
#define ROT_BSHF(a) ((a)%16) // Returns number of BITS to shift
#define ROT_BSHF_DIR(a) (ROT_BSHF(a)<=8?0:1) // Return inverse of ROT_DIR(a) if direction of shifting is reversed for bit shifts
#define ROT_BSHF_AMT(a) (!ROT_BSHF_DIR(a)?ROT_BSHF(a):16-ROT_BSHF(a)) // Return 16-ROT_BSHF(a) if direction of shifting reversed for bit shifts (4 bits)
#define ROT_WSHF(a) (((a)/16+ROT_BSHF_DIR(a))%4) // Returns number of words to shift (2 bits)
#define ROT_CODE(a) (ROT_WSHF(a)<<8) |ROT_BSHF_AMT(a)<<1 | ROT_BSHF_DIR(a)
#endif

uint64_t rotate64_1bit_left(uint64_t a);
uint64_t rotate64_1bit_right(uint64_t a);
uint64_t rotate64left_code(uint64_t a, uint16_t code);
#endif /* ROTATE64_H_ */


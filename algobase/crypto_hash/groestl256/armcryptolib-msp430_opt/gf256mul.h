/* gf256mul.h */
/*
    This file is part of the AVR-Crypto-Lib.
    Copyright (C) 2008  Daniel Otte (daniel.otte@rub.de)

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
#ifndef GF256MUL_H_
#define GF256MUL_H_

/**
 * \author  Daniel Otte
 * \email   daniel.otte@rub.de
 * \date    2008-12-19
 * \license GPLv3
 * \brief
 * 
 * 
 */

#include <stdint.h>


#ifdef NO_LUT
uint8_t gf256mul(uint8_t a, uint8_t b, uint8_t reducer);
#else
extern const uint8_t GF256_MUL_LUT[6][256];
inline uint8_t gf256mul(uint8_t a, uint8_t b, uint8_t reducer){
//ignore reducer, since always 1b and taken into account in table
//    printf("a: 0x%02x, b: 0x%02x, f: 0x%02x, l: 0x%02x\n",a,b,gf256mul_real(a,b,reducer), GF256_MUL_LUT[a-2][b]);
    return GF256_MUL_LUT[a-2][b];    
}
#endif

#endif /* GF256MUL_H_ */


#ifndef __GLOBAL_H
#define __GLOBAL_H
#include <inttypes.h>
/**
 * Do not change F_CPU_DEFAULT or CLK_CRYSTAL_FREQ
 */
#define CLK_CRYSTAL_FREQ 32768L
#define F_CPU_DEFAULT (CLK_CRYSTAL_FREQ*32L)   // Speed of crystal on MSP dev board x 32 == approx 1MHz

/**
 * Change CLK_MULT to change clock frequency
 * Max for MSP430FG4618 at 3.6V is 4MHz, so max CLK_MULT is 128
 */

#ifdef CLK_MULT 32

#define F_CPU (CLK_MULT*CLK_CRYSTAL_FREQ)// Speed of crystal on MSP dev board x 32 == approx 1MHz


#define UART_BAUDRATE 115000
#define I2C_FREQ 400000
#endif

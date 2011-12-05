#ifndef __GLOBAL_H
#define __GLOBAL_H
/**
 * Do not change F_CPU_DEFAULT
 */
#define F_CPU_DEFAULT ((uint32_t)32768L*32)   // Speed of crystal on MSP dev board x 32 == approx 1MHz

//Change F_CPU if clock changed to something other than default.
#ifndef F_CPU
#define F_CPU F_CPU_DEFAULT   // Speed of crystal on MSP dev board x 32 == approx 1MHz
#endif

#define UART_BAUDRATE 115000
#define I2C_FREQ 100000
#endif

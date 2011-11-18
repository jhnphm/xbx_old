#include "msp430fg4618.h"   /* msp430-gcc */
//#include "msp430F4618.h"
#include <XBD_HAL.h>
#include <XBD_FRW.h>
#include <XBD_debug.h>
#include <stdint.h>
//#include <intrinsics.h>
#include <signal.h>


/* your functions / global variables here */
#include <i2c.h>
#include <RS232.h>
//#include <jtagfunc.c>

#define I2C_BAUDRATE 400
#define SLAVE_ADDR 1

void XBD_init()
{
  /* inititalisation code, called once */

  __disable_interrupt();

  usart_init(115200);
  XBD_debugOut("START ATmega644 HAL\r\n");
  XBD_debugOut("\r\n");

  i2cInit();
  i2cSetLocalDeviceAddr(SLAVE_ADDR, 0);
  i2cSetBitrate(I2C_BAUDRATE);
  i2cSetSlaveReceiveHandler( FRW_msgRecHand );
  i2cSetSlaveTransmitHandler( FRW_msgTraHand );

  //Set Port 2.1 to output - Execution signal to XBH
  P2OUT = BIT1;     // Set pin high
  P2DIR |= BIT1;


}


inline void XBD_sendExecutionStartSignal()
{
  /* code for output pin = on here */
  P2OUT &= (~BIT1);

}

inline void XBD_sendExecutionCompleteSignal()
{
  /* code for output pin = off here */
  P2OUT |= BIT1;
}


void XBD_debugOut(char *message)
{
  /* if you have some kind of debug interface, write message to it */
   usart_puts(message);
}

void XBD_serveCommunication()
{
  /* read from XBD<->XBH communication channel (uart or i2c) here and call

    FRW_msgTraHand(size,transmitBuffer)
    FRW_msgRecHand(size,transmitBuffer)

    depending whether it's a read or write request
  */
  if((IFG2&UCB0RXIFG== 1) | (IFG2&UCB0TXIFG == 1)) {
		twi_isr();
	}
}

void XBD_loadStringFromConstDataArea( char *dst, const char *src  ) {
	/*  with jtag readMem slaa149.pdf pg.31
   		alt. if use bsl recieve block function slaa096b.pdf p.5 instead
   		copy a zero terminated string from src (CONSTDATAAREA) to dst
   		e.g. strcpy if CONSTDATAREA empty, strcpy_P for PROGMEM
   	*/
	while(*dst++ = ReadMem( (0x10000l) | ((uint32_t)((uint16_t)src++))) );
}


void XBD_readPage( uint32_t pageStartAddress, uint8_t * buf )
{
  /* read PAGESIZE bytes from the binary buffer, index pageStartAddress
  to buf */
  	u16 u;
  	for(u = 0;u < 256; ++u)			//may need to change to 128
  	{
  		*buf++ = ReadMem(pageStartAddress++);
	}
}

void XBD_programPage( uint32_t pageStartAddress, uint8_t * buf )
{
  /* copy data from buf (PAGESIZE bytes) to pageStartAddress of
  application binary */
}

void XBD_switchToApplication()
{
  /* execute the code in the binary buffer */
  	// pointer called reboot that points to the reset vector
  	// bootloader is located at the end of flash
  void (*reboot)( void ) = 0x0000; // defines the function reboot to location 0x0000
  reboot();	// calls function reboot function, did not need to change unless change location to 0x1000, at flash info memory
}


void XBD_switchToBootLoader()
{
  /* switch back from uploaded code to boot loader */
  _RESET();
//  NAKED(_reset_vector__)
//  {
//    /* place your startup code here */
//    /* Make shure, the branch to main (or to your start
//    routine) is the last line in the function */
//    __asm__ __volatile__("br #main"::);
//  }

//software reset (this is a soft reset equivalent on msp430 at 32ms 1Mhz smclk)
//  wdtctl = WDT_MDLY_32; //wdt_enable(WDTO_15MS); //set watch dog WDT_MDLY_32
//  while(1);
}

uint32_t XBD_busyLoopWithTiming(uint32_t approxCycles)
{
  /* wait for approximatly approxCycles,
  * then return the number of cycles actually waited */
  /* Code from atmega_common XBD_shared_HAL.i */
	uint32_t exactCycles=0;
	uint16_t lastTCNT=0;
	uint16_t overRuns=0;

	TBCCTL0 = TBSSEL_2 | ID_0 | MC_2;	//SMCLK, div 1, continuous, no interrupts
	//TIMSK1 = 0;	//no interrupts

	TBCCTL0 |= TBCLR;	//Clear timer register
	XBD_sendExecutionStartSignal();

	while(exactCycles < approxCycles)
	{
		if(lastTCNT > TBR)
		{
			++overRuns;
		}
		lastTCNT=TBR;
		exactCycles = ((uint32_t)overRuns<<16)|TBR;
	}

	exactCycles = ((uint32_t)overRuns<<16);
	exactCycles |= TBR;
	XBD_sendExecutionCompleteSignal();

	return exactCycles;
}

#define STACK_CANARY (inv_sc?0x3A:0xC5)
//#define top    *(uint16_t *)0x1100
//#define bottom *(uint16_t *)0x30FF

//#pragma segment = "CSTACK"
uint8_t  inv_sc = 0;

/*****************************************************
 * Overwrites the entire RAM with STACK_CANARY.
 * Part of RAM is for the heap; this is why global
 * variables are stored in RAM. (Heap @ 0x1000)
 * See TI compiler doc, p. 101.
 * $DROPBOX\XBX Info\ti-compiler.pdf
 ****************************************************/
//uint8_t *p = __segment_begin("CSTACK");
//uint8_t *p_stack = __segment_end("CSTACK");

//extern uint8_t __stack;		/* stack top address */
extern unsigned short _end;  ///<Last used byte of the last segment in RAM (defined by the linker)
void XBD_paintStack(void)
{
  /* initialise stack measurement */

  inv_sc=!inv_sc;

  //uint8_t *p = &__stack;		/* p = address of stack top */
  //uint8_t *p = __segment_begin("CSTACK");//(void *)0x1100;     //__segment_begin("CSTACK");
  //get address
  //uint8_t *p_stack = __segment_end("CSTACK");
  
  unsigned short *address = &_end;
  register void * __stackptr asm("r1");   ///<Access to the stack pointer
  while(address <= (unsigned short *)__stackptr)
  {
    *address++ = STACK_CANARY;
    //++p;
  }
}

uint32_t XBD_countStack(void)
{
  /* return stack measurement result/0 if not supported */
  //uint8_t *p = __segment_end("CSTACK");
  //uint8_t *p_stack = __segment_begin("CSTACK");
  unsigned short *address = &_end;
  register void * __stackptr asm("r1");   ///<Access to the stack pointer
  register uint16_t c = 0;
  while(*address == STACK_CANARY && address <= (unsigned short *)__stackptr)
  {
    ++address;
    ++c;
  }
  return (uint32_t)c;
}

/* To be removed */

int main (void)
{
  XBD_countStack();
  XBD_paintStack();

}

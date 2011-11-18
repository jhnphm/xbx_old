#include <signal.h>
#include <string.h>
#include <msp430fg4618.h>   /* msp430-gcc */
#include "msp430libtypes.h"
#include "RS232.h"


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
  
  uint8_t *address = (uint8_t *) &_end;
  register void * __stackptr asm("r1");   ///<Access to the stack pointer
  while(address <= (uint8_t *)__stackptr)
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
  uint8_t *address = (uint8_t *) &_end;
  register void * __stackptr asm("r1");   ///<Access to the stack pointer
  register uint16_t c = 0;
  while(*address == STACK_CANARY && address < (uint8_t *)__stackptr)
  {
    ++address;
    ++c;
  }
  return (uint32_t)c;
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


void XBD_readPage( uint32_t pageStartAddress, uint8_t * buf )
{
  /* read PAGESIZE bytes from the binary buffer, index pageStartAddress
  to buf */
	uint8_t *startAddress = (uint8_t *) (uint16_t) pageStartAddress;
	
	u16 u;
	for(u = 0;u < 256; ++u)			//may need to change to 128
	{
		*buf++ =  *startAddress++;
	}
}

void XBD_programPage( uint32_t pageStartAddress, uint8_t * buf )
{
  /* copy data from buf (PAGESIZE bytes) to pageStartAddress of
  application binary */
  
  //	Interrupts disabled in XBD_init()
  	unsigned int i;
	
  	//	Erase a page of flash
	//WDTCTL = 0x5A80;
	FCTL1 = 0x0A502;
	FCTL3 = 0x0A500;
	uint8_t *startAddress = (uint8_t *) (uint16_t) pageStartAddress;
	*startAddress = 0x00;
	for(i=0;i<1000; i++)
	asm("nop");
	//WDTCTL = WDTPW+0x0c;
	
	//	Write to flash
	startAddress = (uint8_t *) (uint16_t) pageStartAddress;  //   16-bits
	while(BUSY & FCTL3);		//	Wait until flash ready
	FCTL3 = FWKEY;	//	Clear lock bits (LOCK & LOCKA)
	FCTL1 = FWKEY + WRT;	//	Enable byte/word write mode
	u16 u;
	for(u = 0;u < 256; ++u)			//may need to change to 128
	{
		*startAddress++ = *buf++;
	}
	FCTL1 = FWKEY;
	FCTL3 ^= (FXKEY + LOCK);
}

void XBD_loadStringFromConstDataArea( char *dst, const char *src  ) 
{
	strcpy((char *)dst,(const char *)src);
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


/* To be removed */

int main (void)
{
  XBD_countStack();
  XBD_paintStack();
  
  return 0;
}

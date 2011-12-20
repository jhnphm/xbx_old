#include <msp430fg4618.h>   /* msp430-gcc */
#include <XBD_HAL.h>
#include <XBD_FRW.h>
#include <XBD_debug.h>
#include <stdint.h>
//#include <signal.h>
#include <legacymsp430.h>
#include <string.h>


/* your functions / global variables here */
#include <i2c.h>
#include <RS232.h>
//#include <JTAGfunc.h>

#define I2C_BAUDRATE 400
#define SLAVE_ADDR 0x75


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


void XBD_init() {
    uint16_t i;

    __disable_interrupt();
    WDTCTL = WDTPW+WDTHOLD;            // Stop WDT
    /* inititalisation code, called once */

    //Explicitly set clock here. Dev board defaults to 32kHz*32
    //Change in global.h
    SCFQCTL = CLK_MULT-1; 
    SCFI0 |= FN_3; 
    SCFI0 &= ~(FLLD0|FLLD1); 
    //Explicitly enable SMCLK and set SMCLK and MCLK to DCOCLK
    FLL_CTL1 &= ~(SMCLKOFF | SELM0|SELM1 | SELS);
    //Loop 32768 times for clk to stabilize
    for(i = 0; i< 32768;i++);
    



    //__disable_interrupt();
    //TODO Manually disable all other interrupts.
    //Due to 

    //Enable interrupt for soft reset on pin 2.0
    P2SEL &= ~BIT0;
    P2DIR &= ~BIT0;
    P2IES |= BIT0; //Trigger on rising edge
    P2IE = BIT0;

    __enable_interrupt();
    

    usart_init();

    XBD_debugOut("START MSP430FG4618 HAL\r\n");
    XBD_debugOut("\r\n");

    i2cInit();
    i2cSetLocalDeviceAddr(SLAVE_ADDR, 0);
    //i2cSetBitrate(I2C_BAUDRATE);  // Slave, does not need to be set.
    i2cSetSlaveReceiveHandler( FRW_msgRecHand );
    i2cSetSlaveTransmitHandler( FRW_msgTraHand );

    //Set Port 2.0 to output - Execution signal to XBH
    P3OUT = BIT0;     // Set pin high
    P3DIR |= BIT0;

}


inline void XBD_sendExecutionStartSignal() {
    /* code for output pin = on here */
    P3OUT &= (~BIT0);

}

inline void XBD_sendExecutionCompleteSignal() {
    /* code for output pin = off here */
    P3OUT |= BIT0;
}


void XBD_debugOut(char *message) {
    /* if you have some kind of debug interface, write message to it */
    usart_puts(message);
}

void XBD_serveCommunication() {
    /* read from XBD<->XBH communication channel (uart or i2c) here and call

       FRW_msgTraHand(size,transmitBuffer)
       FRW_msgRecHand(size,transmitBuffer)

       depending whether it's a read or write request
       */
 
    //if(UCB0STAT&UCSTTIFG) {
    //if(((IFG2&UCB0RXIFG)== 1) || ((IFG2&UCB0TXIFG) == 1)) {
      twi_isr();
    //}
}

void XBD_loadStringFromConstDataArea( char *dst, const char *src  ) {
	strcpy((char *)dst,(const char *)src);
}


void XBD_readPage( uint32_t pageStartAddress, uint8_t * buf ) {
    /* read PAGESIZE bytes from the binary buffer, index pageStartAddress
       to buf */
    uint8_t *startAddress = (uint8_t *) (uint16_t) pageStartAddress;

    u16 u;
    for(u = 0;u < 256; ++u)			//may need to change to 128
    {
        *buf++ =  *startAddress++;
    }
}

void XBD_programPage( uint32_t pageStartAddress, uint8_t * buf ) {
    /* copy data from buf (PAGESIZE bytes) to pageStartAddress of
       application binary */

    //	Interrupts disabled in XBD_init()
    uint16_t u;
    uint16_t *startAddress = (uint16_t *) (uint16_t) pageStartAddress;
    uint16_t *bufPtr = (uint16_t *)buf;

    __disable_interrupt();
    //	Erase a page of flash
    FCTL2 = FWKEY|FSSEL1|FN0; // Set clock divider to 1
    FCTL3 = FWKEY;            // Unlock
    FCTL1 = FWKEY|ERASE;      // Set erase bit
    *startAddress = 0x00;     // Perform erase
    // Waiting until erase and clearing bit should be unnecessary
    // when erasing from program running from flash
#if 0
    while(FCTL3&BUSY);        // Wait until erase done
    FCTL1 = FWKEY;            // Clear erase bit
#endif
    //Disabling watchdog should be unnecessary, as it should be disabled already
#if 0
    WDTCTL = WDTPW+WDTHOLD;            // Stop WDT
#endif

    //for(i=0;i<1000; i++)
    //    asm("nop");
    ////WDTCTL = WDTPW+0x0c;

    //	Write to flash
    startAddress = (uint16_t *) (uint16_t) pageStartAddress; // 16-bits
    while(FCTL3&FCTL3);                                      // Wait until flash ready
    // FCTL3 = FWKEY;                                        // Clear lock bits (LOCK & LOCKA)
    FCTL1 = FWKEY | WRT;                                     // Enable byte/word write mode
    for(u = 0;u < PAGESIZE/(sizeof(uint16_t)); u++)          // may need to change to 128
    {
    *startAddress++ = *bufPtr++;
    }
    FCTL1 = FWKEY;                                           // Clear write bit
    FCTL3 = FWKEY|LOCK;                                      // Lock flash
    __enable_interrupt();
}

void XBD_switchToApplication() {
    /* execute the code in the binary buffer */
    // pointer called reboot that points to the reset vector
    // bootloader is located at the end of flash
    void (*reboot)( void ) = (void*)FLASH_ADDR_MIN; // defines the function reboot to location 0x0000
    reboot();	// calls function reboot function, did not need to change unless change location to 0x1000, at flash info memory
}


void XBD_switchToBootLoader() {
    /* switch back from uploaded code to boot loader */
    _RESET();
    //  NAKED(_reset_vector__)
    //  {
    //    /* place your startup code here */
    //    /* Make shure, the branch to main (or to your start
    //    routine) is the last line in the function */
    //    __asm__ __volatile__("br #main"::);
    //  }

}

/**
 * Broken
 */
uint32_t XBD_busyLoopWithTiming(uint32_t approxCycles) {
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

void XBD_paintStack(void) {
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

uint32_t XBD_countStack(void) {
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

interrupt (PORT2_VECTOR) soft_reset(void){
    P2IFG &= ~BIT0; //Clear IFG for pin 2.0
    WDTCTL = 0;     //Write invalid key to trigger soft reset
                    //XXX Be aware soft reset does not reset register values, thus
                    //code must initialize registers before use.
    
    //(WDTPW+WDTTMSEL+WDTCNTCL+WDTIS1+WDTIS0) Soft reset after 0.064ms at 1MHz

    //software reset (this is a soft reset equivalent on msp430 at 32ms 1Mhz smclk)
    //  wdtctl = WDT_MDLY_32; //wdt_enable(WDTO_15MS); //set watch dog WDT_MDLY_32
    while(1);
}
void XBD_startWatchDog(uint32_t seconds)
{
  (void)seconds;
}

void XBD_stopWatchDog()
{
}

#if 0
/* To be removed */

int main (void)
{
    XBD_countStack();
    XBD_paintStack();

}
#endif

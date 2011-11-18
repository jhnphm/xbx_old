//part of mspgcc, modified file from TI:

/*==========================================================================*\
|                                                                            |
| LowLevelFunc.c                                                             |
|                                                                            |
| Low Level Functions regarding user's Hardware                              |
|----------------------------------------------------------------------------|
| Project:              MSP430 Replicator                                    |
| Developed using:      IAR Embedded Workbench 2.31C                         |
|----------------------------------------------------------------------------|
| Author:               FRGR                                                 |
| Version:              1.3                                                  |
| Initial Version:      04-17-02                                             |
| Last Change:          08-29-02                                             |
|----------------------------------------------------------------------------|
| Version history:                                                           |
| 1.0 04/02 FRGR        Initial version.                                     |
| 1.1 04/02 FRGR        Included SPI mode to speed up shifting function by 2.|
| 1.2 06/02 ALB2        Formatting changes, added comments.                  |
| 1.3 08/02 ALB2        Initial code release with Lit# SLAA149.              |
|----------------------------------------------------------------------------|
| Designed 2002 by Texas Instruments Germany                                 |
\*==========================================================================*/

#include "LowLevelFunc.h"

/*----------------------------------------------------------------------------
   This function switches TDO to Input, used for fuse blowing
*/
void TDOisInput(void)
{
    //~ JTAGOUT &= ~TDICTRL1;           // Release TDI pin on target
    //~ Delay(5);                       // Settle MOS relay
    //~ JTAGOUT |=  TDICTRL2;           // Switch TDI --> TDO
    //~ Delay(5);                       // Settle MOS relay
}

/*----------------------------------------------------------------------------
   Initialization of the Target Board (switch voltages on, preset JTAG pins)    
*/
void InitTarget(void)
{
    JTAGSEL  = 0x00;            // Pins all I/Os except during SPI access
    JTAGOUT  = TEST|TDI|TMS|TCK|TCLK|RST;
    JTAGDIR  = TEST|TDI|TMS|TCK|TCLK|RST;
    //~ VPPSEL  &= ~(VPPONTDI | VPPONTEST); // No special function, I/Os
    //~ VPPOUT  &= ~(VPPONTDI | VPPONTEST); // VPPs are OFF
    //~ VPPDIR  |=  (VPPONTDI | VPPONTEST); // VPP pins are outputs
    //~ Delay(50);                          // Settle MOS relays, target capacitor
}
    
/*----------------------------------------------------------------------------
   Release Target Board (switch voltages off, JTAG pins are HI-Z)    
*/
void ReleaseTarget(void)
{
    //~ VPPoff();                       // VPPs are off (safety)
    //~ Delay(5);                       // Settle MOS relays
    JTAGDIR  =  0x00;            // VCC is off, all I/Os are HI-Z
    //~ Delay(5);                       // Settle MOS relays
}

//----------------------------------------------------------------------------
/*  Shift a value into TDI (MSB first) and simultaneously shift out a value
    from TDO (MSB first).
    Note:      When defining SPI_MODE the embedded SPI is used to speed up by 2.
    Arguments: word Format (number of bits shifted, 8 (F_BYTE) or 16 (F_WORD))
               word Data (data to be shifted into TDI)  
    Result:    word (scanned TDO value)
*/
word Shift(word Format, word Data)
{
    word tclk = StoreTCLK();            // Store TCLK state;
    word TDOword = 0x0000;              // Initialize shifted-in word
    word MSB = 0x0000;
         
    word i;
    (Format == F_WORD) ? (MSB = 0x8000) : (MSB = 0x80);
    for (i = Format; i > 0; i--)
    {
            ((Data & MSB) == 0) ? ClrTDI() : SetTDI();
            Data <<= 1;
            if (i == 1)                 // Last bit requires TMS=1
            SetTMS();
            ClrTCK();
            SetTCK();
            TDOword <<= 1;              // TDO could be any port pin
            if (ScanTDO() != 0) TDOword++;
    }
 
    RestoreTCLK(tclk);                  // restore TCLK state
    PrepTCLK();                         // Set JTAG FSM back into Run-Test/Idle
    return(TDOword);
}

/*----------------------------------------------------------------------------
   Delay function (resolution is 1 ms)
   User knows target frequency, instruction cycles, C implementation.
   Arguments: word millisec (number of ms, max number is 0xFFFF)     
*/   
#define    D_LOOPBODY        8        // MSP430: 8 cycles for "for" body
#define D_LOOPCOUNT1MS    (word)((FREQUENCY / D_LOOPBODY))

void Delay(word millisec)            // Inner loop generates 1 ms
{
    word i, j;
    for (i = millisec; i > 0; i--)
        for (j = D_LOOPCOUNT1MS; j > 0; j--) __asm__ __volatile__("; loop");
}  

/*---------------------------------------------------------------------------
   This function generates Amount strobes with the Flash Timing Generator
   Frequency fFTG = 257..476kHz (t = 3.9..2.1us).
   User knows target frequency, instruction cycles, C implementation.
   Arguments: word Amount (number of strobes to be generated)
*/
#define    S_LOOPBODY        14         // 14 cycles/loop w/o NOPs
#define S_ADDNOPS    (word)((FREQUENCY * 2.1) / 1000 - S_LOOPBODY + 1)
                                        // S_ADDNOPS = 3..18
void TCLKstrobes(word Amount)
{
    word i;
    
    for (i = Amount; i > 0; i--)        // This implementation has 14 body cycles!    
    {
        SetTCLK();                      // Set TCLK
        _NOP();                         // Include NOPs if necessary (min. 3) 
        _NOP();
        _NOP();
        ClrTCLK();                      // Reset TCLK
    }
}



/****************************************************************************/
/*                         END OF SOURCE FILE                               */
/****************************************************************************/

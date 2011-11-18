//part of mspgcc, modified file from TI:

/*==========================================================================*\
|                                                                            |
| LowLevelFunc.h                                                             |
|                                                                            |
| Low Level function prototypes, macros, and pin-to-signal assignments       |
| regarding to user's hardware                                               |
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
|                       (JTAG control now on Port5)                          |
| 1.2 06/02 ALB2        Formatting changes, added comments. Removed code used|
|                       for debug purposes during development.               |
| 1.3 08/02 ALB2        Initial code release with Lit# SLAA149.              |
|----------------------------------------------------------------------------|
| Designed 2002 by Texas Instruments Germany                                 |
\*==========================================================================*/

#include "defs.h"
#include "hardware.h"
#include "JTAGfunc.h"

#ifndef __BYTEWORD__
#define __BYTEWORD__
typedef unsigned int    word;
typedef unsigned char   byte;
#endif

// Constants for runoff status
#define STATUS_ERROR    0        // false
#define STATUS_OK       1        // true
#define STATUS_ACTIVE   2            
#define STATUS_IDLE     3

//----------------------------------------------------------------------------
// Pin-to-Signal Assignments
//----------------------------------------------------------------------------

// Constants for VPP (Fuse blowing voltage) control port:
#define VPPOUT        P3OUT   // VPP ports are P3.x
#define VPPDIR        P3DIR
#define VPPSEL        P3SEL    
#define VPPONTEST     0x01    // P3.0 Fuse voltage switched to TEST
#define VPPONTDI      0x02    // P3.1 Fuse voltage switched to TDI

/*----------------------------------------------------------------------------
   Macros for processing the JTAG port and Vpp pins
*/
#define ClrTMS()        ((JTAGOUT) &= (~TMS))
#define SetTMS()        ((JTAGOUT) |= (TMS))
#define ClrTDI()        ((JTAGOUT) &= (~TDI))
#define SetTDI()        ((JTAGOUT) |= (TDI))
#define ClrTCK()        ((JTAGOUT) &= (~TCK))
#define SetTCK()        ((JTAGOUT) |= (TCK))
#define ClrTCLK()       ((JTAGOUT) &= (~TCLK))
#define SetTCLK()       ((JTAGOUT) |= (TCLK))
#define StoreTCLK()     ((JTAGOUT  &   TCLK))
#define RestoreTCLK(x)  (x == 0 ? ClrTCLK() : SetTCLK())
#define ScanTDO()       ((JTAGIN   &   TDO) ? 1 : 0)
#define VPPon(x)        (x == VPP_ON_TEST ? (VPPOUT |= VPPONTEST) : (VPPOUT |= VPPONTDI))
#define VPPoff()        ((VPPOUT)  &= (~(VPPONTDI | VPPONTEST)))

/*----------------------------------------------------------------------------
   Low Level function prototypes
*/
void Delay(word Millisec);
void InitTarget(void);
void ReleaseTarget(void);
word Shift(word Format, word Data);    // used for IR- as well as DR-shift
void TDOisInput(void);
void TCLKstrobes(word Amount);

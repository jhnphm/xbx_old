
// From msp430-gcc 
//#include <io.h>
//#include <interrupt.h>
//#include <io430xG46x.h>
#include <msp430fg4618.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdint.h>
//#include "msp430libtypes.h"
//#include <io430xG46x.h>
/*#include <intrinsics.h>
#include <stdint.h>
*/

#include "i2c.h"

//#include "uart2.h"



// Standard I2C bit rates are:

// 100KHz for slow speed

// 400KHz for high speed








// I2C state and address variables



//static u08 I2cDeviceAddrRW;

// send/transmit buffer (outgoing data)

static u08 I2cSendData[I2C_SEND_DATA_BUFFER_SIZE];

static u08 I2cSendDataIndex;

static u08 I2cSendDataLength;

// receive buffer (incoming data)

static u08 I2cReceiveData[I2C_RECEIVE_DATA_BUFFER_SIZE];

static u08 I2cReceiveDataIndex;

//static u08 I2cReceiveDataLength;



// function pointer to i2c receive routine

//! I2cSlaveReceive is called when this processor

// is addressed as a slave for writing

static void (*i2cSlaveReceive)(u08 receiveDataLength, u08* recieveData);

//! I2cSlaveTransmit is called when this processor

// is addressed as a slave for reading

static u08 (*i2cSlaveTransmit)(u08 transmitDataLengthMax, u08* transmitData);



// functions

void i2cInit(void)

{

        WDTCTL = WDTPW + WDTHOLD;
	P3SEL |= 0x06;                            // Assign I2C pins to USCI_B0
  	UCB0CTL1 |= UCSWRST;                      // Enable SW reset
  	UCB0CTL0 = UCMODE_3 + UCSYNC;             // I2C Slave, synchronous mode
  	UCB0CTL1 = UCSSEL_2 + UCSWRST;            // Use SMCLK, keep SW reset
  	UCB0BR0 = 11;                             // fSCL = SMCLK/11 = 95.3kHz
  	UCB0BR1 = 0;
  	
  	//IE2 |= UCB0TXIE;                          // Enable USCI_B0 TX interrupt

	


	// clear SlaveReceive and SlaveTransmit handler to null

	i2cSlaveReceive = 0;

	i2cSlaveTransmit = 0;

	// set i2c bit rate to 100KHz

	i2cSetBitrate(100);


	// set state
	

	

	// do not enable interrupts


}



void i2cSetBitrate(u16 bitrateKHz)

{

	// calculate bitrate division	
	//clock from SMCLK, reciever (default), hold in reset
	UCB0CTL1 = UCSSEL1 | UCSWRST;
	UCB0BR1 = 0;				//upper byte of divider word
	UCB0BR0 = 1000000/bitrateKHz;		// lower byte

}



void i2cSetLocalDeviceAddr(u08 deviceAddr, u08 genCallEn)

{

	// set local device address (used in slave mode only)

	UCB0I2COA = (deviceAddr | (genCallEn?UCGCEN:0));
        UCB0CTL1 &= ~UCSWRST;                     // Clear SW reset, resume operation

}



void i2cSetSlaveReceiveHandler(void (*i2cSlaveRx_func)(u08 receiveDataLength, u08* recieveData))

{

	i2cSlaveReceive = i2cSlaveRx_func;

}



void i2cSetSlaveTransmitHandler(u08 (*i2cSlaveTx_func)(u08 transmitDataLengthMax, u08* transmitData))

{

	i2cSlaveTransmit = i2cSlaveTx_func;

}





//! I2C (TWI) interrupt service routine



/** dsk: disabled interrupt */

void twi_isr(){


	if(UCB0STAT&UCSTTIFG){		//start condition?
		UCB0STAT &= ~UCSTTIFG;  //yes: clear start flag
		I2cSendDataIndex = 0;	//reset counters
		I2cReceiveDataIndex = 0;
	}
	if(UCB0STAT&UCSTPIFG){
		UCB0STAT &= ~UCSTPIFG;
		// i2c receive is complete, call i2cSlaveReceive

		if(i2cSlaveReceive) i2cSlaveReceive(I2cReceiveDataIndex, I2cReceiveData);
	}


	if(IFG2&UCB0RXIFG) {

		if(I2cReceiveDataIndex < I2C_RECEIVE_DATA_BUFFER_SIZE)

		{

			// receive data byte and return ACK

			I2cReceiveData[I2cReceiveDataIndex] = UCB0RXBUF;
                        I2cReceiveDataIndex++;

		}

		else

		{

			// receive data byte and return NACK

			I2cReceiveData[I2cReceiveDataIndex] = UCB0RXBUF;
			UCB0CTL1 |= UCTXNACK;
                        I2cReceiveDataIndex++;


		}


	}
            

  if(IFG2&UCB0TXIFG){       
	  if(I2cSendDataIndex==0){
		// request data from application

		if(i2cSlaveTransmit) {I2cSendDataLength = i2cSlaveTransmit(I2C_SEND_DATA_BUFFER_SIZE, I2cSendData);
		}
	  }
	  UCB0TXBUF=I2cSendData[I2cSendDataIndex];
          I2cSendDataIndex++;
  }
}

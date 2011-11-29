#include <msp430fg4618.h>
#include "global.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdint.h>

#include "RS232.h"
//#include "msp430libtypes.h"
//#define F_CPU 10000000 // Cpu frequency (speed of SMCLK)

void usart_init(uint32_t baudrate)
{
  // Set usart into config
  UCA0CTL1 = UCSSEL1|UCSWRST;        // **Initialize USCI and set clock to use smclk
  UCA0CTL0 = 0x00;			//  UCSRC to, Asyncronous 8N1

  // Baud rate selection
  // TODO Need to genercize for different F_CLK
  UCA0BR1 = 0x09;       
  UCA0BR0 = 0x01;
  UCA0MCTL = 0x01<<4;

  //Port select
  P4SEL |= 0x0C0;                           // P4.7,6 = USCI_A0 RXD/TXD


  UCA0CTL1 &= ~UCSWRST;                     // **Initialize USCI state machine**
  //IE2_bit.UCA0RXIE = 1;       // RX Complete interrupt enabled
}

void usart_putc(char data) {
    while (!(UCA0TXIFG & UCA0TXIFG)); 
	UCA0TXBUF = data;
}

char usart_getc(void)
{
    while (!(IFG2 & UCA0RXIFG));   
    return UCA0RXBUF;                   
}

void usart_putbyte(uint8_t val) {
	char ch;
	uint8_t nibble = (val & 0xf0)>>4;
	if(nibble < 10 && nibble > 0)
		ch='0'+nibble;
	else if(nibble >=10)
			ch='a'+nibble-10;
		else
			ch='0';

	usart_putc(ch);


	nibble = val & 0xf;

	if(nibble < 10 && nibble > 0)
		ch='0'+nibble;
	else if(nibble >=10)
			ch='a'+nibble-10;
		else
			ch='0';

	usart_putc(ch); 
}

void usart_puts(char *data) {
  int len, count;
  
  len = strlen(data);
  for (count = 0; count < len; count++) 
    usart_putc(*(data+count));
}

void usart_putint (int usart_num)				/* Writes integer to the USART		*/
{
 char usart_ascii_string[6]="      ";		/* Reservation to the max absvalue (2^16)/2		*/
 
 //itoa(usart_num, usart_ascii_string, 10);	/* Convert integer to ascii [not ansi c]		*/
 sprintf(usart_ascii_string, "%d", usart_num); //sprintf <=> itoa
 usart_puts(usart_ascii_string);		/* Sens ascii pointer to the lcd_printf()		*/
}

void usart_putu32hex(u32 num)
{
	char s[10];
	//usart_puts( ltoa(num,s,16) );
        sprintf(s,"%lX",num);
        usart_puts(s);

}



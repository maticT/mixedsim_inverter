/**
 * \file
 * \brief Motor Force Controller
 * \author Uros Platise <uros@isotel.eu>
 */
 
#include <stdint.h>
#include <stdio.h>
#include "c_algorithm.h"
#include "d_process.h"

// Function converts a 16bit number to an 8bit one
void convert_u16_u8(uint16_t inp, uint8_t *out1, uint8_t *out2)
{
	*out2=inp>>8; 			// Shift upper part by 8
	*out1=inp-256*(*out2);	// Convert lower part to 8 bit
}

/**
 * Function is called at A/D Sample Rate, and accumulates 64 samples, then
 * executes simple PI regulator and outputs an 8-bit PWM.
 */
uint16_t c_algorithm(uint16_t input, uint8_t output[D_PROCESS_DLEN(DIGITAL_OUT)])
{
	uint16_t dt=40;		// Dead-time 
	uint16_t c1,c2,c3,c4,c5,c6;
	
	c1=400;
	c2=800;
	c3=1200;
	
	c4=1400;
	c5=1800;
	c6=2200;
	
	convert_u16_u8(dt,&output[0],&output[1]);
	convert_u16_u8(c1,&output[2],&output[3]);
	convert_u16_u8(c2,&output[4],&output[5]);
	convert_u16_u8(c3,&output[6],&output[7]);
	convert_u16_u8(c4,&output[8],&output[9]);
	convert_u16_u8(c5,&output[10],&output[11]);
	convert_u16_u8(c6,&output[12],&output[13]);
	
    return 0;
}

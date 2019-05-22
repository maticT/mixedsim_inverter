/**
 * \file
 * \brief Motor Force Controller
 * \author Uros Platise <uros@isotel.eu>
 */
 
#include <stdint.h>
#include <stdio.h>

#define REGULATOR_SCALE_SHIFT   6       /// Kp, and Ki are multiplied by 2^6

/**
 * Function is called at A/D Sample Rate, and accumulates 64 samples, then
 * executes simple PI regulator and outputs an 8-bit PWM.
 */
uint16_t motor_controller(uint16_t dt, uint16_t counter_in, uint16_t compare1, uint16_t compare2, uint16_t compare3,
						 uint16_t compare4, uint16_t compare5, uint16_t compare6, uint8_t reset) {
	static uint8_t ad_sample_count = 0;
	static int32_t sample_acc = 0;
	static uint8_t pwm = 0;


    if (reset) {
        fprintf(stderr, "Firmware Reset\n");
        ad_sample_count = 0;
        sample_acc = 0;
    }
    else {
        if (++ad_sample_count > 32) {
            ad_sample_count = 0;
            sample_acc >>= 5;
            
            integ += e * Ki;
            int32_t out = (e * Kp + integ * Ki) >> REGULATOR_SCALE_SHIFT;
            pwm = (out > 255) ? 255 : (out < 0) ? 0 : out;
            
            fprintf(stderr, "I = %d, e = %d, integ = %d, PWM = %d\n", sample_acc, e, integ, pwm);
            sample_acc = 0;
        }
        else {
            sample_acc += sample;
        }
    }    
    return pwm;
}

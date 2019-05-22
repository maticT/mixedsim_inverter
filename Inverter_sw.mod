*Inverter 3 veje SWITCH

.include yosys/prim_cells_ngspice.mod
.include PWM2.mod
.include ad12.mod

.subckt inv pwm1 pwm2 pwm3 pwm4 pwm5 pwm6 isenp isenm vddio

* Parametri
.param Vdc=12
.param trf=10n
.param per=50u

* Krmilnik
Vrst rst 0 DC(0) PULSE(0 5 0.5us 10ns 10ns 2us)
Aabridge [rst] [drst] adc_buff
.model adc_buff adc_bridge(in_low = 1 in_high = 1)

.model ad_clk_m d_osc(cntl_array=[0 1] freq_array=[512e3 512e3])
Aadclk 0 adclk ad_clk_m
.model pwm_clk_m d_osc(cntl_array=[0 1] freq_array=[4.096e6 4.096e6])
Apwmclk 0 pwmclk pwm_clk_m

Vref ref 0 DC(1.024)

* Napajalna napetost
V1 vdc vsh DC {Vdc}
C1 vdc vsh 3300u

* Breme
Rs1 L1 P001 10m
Rs2 L2 P002 10m
Rs3 L3 P003 10m
Ls1 P001 out 50µ
Ls2 P002 out 50µ
Ls3 P003 out 50µ

* Shunt
Bsense uin 0 V=v(isenp, isenm) * 1
Xad uin ref vddio adclk d11 d10 d9 d8 d7 d6 d5 d4 d3 d2 d1 d0 ad12

* Povezava z Firmware-om v C
.model firmware d_process(process_file="firmware/main" process_params=[])
Acontrol [d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11] 
+ adclk drst [w0d w1d w2d w3d w4d w5d w6d w7d w8d w9d w10d w11d w12d w13d w14d w15d]
+ [w0i w1i w2i w3i w4i w5i w6i w7i w8i w9i w10i w11i w12i w13i w14i w15i]
+ [w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w110 w111 w112 w113 w114 w115]
+ [w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w210 w211 w212 w213 w214 w215]
+ [w30 w31 w32 w33 w34 w35 w36 w37 w38 w39 w310 w311 w312 w313 w314 w315]
+ [w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w410 w411 w412 w413 w414 w415]
+ [w50 w51 w52 w53 w54 w55 w56 w57 w58 w59 w510 w511 w512 w513 w514 w515]
+ [w60 w61 w62 w63 w64 w65 w66 w67 w68 w69 w610 w611 w612 w613 w614 w615]
+ null null null null null null null null null firmware

* PWM Output
Xpwmx pwmclk drst null null null null null null null null null null null null null null null null
+ null null null null null null null null null null null null null null null null
+ w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w110 w111 w112 w113 w114 w115
+ w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w210 w211 w212 w213 w214 w215
+ w30 w31 w32 w33 w34 w35 w36 w37 w38 w39 w310 w311 w312 w313 w314 w315
+ w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w410 w411 w412 w413 w414 w415
+ w50 w51 w52 w53 w54 w55 w56 w57 w58 w59 w510 w511 w512 w513 w514 w515
+ w60 w61 w62 w63 w64 w65 w66 w67 w68 w69 w610 w611 w612 w613 w614 w615 
+ null null null c1 c2 c3 c4 c5 c6 PWM2

.model dac_buff1 dac_bridge
Adbridge [c1] [pwma1] dac_buff1
Bpwmo1 v2p v2n V=v(pwma1)*v(vddio)

.model dac_buff2 dac_bridge
Adbridge [c2] [pwma2] dac_buff2
Bpwmo2 v3p v3n V=v(pwma2)*v(vddio)

.model dac_buff3 dac_bridge
Adbridge [c3] [pwma3] dac_buff3
Bpwmo3 v4p v4n V=v(pwma3)*v(vddio)

.model dac_buff4 dac_bridge
Adbridge [c4] [pwma4] dac_buff4
Bpwmo4 v5p v5n V=v(pwma4)*v(vddio)

.model dac_buff5 dac_bridge
Adbridge [c5] [pwma5] dac_buff5
Bpwmo5 v6p v6n V=v(pwma5)*v(vddio)

.model dac_buff6 dac_bridge
Adbridge [c6] [pwma6] dac_buff6
Bpwmo6 v7p v7n V=v(pwma6)*v(vddio)


* Stikalna logika
* V2 v2+ v2- PULSE(0 {Vdc} 16u {trf} {trf} 29u {per})
* V3 v3+ v3- PULSE({Vdc} 0 15u {trf} {trf} 31u {per})
* V4 v4+ v4- PULSE(0 {Vdc} 21u {trf} {trf} 19u {per})
* V5 v5+ v5- PULSE({Vdc} 0 19u {trf} {trf} 21u {per})
* V6 v6+ v6- PULSE(0 {Vdc} 26u {trf} {trf} 9u {per})
* V7 v7+ v7- PULSE({Vdc} 0 25u {trf} {trf} 11u {per})
XX1 v2p v2n vdc L1 sw_mosfet
XX2 v3p v3n L1 0 sw_mosfet
XX3 v4p v4n vdc L2 sw_mosfet
XX4 v5p v5n L2 0 sw_mosfet
XX5 v6p v6n vdc L3 sw_mosfet
XX6 v7p v7n L3 0 sw_mosfet

* Shunt
R1 0 vsh 1m

* block symbol definitions
.subckt sw_mosfet inp inn vp vn
S1 vp vn inp inn SW_ON
D1 vn vp D
.param sw_hyst=-0.1 Lsw=0
.model SW_ON SW Ron=1m  Roff=1meg Vt=3 Vh=sw_hyst 
.ends sw_mosfet

.ends

.end

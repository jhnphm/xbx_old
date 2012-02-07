/*****************************************************************************
Written and Copyright (C) by Ingo von Maurich
and the Secure Hardware Group of Ruhr-Universitaet Bochum. 
All rights reserved.

Contact ingo.vonmaurich@rub.de for comments & questions.
This program is free software; You may use it or parts of it or
modifiy it under the following terms:

(1) Usage and/or redistribution and/or modification of the software 
or parts of the software is permitted for non-commercial use only.

(2a) If this software or parts are used as part of a new software, you
must license the entire work, as a whole, under this License to anyone
who comes into possession of a copy. This License will therefore
apply, to the whole of the work, and all its parts, regardless of how
they are packaged.

(2b) You may expand this license by your own license. In this case this
license still applies to the software as mentioned in (2a) and must
not be changed. The expansion must be clearly recognizable as such. In
any case of collision between the license and the expansion the
license is superior to the expansion.

(3) If this software or parts are used as part of a new software, you
must provide equivalent access to the source code of the entire work,
as a whole, to anyone who comes into possession of a copy, in the same
way through the same place at no further charge, as for the binary
version.

(4) This program is distributed in the hope that it will be useful,
but   WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
(5) These notices must be retained in any copies of any part of this
documentation and/or software.

(6) If this software is used credit must be given to the
"Secure Hardware Group of Ruhr-Universitaet Bochum, Germany" as
the authors of the parts of the software used. This can be in the form
of a textual message at program startup or at *beginning* of the
documentation (online or textual) provided with the package.

If you are interested in a commercial use 
please contact ingo.vonmaurich@rub.de.
/*****************************************************************************/

.NOLIST

.set a_hi			, 0
.set a_mh			, 1
.set a_ml			, 2
.set a_lo			, 3
.set b_hi			, 4
.set b_mh			, 5
.set b_ml			, 6
.set b_lo			, 7
.set c_hi			, 8
.set c_mh			, 9
.set c_ml			, 10
.set c_lo			, 11
.set d_hi			, 12
.set d_mh 			, 13
.set d_ml 			, 14
.set d_lo			, 15
.set temp 			, 16
.set temp2 			, 17
.set temp3 			, 18
.set offsetcounter	, 18
.set i 				, 19
.set v_round		, 20
.set sigr1 			, 21
.set sigr2 			, 22
.set eormc_hi 		, 23
.set eormc_mh 		, 24
.set eormc_ml 		, 25
.set xl			,26
.set xh			,27
.set yl			,28
.set yh			,29
.set zl			,30
.set zh			,31

; memory offsets
.equ offset_salt	, 32
.equ offset_counter , 48
.equ offset_msg_ptr , 56
.equ offset_padding , 58
.equ offset_state 	, 59
.equ offset_const	, 123

; different padding possibilities
.equ NO_NEXT_BLOCK 	, 1
.equ FULL_EXTRA_BLOCK , 2
.equ EXTRA_BLOCK 	, 3

.LIST

.MACRO G a, b, c, d, e, f
	
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	adiw xl,\a
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
	adiw xl,\b
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+
	adiw xl,\c
	ld d_hi,X+
	ld d_mh,X+
	ld d_ml,X+
	ld d_lo,X+

; call Gi here
	rcall gi
; store back to state in SRAM

	st -X,d_lo
	st -X,d_ml
	st -X,d_mh
	st -X,d_hi
	sbiw xl,\d
	st -X,c_lo
	st -X,c_ml
	st -X,c_mh
	st -X,c_hi
	sbiw xl,\e
	st -X,b_lo
	st -X,b_ml
	st -X,b_mh
	st -X,b_hi
	sbiw xl,\f
	st X+,a_hi
	st X+,a_mh
	st X+,a_ml
	st X+,a_lo

.ENDM

; void blake_init(unsigned char *state);
; parameter is given in R25:R24

.global blake_init
.func blake_init
blake_init:

	push 16
	push 17
	push 25
	push 26
	push 27
	push 28
	push 29
	push 30
	push 31

	movw zl,24
	movw yl,zl
	movw xl,zl
; set memory at offset_padding to 0
	ldi temp,0
	std Z+offset_padding,temp  
; set the counter to 0
init_counter:
	adiw zl,offset_counter
	st Z+,temp
	st Z+,temp
	st Z+,temp
	st Z+,temp
	st Z+,temp
	st Z+,temp
	st Z+,temp
	st Z+,temp
	sbiw zl,offset_counter+8-offset_salt
; set the salt to 0 (needs to be changed if salt-support is necessary)
init_salt:	
	ldi temp2,16			; iterate 16 times
loop_init_salt:				; set all salt values to 0
	st Z+,temp				; store 0 as salt 
	dec temp2				; decrease counter
	brne loop_init_salt

; copy the constants from flash to sram
init_constants:
	adiw yl,63
	adiw yl, offset_const-63
	ldi zl,lo8(constants)
	ldi zh,hi8(constants)

	ldi temp2,64
loop_init_constants:
	lpm temp,Z+
	st Y+,temp
	dec temp2
	brne loop_init_constants

; copy the IV's from flash to sram
load_iv:	
	ldi zl,lo8(ivs)
	ldi zh,hi8(ivs)
	ldi temp2,32

loop_iv:						
	lpm temp,Z+
	st X+,temp
	dec temp2
	brne loop_iv  

	pop 31
	pop 30
	pop 29
	pop 28
	pop 27
	pop 26
	pop 25
	pop 17
	pop 16

	ret
.endfunc





.global blake_compress
.func blake_compress
blake_compress:

	push 0
	push 1
	push 2
	push 3
	push 4
	push 5
	push 6
	push 7
	push 8
	push 9
	push 10
	push 11
	push 12
	push 13
	push 14
	push 15
	push 16
	push 17
	push 18
	push 19
	push 20
	push 21
	push 22
	push 23
	push 24
	push 25
	push 26
	push 27
	push 28
	push 29
	push 30
	push 31

HASH:
	movw xl,R20
	movw yl,R22
	movw zl,R24
	
; save the messagepointer to be able to restore it whenever necessary
	std Z+offset_msg_ptr,yh
	std Z+offset_msg_ptr+1,yl

; is msb of X is not set -> no padding needed because it is not the last block
	sbrs xh,7
; if msb of X is set, the block can have a length != 0 mod 512
	rjmp no_padding

; check which padding needs to be done
padding:
	cbr xh,128
	ldd temp,Z+offset_padding
	cpi temp,EXTRA_BLOCK
	brne no_extra_block
; else handling an extra block -> proceed with loading chain value
	movw xl,zl
	movw yl,zl
	rjmp load_chain

no_extra_block:
; is the last message block of length 512? (0x200 = 512)
	ldi temp2,hi8(0x200)
	ldi temp,lo8(0x200)
	cp xl,temp
	cpc xh,temp2
	brne test_next
; if length is 512, a new block has to be created, consisting of padding only
	rjmp padd_complete_new_block_next_round

test_next:
; is the last message block of length equal or greater than 447? (0x1BF = 447)
	ldi temp,hi8(0x1BF)
	ldi temp2,lo8(0x1BF)
	cp xl,temp2
	cpc xh,temp
	brge test_next2
; if length is shorter, in-place padding has to be done
	rjmp padd_in_place

test_next2:
; else case: 447 <= length < 512
	movw r20,xl
	movw r22,yl
	mov temp,xl
	andi temp,7
	lsr r21
	ror r20
	lsr r21
	ror r20
	lsr r21
	ror r20
	add yl,r20
	adc yh,r21
	ldi temp2,7
	ldi temp3,0x01
	ldi r19,0xFF
; search the bit-position where the first 1 has to be placed
loop_padd_1:
	cp temp,temp2
	breq padd_1
	lsl temp3
	lsl r19
	dec temp2
	brne loop_padd_1
; set the first 1
padd_1:
	ld temp,Y
	and temp,r19	; set 0000
	or temp,temp3 	; set 1
	st Y+,temp
	
; set remaining bits to 0
	ldi temp,0
padd_0:
	cpi r20,63
	breq padd_0_end
	inc r20
	st Y+,temp	
	rjmp padd_0
; update counter	
padd_0_end:
	ldi temp2,NO_NEXT_BLOCK
	std Z+offset_padding,temp2
	movw yl,zl
	adiw yl,offset_counter
	ld a_hi,Y+
	ld a_mh,Y+
	ld a_ml,Y+
	ld a_lo,Y+
	ld b_hi,Y+
	ld b_mh,Y+
	ld b_ml,Y+
	ld b_lo,Y+	
	add a_lo,xl
	adc a_ml,xh
	brcc no_carry_2
	adc a_mh,temp
	adc a_hi,temp
	adc b_lo,temp
	adc b_ml,temp
	adc b_mh,temp
	adc b_hi,temp
no_carry_2:
	st -Y,b_lo
	st -Y,b_ml
	st -Y,b_mh
	st -Y,b_hi
	st -Y,a_lo
	st -Y,a_ml
	st -Y,a_mh
	st -Y,a_hi
	movw xl,zl
	movw yl,zl
; proceed loading the chain value
	rjmp load_chain

padd_complete_new_block_next_round:
; set information that a new block consiting of padding only is needed in the next round
	ldi temp2,FULL_EXTRA_BLOCK
	std Z+offset_padding,temp2
	rjmp no_padding
; in-place padding has to be done, first update the counter
padd_in_place:
	movw r20,xl
	movw xl,zl
	adiw xl,offset_counter
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+	
	add a_lo,r20
	adc a_ml,r21
; if no carry occurs, skip carry additions
	brcc nocarry_1
	clr temp
	adc a_mh,temp
	adc a_hi,temp
	adc b_lo,temp
	adc b_ml,temp
	adc b_mh,temp
	adc b_hi,temp

nocarry_1:
	st -X,b_lo
	st -X,b_ml
	st -X,b_mh
	st -X,b_hi
	st -X,a_lo
	st -X,a_ml
	st -X,a_mh
	st -X,a_hi
; find the bit where to place the first 1
	movw xl,r20
	movw r22,yl
	mov temp,xl
	andi temp,7
	lsr r21
	ror r20
	lsr r21
	ror r20
	lsr r21
	ror r20
	add yl,r20
	adc yh,r21
	ldi temp2,7
	ldi temp3,0x01
	ldi r19,0xFF

loop_padd_1_2:
	cp temp,temp2
	breq padd_1_2
	lsl temp3
	lsl r19
	dec temp2
	brne loop_padd_1_2
; place the first 1
padd_1_2:
	ld temp,Y
	and temp,r19	; set 0000
	or temp,temp3 	; set 1
	st Y+,temp
	
; set remaining bits to 0
	ldi temp,0
padd_0_2:
	cpi r20,63
	breq padd_2nd_1_2
	st Y+,temp
	inc r20
	rjmp padd_0_2
; place the second 1 followed by the 64bit counter in big endian notation
padd_2nd_1_2:
	sbiw yl,9
	ld temp,Y
	ori temp,1
	st Y+,temp
	adiw zl,offset_counter
	adiw yl,4 ; for big endianess
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	sbiw yl,8
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	sbiw zl,offset_counter+8
; restore pointer and proceed loading the chain value
	movw yl,zl
	movw xl,zl
	rjmp load_chain
; if the message block is not the last block, no padding is needed
no_padding:	
	movw yl,zl
	movw xl,zl
; add 512 = 0x200 to counter
	adiw xl,offset_counter
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
; a_lo does not need an addition because it would be an addition by 0
; just add 2 to a_ml
	ldi temp,2
	add a_ml,temp
	brcc nocarry_2
	clr temp
	adc a_mh,temp
	adc a_hi,temp
	adc b_lo,temp
	adc b_ml,temp
	adc b_mh,temp
	adc b_hi,temp

nocarry_2:
	st -X,b_lo
	st -X,b_ml
	st -X,b_mh
	st -X,b_hi
	st -X,a_lo
	st -X,a_ml
	st -X,a_mh
	st -X,a_hi
	sbiw xl,offset_counter

; load the chain value into state (Y points to the beginning of sram where the chainvalue is stored)
load_chain:
	adiw xl,offset_state
	ldi temp2,32	
loop_load_chain:
	ld temp,Y+
	st X+,temp
	dec temp2
	brne loop_load_chain
; load constants and salt, xor them and store the result to state
load_sc:
	ldi temp, offset_const
	add zl,temp
; temp2 is 0 because it was decreased from 32 to 0 in the loop before
	adc zh,temp2
; Y = Y-32+offset_salt
	sbiw yl,32-offset_salt
	ldi temp3,16

loop_sc:
	ld temp,Z+
	ld temp2,Y+
	eor temp,temp2
	st X+,temp
	dec temp3
	brne loop_sc
	
; load counter and constants, xor them and store the result to state
load_tc:
	ldi temp2,2
	ld r0,Y+
	ld r1,Y+
	ld r2,Y+
	ld r3,Y+

loop_tc:
	ld temp,Z+
	eor temp,r0
	st X+,temp	
	ld temp,Z+
	eor temp,r1
	st X+,temp	
	ld temp,Z+
	eor temp,r2
	st X+,temp	
	ld temp,Z+
	eor temp,r3
	st X+,temp
	dec temp2
	brne loop_tc
	
load_tc2:
	ld r0,Y+
	ld r1,Y+
	ld r2,Y+
	ld r3,Y+
	ldi temp2,2

loop_tc2:
	ld temp,Z+
	eor temp,r0
	st X+,temp	
	ld temp,Z+
	eor temp,r1
	st X+,temp	
	ld temp,Z+
	eor temp,r2
	st X+,temp	
	ld temp,Z+
	eor temp,r3
	st X+,temp
	dec temp2
	brne loop_tc2
	
; start of the roundfunction
round_function:
	sbiw xl,63
	sbiw xl,1
	ldi v_round,-0x10
	movw zl,xl
	sbiw zl,offset_state
	ldd yh,Z+offset_msg_ptr
	ldd yl,Z+offset_msg_ptr+1
	clt

do_round:
	clr offsetcounter
	clr i
	ldi temp,0x10
	add v_round,temp
	cpi v_round, 0xA0
	brne check_end
	set
	clr v_round

check_end:
	brtc start_rnd
	cpi v_round,0x40
	brne start_rnd
	clt
	rjmp final
	
;G0(v0 , v4 , v8 , v12) G1(v1 , v5 , v9 , v13) 
;G2(v2 , v6 , v10, v14) G3(v3 , v7 , v11, v15)
;G4(v0 , v5 , v10, v15) G5(v1 , v6 , v11, v12) 
;G6(v2 , v7 , v8 , v13) G7(v3 , v4 , v9 , v14)

start_rnd:
	ldi temp3,4	
	ldi temp2,offset_const
	add zl,temp2
	clr temp2
	adc zh,temp2

loop_rnd:	
;G0(v0 , v4 , v8 , v12) 
;G1(v1 , v5 , v9 , v13) 
;G2(v2 , v6 , v10, v14) 
;G3(v3 , v7 , v11, v15)

	G 12, 12, 12, 12, 12, 16
	dec temp3
	brne loop_rnd	

;G4(v0 , v5 , v10, v15)
; loading v15 can be skipped because it is already loaded in G3
	sbiw xl,16	
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	adiw xl,16
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
	adiw xl,16
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+
; call Gi here
	rcall gi
; store back
	st -X,c_lo
	st -X,c_ml
	st -X,c_mh
	st -X,c_hi
	adiw xl,20
	st X+,d_hi
	st X+,d_mh
	st X+,d_ml
	st X+,d_lo
	sbiw xl,44
	st X+,b_hi
	st X+,b_mh
	st X+,b_ml
	st X+,b_lo
	sbiw xl,24
	st X+,a_hi
	st X+,a_mh
	st X+,a_ml
	st X+,a_lo

;G5(v1 , v6 , v11, v12)

	G 16,16,0,0,16,20

;G6(v2 , v7 , v8 , v13) 

	G 16,0,16,16,0,20

;G7(v3 , v4 , v9 , v14)
	
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
	adiw xl,16
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+
	adiw xl,16
	ld d_hi,X+
	ld d_mh,X+
	ld d_ml,X+
	ld d_lo,X+

; call Gi here
	rcall gi
; store back	
	st -X,d_lo
	st -X,d_ml
	st -X,d_mh
	st -X,d_hi
	sbiw xl,16
	st -X,c_lo
	st -X,c_ml
	st -X,c_mh
	st -X,c_hi
	sbiw xl,16
	st -X,b_lo
	st -X,b_ml
	st -X,b_mh
	st -X,b_hi

	st -X,a_lo
	st -X,a_ml
	st -X,a_mh
	st -X,a_hi	

	ldi temp2,offset_const
	sub zl,temp2
; temp is already cleared in gi
	sbc zh,temp
	sbiw xl,12
	rjmp do_round
	
; avoid running into functions
func_loop: rjmp func_loop

; functions

; gi(a,b,c,d)
;a =  a + b + (m sigr(2i) XOR c sigr(2i+1))
;d =  (d XOR a) << 16
;c =  c + d
;b =  (b XOR c) << 12
;a =  a + b + (m sigr(2i+1) XOR c sigr(2i))
;d =  (d XOR a) << 8
;c =  c + d
;b =  (b XOR c) << 7

;load sig(v_round)(2i) and sig(v_round)(2i+1)
; v_round selects row in sigma table, offset in first round v_round=0, second round v_round=0x10, third v_round=0x20...
; i selects column 
	
gi:

; a = a + b + (m sigr(2i) xor c sigr(2i+1))	
	mov temp,i
	lsl temp
	add temp,v_round
; save Z pointer
	movw r24,zl
	ldi zl,lo8(sigma)		; load sigma table pointer into Z
	ldi zh,hi8(sigma)
	add zl,temp				; add offset to zl
	clr temp				; clear temp
	adc zh,temp				; add possbile carry to zh
	lpm sigr1,Z+			; read first sigma value (2i)
	lpm sigr2,Z				; read second sigma value (2i+1)
	inc i					; i = i + 1 for next round
;load constant c sigr2 and eor with m sigr1	

; restore Z pointer
	movw zl,r24
	lsl sigr2
	lsl sigr2
	lsl sigr1
	lsl sigr1
	
	add zl,sigr2
	adc zh,temp

	add yl,sigr1
	adc yh,temp

	ld eormc_hi,Z+
	ld temp,Y+
	eor eormc_hi,temp
		
	ld eormc_mh,Z+
	ld temp,Y+
	eor eormc_mh,temp
	
	ld eormc_ml,Z+
	ld temp,Y+
	eor eormc_ml,temp
	
	ld temp,Z+
	ld temp2,Y+
	eor temp,temp2

	add a_lo,temp
	adc a_ml,eormc_ml
	adc a_mh,eormc_mh
	adc a_hi,eormc_hi	

; 32 bit add of a and b, result is stored in a
	add a_lo,b_lo
	adc a_ml,b_ml
	adc a_mh,b_mh
	adc a_hi,b_hi

; d = (d xor a) >> 16
; 32 bit xor of d and a, result is stored in d
	eor d_lo,a_lo
	eor d_ml,a_ml
	eor d_mh,a_mh
	eor d_hi,a_hi
; 16 bit rotation is done by swapping
	movw temp,d_hi
	movw d_hi,d_ml
	movw d_ml,temp

; c = c+d
; 32 bit add of c and d, result is stored in c
	add c_lo,d_lo
	adc c_ml,d_ml
	adc c_mh,d_mh
	adc c_hi,d_hi
	

; b = (b xor c) >> 12
; 32 bit xor of b and c, result is stored in b
	eor b_lo,c_lo
	eor b_ml,c_ml
	eor b_mh,c_mh
	eor b_hi,c_hi

; idea: >>>>16 + <<<<4 = 12

;	>>>>16
	movw temp,b_hi
	movw b_hi,b_ml
	movw b_ml,temp
;	<<<<4
	clr temp2
	lsl b_lo
	rol b_ml
	rol b_mh
	rol b_hi
	adc b_lo,temp2
	lsl b_lo
	rol b_ml
	rol b_mh
	rol b_hi
	adc b_lo,temp2
	lsl b_lo
	rol b_ml
	rol b_mh
	rol b_hi
	adc b_lo,temp2
	lsl b_lo
	rol b_ml
	rol b_mh
	rol b_hi
	adc b_lo,temp2

; a = a + b + (m sigr(2i+1) xor c sigr(2i))
	sub zl,sigr2
	sbc zh,temp2

	sub yl,sigr1
	sbc yh,temp2

	add zl,sigr1
	adc zh,temp2

	add yl,sigr2
	adc yh,temp2

	ld temp,-Z
	ld temp2,-Y
	eor temp2,temp

	ld eormc_ml,-Z
	ld temp,-Y
	eor eormc_ml,temp

	ld eormc_mh,-Z
	ld temp,-Y
	eor eormc_mh,temp

	ld eormc_hi,-Z
	ld temp,-Y
	eor eormc_hi,temp

	add a_lo,temp2
	adc a_ml,eormc_ml
	adc a_mh,eormc_mh
	adc a_hi,eormc_hi	

	clr temp
	sub zl,sigr1
	sbc zh,temp
	sub yl,sigr2
	sbc yh,temp

; 32 bit add of a and b, result is stored in a
	add a_lo,b_lo
	adc a_ml,b_ml
	adc a_mh,b_mh
	adc a_hi,b_hi

; d = (d xor a) >> 8
; 32 bit xor of d and a, result is stored in d
	eor d_lo,a_lo
	eor d_ml,a_ml
	eor d_mh,a_mh
	eor d_hi,a_hi

; 8 bit rotation is done by swapping
	mov temp2,d_mh
	mov d_mh,d_hi
	mov d_hi,d_lo
	mov d_lo,d_ml
	mov d_ml,temp2

; 32 bit add of c and d, result is stored in c
	add c_lo,d_lo
	adc c_ml,d_ml
	adc c_mh,d_mh
	adc c_hi,d_hi

; b = (b xor c) >> 7
; 32 bit xor of b and c, result is stored in b
	eor b_lo,c_lo
	eor b_ml,c_ml
	eor b_mh,c_mh
	eor b_hi,c_hi
; >>>>7
; idea >>>>8
	mov temp2,b_mh
	mov b_mh,b_hi
	mov b_hi,b_lo
	mov b_lo,b_ml
	mov b_ml,temp2
; plus <<<<1
	lsl b_lo
	rol b_ml
	rol b_mh
	rol b_hi
	adc b_lo,temp
	
	ret

end_hash:
	pop 31
	pop 30
	pop 29
	pop 28
	pop 27
	pop 26
	pop 25
	pop 24
	pop 23
	pop 22
	pop 21
	pop 20
	pop 19
	pop 18
	pop 17
	pop 16
	pop 15
	pop 14
	pop 13
	pop 12
	pop 11
	pop 10
	pop 9
	pop 8
	pop 7
	pop 6
	pop 5
	pop 4
	pop 3
	pop 2
	pop 1
	pop 0

    ret

; finalize the current state
final:
;h'0 = h0 eor s0 eor v0 eor v8
;h'1 = h1 eor s1 eor v1 eor v9
;h'2 = h2 eor s2 eor v2 eor v10
;h'3 = h3 eor s3 eor v3 eor v11
;h'4 = h4 eor s0 eor v4 eor v12
;h'5 = h5 eor s1 eor v5 eor v13
;h'6 = h6 eor s2 eor v6 eor v14
;h'7 = h7 eor s3 eor v7 eor v15
	ldi temp,8
	movw yl,zl
	adiw yl,offset_salt

loop_final:
;h'0 = h0 eor s0 eor v0 eor v8
	; load s(i)
	ld b_hi,Y+
	ld b_mh,Y+
	ld b_ml,Y+
	ld b_lo,Y+
	; load v(i)
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+
	; load v(i+8)
	adiw xl,28
	ld d_hi,X+
	ld d_mh,X+
	ld d_ml,X+
	ld d_lo,X+
	sbiw xl,32
	; load h(i)_hi
	ld a_hi,Z
	; eor everything
	eor c_hi,d_hi
	eor a_hi,b_hi
	eor a_hi,c_hi
	; store h'(i)_hi
	st Z+,a_hi
	; load h(i)_mh
	ld a_mh,Z
	eor c_mh,d_mh
	eor a_mh,b_mh
	eor a_mh,c_mh
	st Z+,a_mh
	; load h(i)_ml
	ld a_ml,Z
	eor c_ml,d_ml
	eor a_ml,b_ml
	eor a_ml,c_ml
	st Z+,a_ml
	; load h(i)_lo
	ld a_lo,Z
	eor c_lo,d_lo
	eor a_lo,b_lo
	eor a_lo,c_lo
	st Z+,a_lo
	
	dec temp
	breq return
	cpi temp,4
	brne loop_final
sub_Y:	
	sbiw yl,16
	brne loop_final
return:
	;restore pointer
	sbiw zl,32
	ldd yh,Z+offset_msg_ptr
	ldd yl,Z+offset_msg_ptr+1

;check if padding needs one additional messsage block
	ldd temp,Z+offset_padding
	cpi temp,FULL_EXTRA_BLOCK
	breq full_padding
	cpi temp,NO_NEXT_BLOCK
	breq half_padding
; if not return
	rjmp end_hash

; override message
; half_padding: the first '1' added by the padding was placed in the previous block 
; the new block just consists of 000..001<64bit-counter>
half_padding:
	ldi temp,0x00
	st Y+,temp	
	rjmp zeropadding
; full_padding: the new message block starts with a 1 because the previous block was full
; the new block consists of 100..001<64bit-counter>
full_padding:
	ldi temp,0x80
	st Y+,temp
zeropadding:
	ldi temp,0
	ldi temp2,54
loop_zeropadding:
	st Y+,temp
	dec temp2
	brne loop_zeropadding
; append second 1 and 64-bit counter 
one_plus_counter:
	ldi temp,1
	st Y+,temp
	adiw zl,offset_counter
	ldi temp2,8
	
	adiw yl,4 ; for big endianess
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	sbiw yl,8
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp
	ld temp,Z+
	st Y+,temp

	; restore pointer, set length, call hash function
	sbiw zl,offset_counter+8
	movw R24,zl
	ldd R23,Z+offset_msg_ptr
	ldd R22,Z+offset_msg_ptr+1
; set length to last block with 512 bit message size
	ldi R21,0x82
	ldi R20,0x00
	ldi temp,EXTRA_BLOCK
	std Z+offset_padding,temp
; reset counter to 0
	adiw zl,offset_counter
	ldi temp,0
	ldi temp2,8
loop_reset_counter:
	st Z+,temp
	dec temp2
	brne loop_reset_counter
	sbiw zl,offset_counter+8
; jump to the beginning of the hash function once again
	rjmp HASH

real_return:
	rjmp end_hash

.endfunc















; IV's needed for initialization require 8x32Bit = 256Bit = 8x4Byte = 32 Byte
ivs:

	.byte 0x6A,0x09,0xE6,0x67
	.byte 0xBB,0x67,0xAE,0x85
	.byte 0x3C,0x6E,0xF3,0x72
	.byte 0xA5,0x4F,0xF5,0x3A
	.byte 0x51,0x0E,0x52,0x7F
	.byte 0x9B,0x05,0x68,0x8C
	.byte 0x1F,0x83,0xD9,0xAB
	.byte 0x5B,0xE0,0xCD,0x19


;Constants that are used in every round 16x32 Bit = 512Bit = 16x4Byte = 64 Byte
constants:

	.byte 0x24,0x3F,0x6A,0x88
	.byte 0x85,0xA3,0x08,0xD3
	.byte 0x13,0x19,0x8A,0x2E
	.byte 0x03,0x70,0x73,0x44
	.byte 0xA4,0x09,0x38,0x22
	.byte 0x29,0x9F,0x31,0xD0
	.byte 0x08,0x2E,0xFA,0x98
	.byte 0xEC,0x4E,0x6C,0x89
	.byte 0x45,0x28,0x21,0xE6
	.byte 0x38,0xD0,0x13,0x77
	.byte 0xBE,0x54,0x66,0xCF
	.byte 0x34,0xE9,0x0C,0x6C
	.byte 0xC0,0xAC,0x29,0xB7
	.byte 0xC9,0x7C,0x50,0xDD
	.byte 0x3F,0x84,0xD5,0xB5
	.byte 0xB5,0x47,0x09,0x17

; Sigma round-dependend : 10x16x8 Bit = 1280 Bit = 160x1 Byte = 160 Byte
; 		could be reduced to 10x16x4 Bit = 640 Bit = 80x1 Byte = 80 Byte
;		or maybe even 72 Byte (when leaving out the first row)
sigma:

 	.byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
 	.byte 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3
 	.byte 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4
 	.byte 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8
 	.byte 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13
 	.byte 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9
 	.byte 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11
 	.byte 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10
 	.byte 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5
 	.byte 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0

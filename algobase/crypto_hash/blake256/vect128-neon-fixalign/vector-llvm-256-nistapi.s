	.syntax unified
	.cpu cortex-a8
	.eabi_attribute 6, 10
	.eabi_attribute 7, 65
	.eabi_attribute 8, 1
	.eabi_attribute 9, 2
	.fpu neon
	.eabi_attribute 10, 3
	.eabi_attribute 12, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.file	"vector-llvm.o"
	.text
	.globl	VERSION
	.align	4
	.type	VERSION,%function
VERSION:                                @ @VERSION
@ BB#0:
	movw	r0, :lower16:.L.str
	movt	r0, :upper16:.L.str
	bx	lr
.Ltmp0:
	.size	VERSION, .Ltmp0-VERSION

	.globl	SupportedLength
	.align	4
	.type	SupportedLength,%function
SupportedLength:                        @ @SupportedLength
@ BB#0:
	mov	r1, r0
	mov	r0, #0
	cmp	r1, #512
	bge	.LBB1_3
@ BB#1:
	cmp	r1, #224
	cmpne	r1, #256
	beq	.LBB1_4
@ BB#2:
	cmp	r1, #384
	beq	.LBB1_4
	b	.LBB1_5
.LBB1_3:
	cmp	r1, #512
	bxne	lr
.LBB1_4:
	cmp	r1, #256
	mov	r0, #0
	movle	r0, #1
.LBB1_5:
	bx	lr
.Ltmp1:
	.size	SupportedLength, .Ltmp1-SupportedLength

	.globl	RequiredAlignment
	.align	4
	.type	RequiredAlignment,%function
RequiredAlignment:                      @ @RequiredAlignment
@ BB#0:
	mov	r0, #16
	bx	lr
.Ltmp2:
	.size	RequiredAlignment, .Ltmp2-RequiredAlignment

	.globl	v16_broadcast_cst_128
	.align	4
	.type	v16_broadcast_cst_128,%function
v16_broadcast_cst_128:                  @ @v16_broadcast_cst_128
@ BB#0:
	vmov.i16	q8, #0x80
	vmov	r0, r1, d16
	vmov	r2, r3, d17
	bx	lr
.Ltmp3:
	.size	v16_broadcast_cst_128, .Ltmp3-v16_broadcast_cst_128

	.globl	v16_broadcast_cst_255
	.align	4
	.type	v16_broadcast_cst_255,%function
v16_broadcast_cst_255:                  @ @v16_broadcast_cst_255
@ BB#0:
	vmov.i16	q8, #0xFF
	vmov	r0, r1, d16
	vmov	r2, r3, d17
	bx	lr
.Ltmp4:
	.size	v16_broadcast_cst_255, .Ltmp4-v16_broadcast_cst_255

	.globl	v16_broadcast_cst_257
	.align	4
	.type	v16_broadcast_cst_257,%function
v16_broadcast_cst_257:                  @ @v16_broadcast_cst_257
@ BB#0:
	vmov.i8	q8, #0x1
	vmov	r0, r1, d16
	vmov	r2, r3, d17
	bx	lr
.Ltmp5:
	.size	v16_broadcast_cst_257, .Ltmp5-v16_broadcast_cst_257

	.globl	v8_broadcast_cst_0
	.align	4
	.type	v8_broadcast_cst_0,%function
v8_broadcast_cst_0:                     @ @v8_broadcast_cst_0
@ BB#0:
	vmov.i32	q8, #0x0
	vmov	r0, r1, d16
	vmov	r2, r3, d17
	bx	lr
.Ltmp6:
	.size	v8_broadcast_cst_0, .Ltmp6-v8_broadcast_cst_0

	.globl	print_m32
	.align	4
	.type	print_m32,%function
print_m32:                              @ @print_m32
@ BB#0:
	bx	lr
.Ltmp7:
	.size	print_m32, .Ltmp7-print_m32

	.globl	print_m64
	.align	4
	.type	print_m64,%function
print_m64:                              @ @print_m64
@ BB#0:
	bx	lr
.Ltmp8:
	.size	print_m64, .Ltmp8-print_m64

	.globl	round256
	.align	4
	.type	round256,%function
round256:                               @ @round256
@ BB#0:
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	add	r11, sp, #28
	sub	sp, sp, #748
	bic	sp, sp, #15
	add	r12, r0, #16
	add	r4, r0, #32
	add	r6, r0, #48
	add	r7, r1, #16
	str	r1, [sp, #76]           @ 4-byte Spill
	mov	r5, r1
	str	r12, [sp, #84]          @ 4-byte Spill
	vmov.i32	d1[0], r3
	str	r4, [sp, #88]           @ 4-byte Spill
	vmov.i32	d0[0], r2
	str	r6, [sp, #80]           @ 4-byte Spill
	movw	r2, #2259
	str	r7, [sp, #92]           @ 4-byte Spill
	adr	r1, .LCPI9_4
	movt	r2, #34211
	movw	r3, #12752
	vld1.16	{d16, d17}, [r1, :128]
	movt	r3, #10655
	movw	lr, #27785
	movw	r10, #14370
	vld1.16	{d18, d19}, [r0, :128]
	movt	lr, #60494
	movt	r10, #41993
	movw	r8, #64152
	vrev32.8	q9, q9
	movt	r8, #2094
	vmov.f32	s1, s0
	vst1.16	{d18, d19}, [r0, :128]
	vmov.f32	s3, s2
	vld1.16	{d18, d19}, [r12, :128]
	vrev32.8	q9, q9
	vst1.16	{d18, d19}, [r12, :128]
	veor	q8, q0, q8
	mov	r12, r10
	vld1.16	{d18, d19}, [r4, :128]
	vrev32.8	q9, q9
	vst1.16	{d18, d19}, [r4, :128]
	movw	r4, #10679
	movt	r4, #49324
	vld1.16	{d18, d19}, [r6, :128]
	mov	r9, r4
	vrev32.8	q9, q9
	vst1.16	{d18, d19}, [r6, :128]
	movw	r6, #4983
	movt	r6, #14544
	ldr	r1, [r0]
	vld1.16	{d18, d19}, [r7, :128]
	movw	r7, #29508
	eor	r1, r1, r2
	movt	r7, #880
	vld1.16	{d20, d21}, [r5, :128]
	add	r2, sp, #96
	add	r5, r2, #32
	str	r1, [sp, #96]
	ldr	r1, [r0, #8]
	eor	r1, r1, r7
	str	r1, [sp, #100]
	ldr	r1, [r0, #16]
	movw	r7, #35374
	movt	r7, #4889
	eor	r1, r1, r3
	str	r1, [sp, #104]
	ldr	r1, [r0, #24]
	movw	r3, #27272
	movt	r3, #9279
	eor	r1, r1, lr
	str	r1, [sp, #108]
	ldr	r1, [r0, #4]
	movw	lr, #2327
	movt	lr, #46407
	eor	r1, r1, r3
	str	r1, [sp, #112]
	ldr	r1, [r0, #12]
	add	r3, r2, #16
	str	r3, [sp, #72]           @ 4-byte Spill
	eor	r1, r1, r7
	str	r1, [sp, #116]
	ldr	r1, [r0, #20]
	mov	r7, r6
	eor	r1, r1, r10
	str	r1, [sp, #120]
	ldr	r1, [r0, #28]
	add	r10, r2, #48
	eor	r1, r1, r8
	str	r1, [sp, #124]
	vld1.16	{d22, d23}, [r2, :128]
	movw	r8, #20701
	vadd.i32	q10, q10, q11
	movt	r8, #51580
	ldr	r1, [r0, #32]
	vadd.i32	q10, q10, q9
	str	r5, [sp, #68]           @ 4-byte Spill
	eor	r1, r1, r6
	str	r1, [sp, #128]
	ldr	r1, [r0, #40]
	movw	r6, #3180
	movt	r6, #13545
	veor	q8, q10, q8
	eor	r1, r1, r6
	str	r1, [sp, #132]
	ldr	r1, [r0, #48]
	movw	r6, #26319
	vrev32.16	q8, q8
	movt	r6, #48724
	eor	r1, r1, r8
	str	r1, [sp, #136]
	ldr	r1, [r0, #56]
	eor	r1, r1, lr
	str	r1, [sp, #140]
	vld1.16	{d22, d23}, [r3, :128]
	adr	r1, .LCPI9_5
	vadd.i32	q11, q10, q11
	movw	r3, #8678
	vld1.16	{d20, d21}, [r1, :128]
	movt	r3, #17704
	vadd.i32	q10, q8, q10
	ldr	r1, [r0, #36]
	veor	q12, q9, q10
	str	r10, [sp, #64]          @ 4-byte Spill
	eor	r1, r1, r3
	str	r1, [sp, #144]
	ldr	r1, [r0, #44]
	vshr.u32	q9, q12, #12
	vshl.i32	q12, q12, #20
	eor	r1, r1, r6
	str	r1, [sp, #148]
	ldr	r1, [r0, #52]
	vorr	q9, q12, q9
	eor	r1, r1, r4
	str	r1, [sp, #152]
	vadd.i32	q11, q11, q9
	ldr	r1, [r0, #60]
	movw	r4, #54709
	movt	r4, #16260
	eor	r1, r1, r4
	str	r1, [sp, #156]
	veor	q13, q8, q11
	vld1.16	{d16, d17}, [r5, :128]
	add	r5, r2, #64
	vadd.i32	q11, q11, q8
	vldr.64	d16, .LCPI9_6
	vldr.64	d17, .LCPI9_7
	vtbl.8	d25, {d26, d27}, d16
	vtbl.8	d24, {d26, d27}, d17
	ldr	r1, [r0, #56]
	str	r5, [sp, #60]           @ 4-byte Spill
	vadd.i32	q10, q10, q12
	eor	r1, r1, r6
	str	r1, [sp, #160]
	add	r6, r2, #80
	veor	q13, q9, q10
	ldr	r1, [r0, #16]
	eor	r1, r1, r3
	str	r1, [sp, #164]
	vshr.u32	q9, q13, #7
	ldr	r1, [r0, #36]
	vshl.i32	q13, q13, #25
	movw	r3, #64152
	eor	r1, r1, lr
	str	r1, [sp, #168]
	vorr	q9, q13, q9
	ldr	r1, [r0, #52]
	movt	r3, #2094
	mov	lr, r9
	eor	r1, r1, r3
	str	r1, [sp, #172]
	vext.32	q13, q9, q9, #1
	movw	r3, #27785
	movt	r3, #60494
	movw	r9, #27272
	vadd.i32	q9, q11, q13
	vext.32	q11, q12, q12, #3
	movt	r9, #9279
	veor	q11, q9, q11
	vld1.16	{d24, d25}, [r10, :128]
	vadd.i32	q12, q9, q12
	mov	r10, r4
	vext.32	q9, q10, q10, #2
	ldr	r1, [r0, #40]
	str	r6, [sp, #56]           @ 4-byte Spill
	vrev32.16	q11, q11
	eor	r1, r1, r4
	str	r1, [sp, #176]
	movw	r4, #35374
	vadd.i32	q9, q9, q11
	ldr	r1, [r0, #32]
	movt	r4, #4889
	veor	q13, q13, q9
	eor	r1, r1, r12
	str	r1, [sp, #180]
	add	r12, r2, #112
	ldr	r1, [r0, #60]
	vshr.u32	q10, q13, #12
	vshl.i32	q13, q13, #20
	eor	r1, r1, r7
	str	r1, [sp, #184]
	movw	r7, #3180
	vorr	q13, q13, q10
	ldr	r1, [r0, #24]
	movt	r7, #13545
	vadd.i32	q12, q12, q13
	eor	r1, r1, r8
	str	r1, [sp, #188]
	veor	q11, q11, q12
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q13, q13, q9
	vswp	d18, d19
	vshr.u32	q11, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q11, q13, q11
	vld1.16	{d26, d27}, [r5, :128]
	vadd.i32	q12, q12, q13
	add	r5, r2, #96
	ldr	r1, [r0, #4]
	vext.32	q13, q11, q11, #3
	str	r5, [sp, #52]           @ 4-byte Spill
	eor	r1, r1, lr
	str	r1, [sp, #192]
	ldr	r1, [r0]
	vadd.i32	q11, q12, q13
	eor	r1, r1, r4
	str	r1, [sp, #196]
	ldr	r1, [r0, #44]
	veor	q10, q11, q10
	eor	r1, r1, r3
	str	r1, [sp, #200]
	vrev32.16	q10, q10
	ldr	r1, [r0, #20]
	movw	r3, #29508
	movt	r3, #880
	eor	r1, r1, r3
	vadd.i32	q9, q9, q10
	str	r1, [sp, #204]
	vld1.16	{d24, d25}, [r6, :128]
	movw	r3, #2259
	veor	q13, q13, q9
	movt	r3, #34211
	ldr	r1, [r0, #48]
	vadd.i32	q11, q11, q12
	movw	r6, #12752
	str	r12, [sp, #48]          @ 4-byte Spill
	eor	r1, r1, r3
	str	r1, [sp, #208]
	ldr	r1, [r0, #8]
	vshr.u32	q12, q13, #12
	vshl.i32	q13, q13, #20
	mov	r3, r9
	eor	r1, r1, r3
	str	r1, [sp, #212]
	ldr	r1, [r0, #28]
	vorr	q12, q13, q12
	movt	r6, #10655
	mov	r9, r2
	eor	r1, r1, r7
	str	r1, [sp, #216]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #12]
	veor	q13, q10, q11
	eor	r1, r1, r6
	str	r1, [sp, #220]
	vld1.16	{d20, d21}, [r5, :128]
	movw	r5, #8678
	vadd.i32	q10, q11, q10
	b	.LBB9_5
@ BB#1:
	.align	4
.LCPI9_4:
	.long	2752067618              @ 0xa4093822
	.long	698298832               @ 0x299f31d0
	.long	137296536               @ 0x82efa98
	.long	3964562569              @ 0xec4e6c89
@ BB#2:
	.align	4
.LCPI9_5:
	.long	608135816               @ 0x243f6a88
	.long	2242054355              @ 0x85a308d3
	.long	320440878               @ 0x13198a2e
	.long	57701188                @ 0x3707344
@ BB#3:
	.align	4
.LCPI9_6:
	.byte	9                       @ 0x9
	.byte	10                      @ 0xa
	.byte	11                      @ 0xb
	.byte	8                       @ 0x8
	.byte	13                      @ 0xd
	.byte	14                      @ 0xe
	.byte	15                      @ 0xf
	.byte	12                      @ 0xc
@ BB#4:
	.align	4
.LCPI9_7:
	.byte	1                       @ 0x1
	.byte	2                       @ 0x2
	.byte	3                       @ 0x3
	.byte	0                       @ 0x0
	.byte	5                       @ 0x5
	.byte	6                       @ 0x6
	.byte	7                       @ 0x7
	.byte	4                       @ 0x4
.LBB9_5:
	movt	r5, #17704
	vtbl.8	d23, {d26, d27}, d16
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #44]
	vadd.i32	q9, q9, q11
	eor	r1, r1, r5
	str	r1, [sp, #224]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #48]
	add	r5, r2, #128
	str	r5, [sp, #44]           @ 4-byte Spill
	eor	r1, r1, r3
	str	r1, [sp, #228]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0, #20]
	vshl.i32	q13, q13, #25
	vswp	d18, d19
	eor	r1, r1, r4
	str	r1, [sp, #232]
	vorr	q12, q13, q12
	ldr	r1, [r0, #60]
	add	r3, r2, #144
	add	r4, r2, #160
	eor	r1, r1, r8
	str	r1, [sp, #236]
	vext.32	q12, q12, q12, #1
	mov	r8, lr
	movw	r2, #64152
	movw	lr, #26319
	vadd.i32	q10, q10, q12
	movt	r2, #2094
	movt	lr, #48724
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [r12, :128]
	vadd.i32	q11, q10, q11
	mov	r12, r10
	ldr	r1, [r0, #32]
	vrev32.16	q10, q13
	str	r3, [sp, #40]           @ 4-byte Spill
	eor	r1, r1, r7
	str	r1, [sp, #240]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0]
	movw	r7, #29508
	veor	q13, q12, q9
	eor	r1, r1, r8
	str	r1, [sp, #244]
	movt	r7, #880
	ldr	r1, [r0, #8]
	vshr.u32	q12, q13, #12
	vshl.i32	q13, q13, #20
	eor	r1, r1, r6
	str	r1, [sp, #248]
	movw	r6, #2327
	vorr	q12, q13, q12
	ldr	r1, [r0, #52]
	movt	r6, #46407
	vadd.i32	q13, q11, q12
	eor	r1, r1, r6
	str	r1, [sp, #252]
	movw	r6, #2259
	veor	q11, q10, q13
	movt	r6, #34211
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r5, :128]
	vadd.i32	q12, q13, q12
	add	r5, r9, #176
	ldr	r1, [r0, #40]
	vext.32	q13, q11, q11, #3
	str	r4, [sp, #36]           @ 4-byte Spill
	eor	r1, r1, r10
	str	r1, [sp, #256]
	ldr	r1, [r0, #12]
	vadd.i32	q11, q12, q13
	movw	r10, #27785
	eor	r1, r1, r2
	str	r1, [sp, #260]
	ldr	r1, [r0, #28]
	veor	q10, q11, q10
	movw	r2, #14370
	movt	r10, #60494
	eor	r1, r1, r6
	str	r1, [sp, #264]
	vrev32.16	q10, q10
	ldr	r1, [r0, #36]
	movt	r2, #41993
	eor	r1, r1, r2
	vadd.i32	q9, q9, q10
	str	r1, [sp, #268]
	vld1.16	{d24, d25}, [r3, :128]
	veor	q13, q13, q9
	vadd.i32	q11, q11, q12
	movw	r3, #4983
	ldr	r1, [r0, #56]
	movt	r3, #14544
	vshr.u32	q12, q13, #12
	mov	r2, r3
	eor	r1, r1, lr
	str	r1, [sp, #272]
	ldr	r1, [r0, #24]
	vshl.i32	q13, q13, #20
	str	r5, [sp, #32]           @ 4-byte Spill
	add	r3, r9, #208
	eor	r1, r1, r7
	str	r1, [sp, #276]
	ldr	r1, [r0, #4]
	vorr	q12, q13, q12
	eor	r1, r1, r10
	str	r1, [sp, #280]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #16]
	veor	q13, q10, q11
	eor	r1, r1, r2
	str	r1, [sp, #284]
	vld1.16	{d20, d21}, [r4, :128]
	movw	r4, #20701
	vadd.i32	q10, q11, q10
	movt	r4, #51580
	vtbl.8	d23, {d26, d27}, d16
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #28]
	vadd.i32	q9, q9, q11
	eor	r1, r1, r2
	str	r1, [sp, #288]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #12]
	add	r2, r9, #192
	str	r2, [sp, #28]           @ 4-byte Spill
	eor	r1, r1, r6
	str	r1, [sp, #292]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0, #52]
	vshl.i32	q13, q13, #25
	vswp	d18, d19
	eor	r1, r1, r8
	str	r1, [sp, #296]
	vorr	q12, q13, q12
	ldr	r1, [r0, #44]
	movw	r8, #8678
	add	r6, r9, #224
	eor	r1, r1, r12
	str	r1, [sp, #300]
	vext.32	q12, q12, q12, #1
	movt	r8, #17704
	mov	r12, r10
	vadd.i32	q10, q10, q12
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [r5, :128]
	vadd.i32	q11, q10, q11
	movw	r5, #2327
	ldr	r1, [r0, #36]
	movt	r5, #46407
	vrev32.16	q10, q13
	str	r3, [sp, #24]           @ 4-byte Spill
	eor	r1, r1, r10
	str	r1, [sp, #304]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0, #4]
	add	r10, r9, #240
	veor	q13, q12, q9
	eor	r1, r1, r7
	str	r1, [sp, #308]
	movw	r7, #3180
	ldr	r1, [r0, #48]
	movt	r7, #13545
	vshr.u32	q12, q13, #12
	vshl.i32	q13, q13, #20
	eor	r1, r1, r4
	str	r1, [sp, #312]
	movw	r4, #27272
	vorr	q12, q13, q12
	ldr	r1, [r0, #56]
	movt	r4, #9279
	vadd.i32	q13, q11, q12
	eor	r1, r1, r7
	str	r1, [sp, #316]
	movw	r7, #14370
	veor	q11, q10, q13
	movt	r7, #41993
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r2, :128]
	movw	r2, #64152
	vadd.i32	q12, q13, q12
	ldr	r1, [r0, #8]
	movt	r2, #2094
	vext.32	q13, q11, q11, #3
	str	r6, [sp, #20]           @ 4-byte Spill
	eor	r1, r1, r2
	str	r1, [sp, #320]
	ldr	r1, [r0, #20]
	vadd.i32	q11, q12, q13
	movw	r2, #35374
	eor	r1, r1, lr
	str	r1, [sp, #324]
	ldr	r1, [r0, #16]
	veor	q10, q11, q10
	movt	r2, #4889
	eor	r1, r1, r4
	str	r1, [sp, #328]
	ldr	r1, [r0, #60]
	vrev32.16	q10, q10
	eor	r1, r1, r8
	vadd.i32	q9, q9, q10
	str	r1, [sp, #332]
	vld1.16	{d24, d25}, [r3, :128]
	veor	q13, q13, q9
	movw	r3, #12752
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #24]
	movt	r3, #10655
	vshr.u32	q12, q13, #12
	str	r10, [sp, #16]          @ 4-byte Spill
	eor	r1, r1, r2
	str	r1, [sp, #336]
	ldr	r1, [r0, #40]
	vshl.i32	q13, q13, #20
	eor	r1, r1, r3
	str	r1, [sp, #340]
	ldr	r1, [r0]
	vorr	q12, q13, q12
	eor	r1, r1, r7
	str	r1, [sp, #344]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #32]
	veor	q13, q10, q11
	eor	r1, r1, r5
	str	r1, [sp, #348]
	vld1.16	{d20, d21}, [r6, :128]
	mov	r6, lr
	vadd.i32	q10, q11, q10
	movw	lr, #10679
	vtbl.8	d23, {d26, d27}, d16
	movt	lr, #49324
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #36]
	vadd.i32	q9, q9, q11
	eor	r1, r1, r4
	str	r1, [sp, #352]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #20]
	vswp	d18, d19
	add	r4, r9, #256
	eor	r1, r1, r12
	str	r1, [sp, #356]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0, #8]
	vshl.i32	q13, q13, #25
	movw	r12, #29508
	eor	r1, r1, r7
	str	r1, [sp, #360]
	vorr	q12, q13, q12
	ldr	r1, [r0, #40]
	movw	r7, #4983
	movt	r12, #880
	eor	r1, r1, r5
	str	r1, [sp, #364]
	vext.32	q12, q12, q12, #1
	movt	r7, #14544
	add	r5, r9, #272
	vadd.i32	q10, q10, q12
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [r10, :128]
	vadd.i32	q11, q10, q11
	add	r10, r9, #288
	ldr	r1, [r0]
	vrev32.16	q10, q13
	eor	r1, r1, r7
	str	r1, [sp, #368]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0, #28]
	mov	r7, r8
	movw	r8, #20701
	veor	q13, q12, q9
	eor	r1, r1, r3
	str	r1, [sp, #372]
	movt	r8, #51580
	ldr	r1, [r0, #16]
	movw	r3, #3180
	vshr.u32	q12, q13, #12
	movt	r3, #13545
	vshl.i32	q13, q13, #20
	eor	r1, r1, r2
	str	r1, [sp, #376]
	movw	r2, #2259
	vorr	q12, q13, q12
	ldr	r1, [r0, #60]
	movt	r2, #34211
	vadd.i32	q13, q11, q12
	eor	r1, r1, r6
	str	r1, [sp, #380]
	veor	q11, q10, q13
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r4, :128]
	vadd.i32	q12, q13, q12
	mov	r4, lr
	ldr	r1, [r0, #56]
	add	lr, r9, #304
	vext.32	q13, q11, q11, #3
	eor	r1, r1, r2
	str	r1, [sp, #384]
	ldr	r1, [r0, #44]
	vadd.i32	q11, q12, q13
	movw	r2, #54709
	eor	r1, r1, r4
	str	r1, [sp, #388]
	ldr	r1, [r0, #24]
	veor	q10, q11, q10
	movt	r2, #16260
	eor	r1, r1, r7
	str	r1, [sp, #392]
	ldr	r1, [r0, #12]
	vrev32.16	q10, q10
	eor	r1, r1, r8
	vadd.i32	q9, q9, q10
	str	r1, [sp, #396]
	vld1.16	{d24, d25}, [r5, :128]
	veor	q13, q13, q9
	vadd.i32	q11, q11, q12
	mov	r5, r12
	ldr	r1, [r0, #4]
	movw	r12, #54709
	vshr.u32	q12, q13, #12
	movt	r12, #16260
	eor	r1, r1, r2
	str	r1, [sp, #400]
	ldr	r1, [r0, #48]
	vshl.i32	q13, q13, #20
	movw	r2, #64152
	eor	r1, r1, r3
	str	r1, [sp, #404]
	vorr	q12, q13, q12
	ldr	r1, [r0, #32]
	movt	r2, #2094
	eor	r1, r1, r2
	str	r1, [sp, #408]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #52]
	veor	q13, q10, q11
	eor	r1, r1, r5
	str	r1, [sp, #412]
	vld1.16	{d20, d21}, [r10, :128]
	add	r10, r9, #400
	vadd.i32	q10, q11, q10
	vtbl.8	d23, {d26, d27}, d16
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #8]
	vadd.i32	q9, q9, q11
	eor	r1, r1, r4
	str	r1, [sp, #416]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #24]
	vswp	d18, d19
	add	r4, r9, #320
	eor	r1, r1, r6
	str	r1, [sp, #420]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0]
	vshl.i32	q13, q13, #25
	movw	r6, #2259
	eor	r1, r1, r3
	str	r1, [sp, #424]
	vorr	q12, q13, q12
	ldr	r1, [r0, #32]
	movw	r3, #35374
	movt	r6, #34211
	eor	r1, r1, r5
	str	r1, [sp, #428]
	vext.32	q12, q12, q12, #1
	movt	r3, #4889
	add	r5, r9, #336
	vadd.i32	q10, q10, q12
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [lr, :128]
	vadd.i32	q11, q10, q11
	add	lr, r9, #368
	ldr	r1, [r0, #48]
	vrev32.16	q10, q13
	eor	r1, r1, r3
	str	r1, [sp, #432]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0, #40]
	movw	r3, #4983
	veor	q13, q12, q9
	eor	r1, r1, r2
	str	r1, [sp, #436]
	movw	r2, #27272
	ldr	r1, [r0, #44]
	movt	r2, #9279
	vshr.u32	q12, q13, #12
	movt	r3, #14544
	vshl.i32	q13, q13, #20
	eor	r1, r1, r2
	str	r1, [sp, #440]
	movw	r2, #12752
	vorr	q12, q13, q12
	ldr	r1, [r0, #12]
	movt	r2, #10655
	vadd.i32	q13, q11, q12
	eor	r1, r1, r7
	str	r1, [sp, #444]
	movw	r7, #27785
	veor	q11, q10, q13
	movt	r7, #60494
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r4, :128]
	vadd.i32	q12, q13, q12
	add	r4, r9, #352
	ldr	r1, [r0, #16]
	vext.32	q13, q11, q11, #3
	eor	r1, r1, r8
	str	r1, [sp, #448]
	ldr	r1, [r0, #28]
	vadd.i32	q11, q12, q13
	eor	r1, r1, r2
	str	r1, [sp, #452]
	ldr	r1, [r0, #60]
	veor	q10, q11, q10
	eor	r1, r1, r12
	str	r1, [sp, #456]
	ldr	r1, [r0, #4]
	vrev32.16	q10, q10
	eor	r1, r1, r3
	vadd.i32	q9, q9, q10
	str	r1, [sp, #460]
	movw	r3, #14370
	vld1.16	{d24, d25}, [r5, :128]
	veor	q13, q13, q9
	movt	r3, #41993
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #52]
	movw	r5, #2327
	vshr.u32	q12, q13, #12
	movt	r5, #46407
	eor	r1, r1, r3
	str	r1, [sp, #464]
	ldr	r1, [r0, #20]
	vshl.i32	q13, q13, #20
	eor	r1, r1, r7
	str	r1, [sp, #468]
	ldr	r1, [r0, #56]
	vorr	q12, q13, q12
	eor	r1, r1, r5
	str	r1, [sp, #472]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #36]
	veor	q13, q10, q11
	eor	r1, r1, r6
	str	r1, [sp, #476]
	vld1.16	{d20, d21}, [r4, :128]
	add	r4, r9, #384
	vadd.i32	q10, q11, q10
	vtbl.8	d23, {d26, d27}, d16
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #48]
	vadd.i32	q9, q9, q11
	eor	r1, r1, r2
	str	r1, [sp, #480]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #4]
	movw	r2, #26319
	vswp	d18, d19
	eor	r1, r1, r5
	str	r1, [sp, #484]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0, #56]
	vshl.i32	q13, q13, #25
	movt	r2, #48724
	eor	r1, r1, r8
	str	r1, [sp, #488]
	vorr	q12, q13, q12
	ldr	r1, [r0, #16]
	mov	r8, r6
	movw	r5, #3180
	eor	r1, r1, r2
	str	r1, [sp, #492]
	vext.32	q12, q12, q12, #1
	movw	r2, #35374
	movt	r2, #4889
	movt	r5, #13545
	vadd.i32	q10, q10, q12
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [lr, :128]
	vadd.i32	q11, q10, q11
	movw	lr, #10679
	ldr	r1, [r0, #20]
	movt	lr, #49324
	vrev32.16	q10, q13
	eor	r1, r1, lr
	str	r1, [sp, #496]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0, #60]
	veor	q13, q12, q9
	eor	r1, r1, r6
	str	r1, [sp, #500]
	mov	r6, r12
	ldr	r1, [r0, #52]
	movw	r12, #29508
	vshr.u32	q12, q13, #12
	movt	r12, #880
	vshl.i32	q13, q13, #20
	eor	r1, r1, r6
	str	r1, [sp, #504]
	vorr	q12, q13, q12
	ldr	r1, [r0, #40]
	vadd.i32	q13, q11, q12
	eor	r1, r1, r3
	str	r1, [sp, #508]
	mov	r3, r7
	veor	q11, q10, q13
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r4, :128]
	vadd.i32	q12, q13, q12
	add	r4, r9, #416
	ldr	r1, [r0]
	vext.32	q13, q11, q11, #3
	eor	r1, r1, r7
	str	r1, [sp, #512]
	ldr	r1, [r0, #24]
	vadd.i32	q11, q12, q13
	movw	r7, #4983
	eor	r1, r1, r12
	str	r1, [sp, #516]
	ldr	r1, [r0, #36]
	veor	q10, q11, q10
	movt	r7, #14544
	eor	r1, r1, r2
	str	r1, [sp, #520]
	ldr	r1, [r0, #32]
	vrev32.16	q10, q10
	movw	r2, #27272
	eor	r1, r1, r5
	vadd.i32	q9, q9, q10
	str	r1, [sp, #524]
	movt	r2, #9279
	vld1.16	{d24, d25}, [r10, :128]
	veor	q13, q13, q9
	vadd.i32	q11, q11, q12
	add	r10, r9, #432
	ldr	r1, [r0, #28]
	vshr.u32	q12, q13, #12
	eor	r1, r1, r2
	str	r1, [sp, #528]
	ldr	r1, [r0, #12]
	movw	r2, #64152
	vshl.i32	q13, q13, #20
	movt	r2, #2094
	eor	r1, r1, r2
	str	r1, [sp, #532]
	ldr	r1, [r0, #8]
	vorr	q12, q13, q12
	movw	r2, #8678
	eor	r1, r1, r7
	str	r1, [sp, #536]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #44]
	movt	r2, #17704
	veor	q13, q10, q11
	eor	r1, r1, r2
	str	r1, [sp, #540]
	movw	r2, #14370
	vld1.16	{d20, d21}, [r4, :128]
	add	r4, r9, #448
	vadd.i32	q10, q11, q10
	movt	r2, #41993
	vtbl.8	d23, {d26, d27}, d16
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #52]
	vadd.i32	q9, q9, q11
	eor	r1, r1, r5
	str	r1, [sp, #544]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #28]
	vswp	d18, d19
	movw	r5, #20701
	eor	r1, r1, r6
	str	r1, [sp, #548]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0, #48]
	vshl.i32	q13, q13, #25
	movt	r5, #51580
	eor	r1, r1, r8
	str	r1, [sp, #552]
	vorr	q12, q13, q12
	ldr	r1, [r0, #12]
	mov	r8, r7
	movw	r6, #8678
	eor	r1, r1, r7
	str	r1, [sp, #556]
	vext.32	q12, q12, q12, #1
	movw	r7, #27272
	movt	r7, #9279
	movt	r6, #17704
	vadd.i32	q10, q10, q12
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [r10, :128]
	vadd.i32	q11, q10, q11
	movw	r10, #12752
	ldr	r1, [r0, #44]
	movt	r10, #10655
	vrev32.16	q10, q13
	eor	r1, r1, r5
	str	r1, [sp, #560]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0, #56]
	add	r5, r9, #464
	veor	q13, q12, q9
	eor	r1, r1, r3
	str	r1, [sp, #564]
	movw	r3, #26319
	ldr	r1, [r0, #4]
	movt	r3, #48724
	vshr.u32	q12, q13, #12
	vshl.i32	q13, q13, #20
	eor	r1, r1, lr
	str	r1, [sp, #568]
	add	lr, r9, #480
	vorr	q12, q13, q12
	ldr	r1, [r0, #36]
	vadd.i32	q13, q11, q12
	eor	r1, r1, r12
	str	r1, [sp, #572]
	veor	q11, q10, q13
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r4, :128]
	vadd.i32	q12, q13, q12
	movw	r4, #2327
	ldr	r1, [r0, #20]
	movt	r4, #46407
	vext.32	q13, q11, q11, #3
	eor	r1, r1, r7
	str	r1, [sp, #576]
	ldr	r1, [r0, #60]
	vadd.i32	q11, q12, q13
	eor	r1, r1, r2
	str	r1, [sp, #580]
	veor	q10, q11, q10
	ldr	r1, [r0, #32]
	movw	r2, #64152
	movt	r2, #2094
	eor	r1, r1, r2
	str	r1, [sp, #584]
	vrev32.16	q10, q10
	ldr	r1, [r0, #8]
	vadd.i32	q9, q9, q10
	eor	r1, r1, r3
	str	r1, [sp, #588]
	vld1.16	{d24, d25}, [r5, :128]
	veor	q13, q13, q9
	vadd.i32	q11, q11, q12
	movw	r5, #35374
	ldr	r1, [r0]
	movt	r5, #4889
	vshr.u32	q12, q13, #12
	add	r3, r9, #496
	eor	r1, r1, r10
	str	r1, [sp, #592]
	ldr	r1, [r0, #16]
	vshl.i32	q13, q13, #20
	eor	r1, r1, r4
	str	r1, [sp, #596]
	ldr	r1, [r0, #24]
	vorr	q12, q13, q12
	eor	r1, r1, r6
	str	r1, [sp, #600]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #40]
	veor	q13, q10, q11
	eor	r1, r1, r5
	str	r1, [sp, #604]
	vld1.16	{d20, d21}, [lr, :128]
	mov	lr, r10
	vadd.i32	q10, q11, q10
	movw	r10, #26319
	vtbl.8	d23, {d26, d27}, d16
	movt	r10, #48724
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #24]
	vadd.i32	q9, q9, q11
	eor	r1, r1, r4
	str	r1, [sp, #608]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #56]
	vswp	d18, d19
	add	r4, r9, #512
	eor	r1, r1, r8
	str	r1, [sp, #612]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0, #44]
	vshl.i32	q13, q13, #25
	movw	r8, #2259
	eor	r1, r1, r12
	str	r1, [sp, #616]
	vorr	q12, q13, q12
	ldr	r1, [r0]
	add	r12, r9, #528
	movt	r8, #34211
	eor	r1, r1, r6
	str	r1, [sp, #620]
	vext.32	q12, q12, q12, #1
	movw	r6, #10679
	movt	r6, #49324
	vadd.i32	q10, q10, q12
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [r3, :128]
	vadd.i32	q11, q10, q11
	movw	r3, #14370
	ldr	r1, [r0, #60]
	movt	r3, #41993
	vrev32.16	q10, q13
	eor	r1, r1, r2
	str	r1, [sp, #624]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0, #36]
	movw	r2, #54709
	veor	q13, q12, q9
	movt	r2, #16260
	eor	r1, r1, r2
	str	r1, [sp, #628]
	ldr	r1, [r0, #12]
	movw	r2, #3180
	vshr.u32	q12, q13, #12
	movt	r2, #13545
	vshl.i32	q13, q13, #20
	eor	r1, r1, r2
	str	r1, [sp, #632]
	movw	r2, #27785
	vorr	q12, q13, q12
	ldr	r1, [r0, #32]
	movt	r2, #60494
	vadd.i32	q13, q11, q12
	eor	r1, r1, r7
	str	r1, [sp, #636]
	mov	r7, r5
	veor	q11, q10, q13
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r4, :128]
	vadd.i32	q12, q13, q12
	add	r4, r9, #544
	ldr	r1, [r0, #48]
	vext.32	q13, q11, q11, #3
	eor	r1, r1, r5
	str	r1, [sp, #640]
	ldr	r1, [r0, #52]
	vadd.i32	q11, q12, q13
	eor	r1, r1, r2
	str	r1, [sp, #644]
	ldr	r1, [r0, #4]
	veor	q10, q11, q10
	eor	r1, r1, r3
	str	r1, [sp, #648]
	ldr	r1, [r0, #40]
	vrev32.16	q10, q10
	eor	r1, r1, lr
	vadd.i32	q9, q9, q10
	str	r1, [sp, #652]
	vld1.16	{d24, d25}, [r12, :128]
	veor	q13, q13, q9
	vadd.i32	q11, q11, q12
	add	r12, r9, #560
	ldr	r1, [r0, #8]
	vshr.u32	q12, q13, #12
	eor	r5, r1, r6
	str	r5, [sp, #656]
	ldr	r1, [r0, #28]
	movw	r6, #20701
	vshl.i32	q13, q13, #20
	movt	r6, #51580
	eor	r1, r1, r6
	str	r1, [sp, #660]
	ldr	r1, [r0, #16]
	vorr	q12, q13, q12
	eor	r1, r1, r8
	str	r1, [sp, #664]
	vadd.i32	q11, q11, q12
	ldr	r1, [r0, #20]
	veor	q13, q10, q11
	eor	r1, r1, r10
	str	r1, [sp, #668]
	vld1.16	{d20, d21}, [r4, :128]
	add	r4, r9, #576
	vadd.i32	q10, q11, q10
	vtbl.8	d23, {d26, d27}, d16
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [r0, #40]
	vadd.i32	q9, q9, q11
	eor	r5, r1, r7
	str	r5, [sp, #672]
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	ldr	r1, [r0, #32]
	vswp	d18, d19
	add	r7, r9, #592
	eor	r1, r1, r3
	str	r1, [sp, #676]
	vshr.u32	q12, q13, #7
	ldr	r1, [r0, #28]
	vshl.i32	q13, q13, #25
	movw	r3, #64152
	movt	r3, #2094
	eor	r1, r1, r3
	vorr	q12, q13, q12
	str	r1, [sp, #680]
	ldr	r1, [r0, #4]
	movw	r3, #8678
	movt	r3, #17704
	vext.32	q12, q12, q12, #1
	eor	r1, r1, lr
	str	r1, [sp, #684]
	vadd.i32	q10, q10, q12
	veor	q13, q10, q11
	vld1.16	{d22, d23}, [r12, :128]
	vadd.i32	q11, q10, q11
	ldr	r1, [r0, #8]
	vrev32.16	q10, q13
	eor	r5, r1, r10
	str	r5, [sp, #688]
	vadd.i32	q9, q9, q10
	ldr	r1, [r0, #16]
	veor	q13, q12, q9
	eor	r1, r1, r3
	str	r1, [sp, #692]
	ldr	r1, [r0, #24]
	vshr.u32	q12, q13, #12
	vshl.i32	q13, q13, #20
	eor	r1, r1, r2
	str	r1, [sp, #696]
	movw	r2, #3180
	vorr	q12, q13, q12
	ldr	r1, [r0, #20]
	movt	r2, #13545
	vadd.i32	q13, q11, q12
	eor	r1, r1, r8
	str	r1, [sp, #700]
	veor	q11, q10, q13
	vtbl.8	d21, {d22, d23}, d16
	vtbl.8	d20, {d22, d23}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q12, q12, q9
	vswp	d18, d19
	vshr.u32	q11, q12, #7
	vshl.i32	q12, q12, #25
	vorr	q11, q12, q11
	vld1.16	{d24, d25}, [r4, :128]
	vadd.i32	q12, q13, q12
	ldr	r1, [r0, #60]
	vext.32	q13, q11, q11, #3
	eor	r3, r1, r2
	str	r3, [sp, #704]
	ldr	r3, [r0, #36]
	movw	r2, #54709
	movt	r2, #16260
	vadd.i32	q11, q12, q13
	eor	r3, r3, r2
	str	r3, [sp, #708]
	ldr	r3, [r0, #12]
	movw	r2, #10679
	movt	r2, #49324
	veor	q10, q11, q10
	eor	r3, r3, r2
	str	r3, [sp, #712]
	ldr	r3, [r0, #52]
	movw	r2, #27272
	movt	r2, #9279
	add	r1, r9, #608
	eor	r3, r3, r2
	str	r3, [sp, #716]
	vld1.16	{d24, d25}, [r7, :128]
	movw	r2, #2327
	vadd.i32	q12, q11, q12
	movt	r2, #46407
	vrev32.16	q11, q10
	ldr	r3, [r0, #44]
	vadd.i32	q9, q9, q11
	eor	r7, r3, r2
	str	r7, [sp, #720]
	movw	r2, #4983
	veor	q13, q13, q9
	ldr	r7, [r0, #56]
	movt	r2, #14544
	add	r3, r9, #624
	eor	r7, r7, r2
	str	r7, [sp, #724]
	vshr.u32	q10, q13, #12
	ldr	r7, [r0, #48]
	vshl.i32	q13, q13, #20
	movw	r2, #29508
	movt	r2, #880
	eor	r7, r7, r2
	vorr	q10, q13, q10
	str	r7, [sp, #728]
	ldr	r7, [r0]
	vadd.i32	q12, q12, q10
	eor	r7, r7, r6
	str	r7, [sp, #732]
	veor	q13, q11, q12
	vld1.16	{d22, d23}, [r1, :128]
	vadd.i32	q11, q12, q11
	vtbl.8	d25, {d26, d27}, d16
	vtbl.8	d24, {d26, d27}, d17
	vadd.i32	q9, q9, q12
	vext.32	q12, q12, q12, #3
	veor	q13, q10, q9
	vswp	d18, d19
	vshr.u32	q10, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q10, q13, q10
	vld1.16	{d26, d27}, [r3, :128]
	vext.32	q10, q10, q10, #1
	vadd.i32	q11, q11, q10
	veor	q12, q11, q12
	vadd.i32	q11, q11, q13
	vrev32.16	q12, q12
	vadd.i32	q9, q9, q12
	veor	q13, q10, q9
	vshr.u32	q10, q13, #12
	vshl.i32	q13, q13, #20
	vorr	q13, q13, q10
	vadd.i32	q11, q11, q13
	veor	q12, q12, q11
	vtbl.8	d21, {d24, d25}, d16
	vtbl.8	d20, {d24, d25}, d17
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q13, q13, q9
	vswp	d18, d19
	vshr.u32	q12, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q12, q13, q12
	vld1.16	{d26, d27}, [r9, :128]
	vadd.i32	q13, q11, q13
	ldr	r1, [sp, #72]           @ 4-byte Reload
	vext.32	q11, q12, q12, #3
	vadd.i32	q12, q13, q11
	vld1.16	{d26, d27}, [r1, :128]
	veor	q10, q12, q10
	ldr	r1, [sp, #68]           @ 4-byte Reload
	vadd.i32	q12, q12, q13
	vrev32.16	q10, q10
	vadd.i32	q9, q9, q10
	veor	q13, q11, q9
	vshr.u32	q11, q13, #12
	vshl.i32	q13, q13, #20
	vorr	q11, q13, q11
	vadd.i32	q12, q12, q11
	veor	q13, q10, q12
	vld1.16	{d20, d21}, [r1, :128]
	vadd.i32	q10, q12, q10
	vtbl.8	d25, {d26, d27}, d16
	vtbl.8	d24, {d26, d27}, d17
	ldr	r1, [sp, #64]           @ 4-byte Reload
	vadd.i32	q9, q9, q12
	vext.32	q12, q12, q12, #3
	veor	q13, q11, q9
	vswp	d18, d19
	vshr.u32	q11, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q11, q13, q11
	vext.32	q11, q11, q11, #1
	vadd.i32	q10, q10, q11
	veor	q13, q10, q12
	vld1.16	{d24, d25}, [r1, :128]
	vadd.i32	q12, q10, q12
	vrev32.16	q10, q13
	vadd.i32	q9, q9, q10
	veor	q13, q11, q9
	vshr.u32	q11, q13, #12
	vshl.i32	q13, q13, #20
	vorr	q13, q13, q11
	vadd.i32	q11, q12, q13
	veor	q12, q10, q11
	vtbl.8	d21, {d24, d25}, d16
	vtbl.8	d20, {d24, d25}, d17
	ldr	r1, [sp, #60]           @ 4-byte Reload
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q13, q13, q9
	vswp	d18, d19
	vshr.u32	q12, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q12, q13, q12
	vld1.16	{d26, d27}, [r1, :128]
	vadd.i32	q13, q11, q13
	ldr	r1, [sp, #56]           @ 4-byte Reload
	vext.32	q11, q12, q12, #3
	vadd.i32	q12, q13, q11
	vld1.16	{d26, d27}, [r1, :128]
	veor	q10, q12, q10
	ldr	r1, [sp, #52]           @ 4-byte Reload
	vadd.i32	q12, q12, q13
	vrev32.16	q10, q10
	vadd.i32	q9, q9, q10
	veor	q13, q11, q9
	vshr.u32	q11, q13, #12
	vshl.i32	q13, q13, #20
	vorr	q11, q13, q11
	vadd.i32	q12, q12, q11
	veor	q13, q10, q12
	vld1.16	{d20, d21}, [r1, :128]
	vadd.i32	q10, q12, q10
	vtbl.8	d25, {d26, d27}, d16
	vtbl.8	d24, {d26, d27}, d17
	ldr	r1, [sp, #48]           @ 4-byte Reload
	vadd.i32	q9, q9, q12
	vext.32	q12, q12, q12, #3
	veor	q13, q11, q9
	vswp	d18, d19
	vshr.u32	q11, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q11, q13, q11
	vext.32	q11, q11, q11, #1
	vadd.i32	q10, q10, q11
	veor	q13, q10, q12
	vld1.16	{d24, d25}, [r1, :128]
	vadd.i32	q12, q10, q12
	vrev32.16	q10, q13
	vadd.i32	q9, q9, q10
	veor	q13, q11, q9
	vshr.u32	q11, q13, #12
	vshl.i32	q13, q13, #20
	vorr	q13, q13, q11
	vadd.i32	q11, q12, q13
	veor	q12, q10, q11
	vtbl.8	d21, {d24, d25}, d16
	vtbl.8	d20, {d24, d25}, d17
	ldr	r1, [sp, #44]           @ 4-byte Reload
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q13, q13, q9
	vswp	d18, d19
	vshr.u32	q12, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q12, q13, q12
	vld1.16	{d26, d27}, [r1, :128]
	vadd.i32	q13, q11, q13
	ldr	r1, [sp, #40]           @ 4-byte Reload
	vext.32	q11, q12, q12, #3
	vadd.i32	q12, q13, q11
	vld1.16	{d26, d27}, [r1, :128]
	veor	q10, q12, q10
	ldr	r1, [sp, #36]           @ 4-byte Reload
	vadd.i32	q12, q12, q13
	vrev32.16	q10, q10
	vadd.i32	q9, q9, q10
	veor	q13, q11, q9
	vshr.u32	q11, q13, #12
	vshl.i32	q13, q13, #20
	vorr	q11, q13, q11
	vadd.i32	q12, q12, q11
	veor	q13, q10, q12
	vld1.16	{d20, d21}, [r1, :128]
	vadd.i32	q10, q12, q10
	vtbl.8	d25, {d26, d27}, d16
	vtbl.8	d24, {d26, d27}, d17
	ldr	r1, [sp, #32]           @ 4-byte Reload
	vadd.i32	q9, q9, q12
	vext.32	q12, q12, q12, #3
	veor	q13, q11, q9
	vswp	d18, d19
	vshr.u32	q11, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q11, q13, q11
	vext.32	q11, q11, q11, #1
	vadd.i32	q10, q10, q11
	veor	q13, q10, q12
	vld1.16	{d24, d25}, [r1, :128]
	vadd.i32	q12, q10, q12
	vrev32.16	q10, q13
	vadd.i32	q9, q9, q10
	veor	q13, q11, q9
	vshr.u32	q11, q13, #12
	vshl.i32	q13, q13, #20
	vorr	q13, q13, q11
	vadd.i32	q11, q12, q13
	veor	q12, q10, q11
	vtbl.8	d21, {d24, d25}, d16
	vtbl.8	d20, {d24, d25}, d17
	ldr	r1, [sp, #28]           @ 4-byte Reload
	vadd.i32	q9, q9, q10
	vext.32	q10, q10, q10, #1
	veor	q13, q13, q9
	vswp	d18, d19
	vshr.u32	q12, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q12, q13, q12
	vld1.16	{d26, d27}, [r1, :128]
	vadd.i32	q13, q11, q13
	ldr	r1, [sp, #24]           @ 4-byte Reload
	vext.32	q11, q12, q12, #3
	vadd.i32	q12, q13, q11
	vld1.16	{d26, d27}, [r1, :128]
	veor	q10, q12, q10
	ldr	r1, [sp, #20]           @ 4-byte Reload
	vadd.i32	q13, q12, q13
	vrev32.16	q10, q10
	vadd.i32	q9, q9, q10
	veor	q12, q11, q9
	vshr.u32	q11, q12, #12
	vshl.i32	q12, q12, #20
	vorr	q12, q12, q11
	vadd.i32	q11, q13, q12
	veor	q13, q10, q11
	vld1.16	{d20, d21}, [r1, :128]
	vadd.i32	q10, q11, q10
	vtbl.8	d23, {d26, d27}, d16
	vtbl.8	d22, {d26, d27}, d17
	ldr	r1, [sp, #16]           @ 4-byte Reload
	vadd.i32	q9, q9, q11
	vext.32	q11, q11, q11, #3
	veor	q13, q12, q9
	vswp	d18, d19
	vshr.u32	q12, q13, #7
	vshl.i32	q13, q13, #25
	vorr	q12, q13, q12
	vld1.16	{d26, d27}, [r1, :128]
	vext.32	q12, q12, q12, #1
	vadd.i32	q10, q10, q12
	veor	q11, q10, q11
	vadd.i32	q10, q10, q13
	vrev32.16	q13, q11
	vadd.i32	q11, q9, q13
	veor	q12, q12, q11
	vshr.u32	q9, q12, #12
	vshl.i32	q12, q12, #20
	vorr	q12, q12, q9
	vadd.i32	q10, q10, q12
	veor	q13, q13, q10
	vtbl.8	d19, {d26, d27}, d16
	vtbl.8	d18, {d26, d27}, d17
	vadd.i32	q11, q11, q9
	vext.32	q9, q9, q9, #1
	veor	q12, q12, q11
	vswp	d22, d23
	veor	q10, q10, q11
	vld1.16	{d22, d23}, [r0, :128]
	vshr.u32	q8, q12, #7
	vrev32.8	q11, q11
	vshl.i32	q12, q12, #25
	vst1.16	{d22, d23}, [r0, :128]
	vorr	q8, q12, q8
	ldr	r0, [sp, #84]           @ 4-byte Reload
	vext.32	q8, q8, q8, #3
	vld1.16	{d22, d23}, [r0, :128]
	veor	q8, q8, q9
	vrev32.8	q11, q11
	vst1.16	{d22, d23}, [r0, :128]
	ldr	r0, [sp, #88]           @ 4-byte Reload
	vld1.16	{d22, d23}, [r0, :128]
	vrev32.8	q11, q11
	vst1.16	{d22, d23}, [r0, :128]
	ldr	r0, [sp, #80]           @ 4-byte Reload
	vld1.16	{d22, d23}, [r0, :128]
	vrev32.8	q11, q11
	vst1.16	{d22, d23}, [r0, :128]
	ldr	r0, [sp, #76]           @ 4-byte Reload
	vld1.16	{d22, d23}, [r0, :128]
	veor	q10, q11, q10
	vst1.16	{d20, d21}, [r0, :128]
	ldr	r0, [sp, #92]           @ 4-byte Reload
	vld1.16	{d18, d19}, [r0, :128]
	veor	q8, q9, q8
	vst1.16	{d16, d17}, [r0, :128]
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
@ BB#6:
.Ltmp9:
	.size	round256, .Ltmp9-round256

	.globl	Blake_Compress
	.align	4
	.type	Blake_Compress,%function
Blake_Compress:                         @ @Blake_Compress
@ BB#0:
	push	{r4, r5, r11, lr}
	add	r11, sp, #8
	sub	sp, sp, #16
	sub	r2, r11, #24
	b	.LBB10_2
.LBB10_1:                               @ %.lr.ph
                                        @   in Loop: Header=BB10_2 Depth=1
	sub	r2, sp, #8
	mov	sp, r2
.LBB10_2:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	tst	r2, #15
	bne	.LBB10_1
@ BB#3:                                 @ %._crit_edge
	ldr	r2, [r0]
	cmp	r2, #256
	bhi	.LBB10_5
@ BB#4:
	add	r12, r0, #16
	mov	r0, r1
	ldm	r12, {r2, r3, r12}
	mov	r1, r12
	bl	round256
.LBB10_5:
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.Ltmp10:
	.size	Blake_Compress, .Ltmp10-Blake_Compress

	.type	.L.str,%object          @ @.str
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str:
	.asciz	 "OPTIMIZED, VECTORIZED"
	.size	.L.str, 22



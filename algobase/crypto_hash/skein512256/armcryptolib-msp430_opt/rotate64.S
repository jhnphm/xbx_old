
.global rotate64_1bit_left
.type rotate64_1bit_left,@function
rotate64_1bit_left:
    rla r12
    rlc r13
    rlc r14
    rlc r15
    jc .Lr1bl_c ; Set LSB on r12 if carry else clear.
    bic #1,r12
    ret
.Lr1bl_c:     ; Status register has carry
    bis #1,r12
    ret

.global rotate64_1bit_right
.type rotate64_1bit_right,@function
rotate64_1bit_right:
    rra r15
    rrc r14
    rrc r13
    rrc r12
    jc .Lr1br_c ; Set MSB on r15 if carry else clear.
    bic #0x8000,r15
    ret
.Lr1br_c:     ; Status register has carry
    bis #0x8000,r15
    ret



.global rotate64left_code
.type rotate64left_code,@function
rotate64left_code:
    push r11                    ;save r11
    mov.b 5(r1),r11             ;fetch word rotate from upper byte of code and load into r11
    add r11,r11                 ;double r11 since instructions 2 bytes appart.
    add #.Lw_rot_jmp_table,r11    ;add r11 to jump table
    call r11                    ;call fxn to word rotate in jump table
                                ;do bit rotates
.Lrot_w_done:
    mov.b 4(r1),r11             ;fetch bit rotate from lower byte of code and load into r11
    bit #0x01, r11              ;Test if rotate left or right
    jnz .Lrotate_bits_right
    jmp .Lrotate_bits_left

.Lrot_done:                       ;return point when rotates complete

    pop r11
    ;ret                        ;ret here redundant, next reg does job

;Jump table for word rotations
.Lw_rot_jmp_table:
    ret
	jmp .Lrotate64_1w_left
	jmp .Lrotate64_2w_left
	jmp .Lrotate64_3w_left

; We can go ahead and clobber r11 since no longer needed for jump
; 
.Lrotate64_1w_left:
    mov r15,r11
    mov r14,r15
    mov r13,r14
    mov r12,r13
    mov r11,r12
    ret
.Lrotate64_2w_left:
    mov r15,r11
    mov r13,r15
    mov r11,r13
    mov r14,r11
    mov r12,r14
    mov r11,r12
    ret
.Lrotate64_3w_left:
    mov r15,r11
    mov r12,r15
    mov r13,r12
    mov r14,r13
    mov r11,r14
    ret

;Bit rotations
.Lrotate_bits_left:
    rra r11     ;Shift out direction bit
                ;r11 is now decrementer, r15-r12 is 64 bit value to shift
    jz .Lrot_done ;if zero, rot done
.Lrlb_loop:
    rla r12
    rlc r13
    rlc r14
    rlc r15
    jc .Lrc1bl_c ; Set LSB on r12 if carry else clear.
    bic #1,r12
    dec r11
    jnz .Lrlb_loop
    jmp .Lrot_done
.Lrc1bl_c:     ; Status register has carry
    bis #1,r12
    dec r11
    jnz .Lrlb_loop
    jmp .Lrot_done




.Lrotate_bits_right:
    rra r11     ;Shift out direction bit
                ;r11 is now decrementer, r15-r12 is 64 bit value to shift
    jz .Lrot_done ;if zero, rotate done. 
.Lrrb_loop:
    rra r15
    rrc r14
    rrc r13
    rrc r12
    jc .Lrc1br_c ; Set MSB on r15 if carry else clear.
    bic #0x8000,r15
    dec r11
    jnz .Lrrb_loop
    jmp .Lrot_done
.Lrc1br_c:     ; Status register has carry
    bis #0x8000,r15
    dec r11
    jnz .Lrrb_loop
    jmp .Lrot_done


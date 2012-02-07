.global rotr32_8 
.type rotr32_8,@function
rotr32_8:
swpb r14
swpb r15
mov r14,r12
mov r15,r13
bic #0x00FF,r12
bic #0xFF00,r13
bis r12,r13
mov r15,r12
bic #0x00FF,r12
bic #0xFF00,r14
bis r12,r14
mov r13,r15
ret



; rotate 8 bits right, then rotate 1 bit left
.global rotr32_7
.type rotr32_7,@function
rotr32_7:
swpb r14
swpb r15
mov r14,r12
mov r15,r13
bic #0x00FF,r12
bic #0xFF00,r13
bis r12,r13
mov r15,r12
bic #0x00FF,r12
bic #0xFF00,r14
bis r12,r14
mov r13,r15

rlc r13
rlc r14
rlc r15
ret


;; Commenting out  since compiler optimizes this okay
;; and assembly would be worse since not-inline
;
;.global rotr32_16 
;.type rotr32_16,@function
;rotr32_16:
;;xor swap
;xor r15,r14
;xor r14,r15
;xor r15,r14
;ret






.global rotr32_12
.type rotr32_12,@function
rotr32_12:
;xor swap
xor r15,r14
xor r14,r15
xor r15,r14

mov r15,r13
rlc r13
rlc r14
rlc r15

rlc r13
rlc r14
rlc r15

rlc r13
rlc r14
rlc r15

rlc r13
rlc r14
rlc r15

ret

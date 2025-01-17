@ Program name:       math.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Library of helper math functions

@ Program name:       gcd
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Fidns greatest common divisor of two numbers (euclidean algorithm)

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global gcd
        .syntax unified
        .type   gcd, %function

gcd:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

@ Program name:       pow
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Performs exponentiation by squaring

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global pow
        .syntax unified
        .type   pow, %function

pow:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

@ Program name:       modulo
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Perform modulo operation
@ Input:              r0 - dividend
@                     r1 - divisor
@ Output:             r0 - quotient
@                     r1 - remainder

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global modulo
        .syntax unified
        .type   modulo, %function

modulo:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]

  bl                aeabi_idivmod
  
  ldr               r5, [fp, #temp2]
  ldr               r4, [fp, #temp1]
  add               sp, sp, #locals
  ldr               fp, [sp, #0]
  ldr               lr, [sp, #4]
  add               sp, sp, #8
  bx                lr 

# @ Program name:       divide
# @ Author:             Ken Hwang
# @ Date:               1/17/2024
# @ Purpose:            Perform 32-bit division
# @ Input:              r0 - dividend
# @                     r1 - divisor
# @ Output:             r0 - quotient
# @                     r1 - remainder
# 
# @ Program code
#         .equ    temp1,      -8
#         .equ    temp2,      -12
#         .equ    temp3,      -16
#         .equ    temp4,      -20
#         .equ    temp5,      -24
#         .equ    locals,      20
#         .equ    bitLength,   0x10
#         .text
#         .align  2
#         .global divide
#         .syntax unified
#         .type   divide, %function
# 
# divide:
#   sub               sp, sp, #8
#   str               fp, [sp, #0]
#   str               lr, [sp, #4]
#   add               fp, sp, #4
#   sub               sp, sp, #locals
#   str               r4, [fp, #temp1]
#   str               r5, [fp, #temp2]
# 
#   # 2's complement of divisor
#   mvn               r1, r1              
#   add               r1, r1, #1
#   lsl               r1, r1, #bitLength            @ shift divisor
# 
#   mov               r2, #bitLength                @ n bits
#   mov               r3, r0                        @ initialize AQ
# 
#   mov               r4, 0xffff                    @ A mask
#   mov               r5, 0xffff0000                @ Q mask
# 
#   divideLoop:
#     cmp             r2, #0
#     beq             exitloop                      @ if n == 0, exit
# 
#     lsl             r3, r3, #1                    @ shift AQ
#     add             r6, r3, r1                    @ subtract divisor, r6 is remainder
#                                                   @ allow overflow so we can detect
# 
#     # overflow detection (same sign operands)
#     eor             r7, r6, r1                    @ determine bit changes
#     tst             r7, #0x80000000               @ look at last bit for change
# 
#     subs            r2, r2, #1                    @ n--
# 
#     bne             divideLoop                    @ no overflow if no change in last bit
# 
#     @ if overflow
#     orr             r3, r3, #1                    @ if overflow detected, set Q0 = 1
# 
#     @ add remainder to A
#     and             r8, r3, r4                    @ mask A from AQ (keep Q)
#     orr             r3, r6, r8                    @ add remainder to A
# 
#     b               divideLoop
# 
#   exitloop:
#   
#   ldr             r5, [fp, #temp2]
#   ldr             r4, [fp, #temp1]
#   add             sp, sp, #locals
#   ldr             fp, [sp, #0]
#   ldr             lr, [sp, #4]
#   add             sp, sp, #8
#   bx              lr 

@ Program name:       checkprime
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Check if number is prime (Rabin-Miller primality test)

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -16
        .equ    locals,  8
        .text
        .align  2
        .global checkprime
        .syntax unified
        .type   checkprime, %function

checkprime:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

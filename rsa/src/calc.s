@ Program name:       calc.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Library of helper functions
# 
# @ Program name:       cpubexp
# @ Author:             Ken Hwang
# @ Date:               1/17/2024
# @ Purpose:            Calculate public key exponent
# @ Input:              r0 - 
# 
# @ Program code
#         .equ    temp1,  -8
#         .equ    temp2,  -12
#         .equ    locals,  8
#         .text
#         .align  2
#         .global cpubexp
#         .syntax unified
#         .type   cpubexp, %function
# 
# cpubexp:
#   sub               sp, sp, #8
#   str               fp, [sp, #0]
#   str               lr, [sp, #4]
#   add               fp, sp, #4
#   sub               sp, sp, #locals
#   str               r4, [fp, #temp1]
#   str               r5, [fp, #temp2]
#   
#   ldr             r5, [fp, #temp2]
#   ldr             r4, [fp, #temp1]
#   add             sp, sp, #locals
#   ldr             fp, [sp, #0]
#   ldr             lr, [sp, #4]
#   add             sp, sp, #8
#   bx              lr 
# 
# @ Program name:       cprivexp
# @ Author:             Ken Hwang
# @ Date:               1/17/2024
# @ Purpose:            Calculate private key exponent
# @ Input:              r0 - 
# 
# @ Program code
#         .equ    temp1,  -8
#         .equ    temp2,  -12
#         .equ    locals,  8
#         .text
#         .align  2
#         .global cprivexp
#         .syntax unified
#         .type   cprivexp, %function
# 
# cprivexp:
#   sub               sp, sp, #8
#   str               fp, [sp, #0]
#   str               lr, [sp, #4]
#   add               fp, sp, #4
#   sub               sp, sp, #locals
#   str               r4, [fp, #temp1]
#   str               r5, [fp, #temp2]
#   
#   ldr             r5, [fp, #temp2]
#   ldr             r4, [fp, #temp1]
#   add             sp, sp, #locals
#   ldr             fp, [sp, #0]
#   ldr             lr, [sp, #4]
#   add             sp, sp, #8
#   bx              lr 
# 
# @ Program name:       encrypt
# @ Author:             Ken Hwang
# @ Date:               1/17/2024
# @ Purpose:            Encrypt message 
# @ Input:              r0 - 
# 
# @ Program code
#         .equ    temp1,  -8
#         .equ    temp2,  -12
#         .equ    locals,  8
#         .text
#         .align  2
#         .global encrypt
#         .syntax unified
#         .type   encrypt, %function
# 
# encrypt:
#   sub               sp, sp, #8
#   str               fp, [sp, #0]
#   str               lr, [sp, #4]
#   add               fp, sp, #4
#   sub               sp, sp, #locals
#   str               r4, [fp, #temp1]
#   str               r5, [fp, #temp2]
#   
#   ldr             r5, [fp, #temp2]
#   ldr             r4, [fp, #temp1]
#   add             sp, sp, #locals
#   ldr             fp, [sp, #0]
#   ldr             lr, [sp, #4]
#   add             sp, sp, #8
#   bx              lr 
# 
# @ Program name:       decrypt
# @ Author:             Ken Hwang
# @ Date:               1/17/2024
# @ Purpose:            Decrypt an encrypted message
# @ Input:              r0 - 
# 
# @ Program code
#         .equ    temp1,  -8
#         .equ    temp2,  -12
#         .equ    locals,  8
#         .text
#         .align  2
#         .global decrypt
#         .syntax unified
#         .type   decrypt, %function
# 
# decrypt:
#   sub               sp, sp, #8
#   str               fp, [sp, #0]
#   str               lr, [sp, #4]
#   add               fp, sp, #4
#   sub               sp, sp, #locals
#   str               r4, [fp, #temp1]
#   str               r5, [fp, #temp2]
#   
#   ldr             r5, [fp, #temp2]
#   ldr             r4, [fp, #temp1]
#   add             sp, sp, #locals
#   ldr             fp, [sp, #0]
#   ldr             lr, [sp, #4]
#   add             sp, sp, #8
#   bx              lr 

@ Program name:       genprime
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Generate a prime number of a given bit length
@ Input:              r0 - bit length (n)
@ Output:             r0 - prime number

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    locals,  12
        .text
        .align  2
        .global genprime
        .syntax unified
        .type   genprime, %function

genprime:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]

  mov               r4, r0                        @ r4 = bit length (n)
  mov               r5, #3                        @ r5 = min (3)

  genPrimeLoop:
    # generate random number
    # min + rand() % (max - min)
    bl                rand                        @ r0 = random number          

    # (2^n - 1) - min
    mov               r1, #1
    lsl               r1, r1, r4
    sub               r1, r1, #1                
    sub               r1, r1, r5                

    bl                modulo                      @ r1 = r0 % r1
    add               r6, r1, r5                  @ r6 = r1 + min

    # ensure value is odd
    orr               r6, r6, #1                  @ r6 = prime number

    # check if prime
    mov               r0, r6
    bl                checkprime                  @ prime == 1

    cmp               r0, #1                      @ r0 == 1, prime
    bne               genPrimeLoop                @ r0 != 1, not prime, try again 

  exitGenPrimeLoop:
    mov               r0, r6                      @ output prime number
  
    ldr               r6, [fp, #temp3]
    ldr               r5, [fp, #temp2]
    ldr               r4, [fp, #temp1]
    add               sp, sp, #locals
    ldr               fp, [sp, #0]
    ldr               lr, [sp, #4]
    add               sp, sp, #8
    bx                lr 

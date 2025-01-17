@ Program name:       lib.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Library of helper functions

@ Program name:       cpubexp
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Calculate public key exponent
@ Input:              r0 - 

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global cpubexp
        .syntax unified
        .type   cpubexp, %function

cpubexp:
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

@ Program name:       cprivexp
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Calculate private key exponent
@ Input:              r0 - 

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global cprivexp
        .syntax unified
        .type   cprivexp, %function

cprivexp:
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

@ Program name:       encrypt
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Encrypt message 
@ Input:              r0 - 

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global encrypt
        .syntax unified
        .type   encrypt, %function

encrypt:
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

@ Program name:       decrypt
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Decrypt an encrypted message
@ Input:              r0 - 

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global decrypt
        .syntax unified
        .type   decrypt, %function

decrypt:
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

@ Program name:       genprime
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Generate a prime number for a given bit length
@ Input:              r0 - bit length
@ Outpu:              r0 - prime number

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
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

  # generate random number
  bl                srand                                  
  mov               r0, #0                                 
  bl                rand                                  
  ldr               r1, [fp, value]                        @ maximum value
  bl                __aeabi_idivmod                        
  add               r4, r1, #1                             

  
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

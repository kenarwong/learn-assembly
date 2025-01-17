@ Program name:       lib.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Library of helper functions

@ Program name:       cpubexp
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Get public key exponent
@ Output:             r0 - public exponent (e)

@ Program code
        .equ    userValueE,             -8
        .equ    locals,                  4
        .equ    numberOfFermatNumbers,   5
        .text
        .align  2
        .global cpubexp
        .syntax unified
        .type   cpubexp, %function

@ Constant program data
        .section  .rodata
        .align  2
__cpubexp_prompt:
  .asciz "Enter a value for e, please choose between the following Fermat numbers (3, 5, 17, 257, 65537): "
__cpubexp_input:
  .asciz "%d"
__cpubexp_error:
  .asciz "You entered invalid input.\n"
fermatNumbers:
  .word   0x3, 0x5, 0x11, 0x101, 0x10001                           @ First five Fermat numbers (e)

cpubexp:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals

  # prompt for selection
  promptForPublicExponent:
    ldr             r0, =__cpubexp_prompt
    bl              printf
    
    ldr             r0, =__cpubexp_input
    add             r1, fp, userValueE
    bl              scanf
    ldr             r0, [fp, userValueE]                          @ user input
    
    # validate e
    ldr             r1, =fermatNumbers
    mov             r2, #0                                        @ index

    loopFermatNumbers:
      cmp           r2, #numberOfFermatNumbers
      beq           cpubexpInvalidInput                           @ available value not found    

      ldr           r3, [r1, r2, lsl #2]                          @ r3 = e
      cmp           r0, r3
      beq           exitCpubExp                                   @ value confirmed, exit 

      add           r2, r2, #1                                    @ index++
      b             loopFermatNumbers   

  cpubexpInvalidInput:
    ldr             r0, =__cpubexp_error
    bl              printf
    b               promptForPublicExponent
  
  exitCpubExp:
    ldr             r0, [fp, userValueE]                          @ output public exponent

    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

@ Program name:       cprivexp
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Calculate private key exponent
@ Input:              r0 - e
@                     r1 - p
@                     r2 - q
@ Output:             r0 - private key exponent (d)

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    locals,  12
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
  str               r6, [fp, #temp2]

  mov               r4, r0                                        @ r4 = e
  mov               r5, r1                                        @ r5 = p
  mov               r6, r2                                        @ r6 = q

  # calculate euler's totient
  # phi(n) = (p-1)(q-1)
  sub               r0, r5, #1
  sub               r1, r6, #1
  mul               r2, r0, r1                                    @ phi(n) = (p-1) * (q-1)

  # choose d such that d is coprime to phi(n)
  # e*d = 1 (mod phi(n))
  # calculate multiplicative inverse of e modulo phi(n)
  mov               r0, r4
  mov               r1, r2
  bl                modinv                                        @ r0 = modinv(e, phi(n))
  
  ldr               r6, [fp, #temp3]
  ldr               r5, [fp, #temp2]
  ldr               r4, [fp, #temp1]
  add               sp, sp, #locals
  ldr               fp, [sp, #0]
  ldr               lr, [sp, #4]
  add               sp, sp, #8
  bx                lr 

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

    # set msb and lsb 
    mov               r0, #1
    sub               r1, r4, #1                  @ r1 = n-1
    lsl               r0, r0, r1                  @ r0 = 2(n-1) 
    orr               r6, r6, r0                  @ set bit n-1
    orr               r6, r6, #1                  @ set bit 0

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

  .section  .note.GNU-stack,"",%progbits

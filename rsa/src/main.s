@ Program name:       main.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Demonstration of RSA encryption and decryption

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter a value for e, please choose between the following Fermat numbers (3, 5, 17, 257, 65537): "
# __main_separator:
#   .asciz ", "
# __main_newline:
#   .aciz "\n"
input:
  .asciz "%d"
output:
  .asciz "your number is %d\n"
error:
  .asciz "You entered invalid input.\n"
publicKey:
  .asciz "Public Key: %d\n"
privateKey:
  .asciz "Private Key: %d\n"
bitLength:
  .word 0x10                                                      @ 16-bit length (k)
fermatNumbers:
  .word 0x3, 0x5, 0x11, 0x101, 0x10001                            @ First five Fermat numbers (e)

@ Program code
        .equ    userValueE,             -8
        .equ    temp1,                  -12
        .equ    temp2,                  -16
        .equ    temp3,                  -20
        .equ    temp4,                  -24
        .equ    temp5,                  -28
        .equ    locals,                  24
        .equ    numberOfFermatNumbers,   5
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]
  str               r7, [fp, #temp4]
  str               r8, [fp, #temp5]

  # prompt for value (e)
  promptValueE:
    ldr             r0, =prompt1
    bl              printf
    
    ldr             r0, =input
    add             r1, fp, userValueE
    bl              scanf
    ldr             r0, [fp, userValueE]                          @ user input
    
    # validate e
    ldr             r1, =fermatNumbers
    mov             r2, #0                                        @ index
    mov             r3, #numberOfFermatNumbers                       

    loopFermatNumbers:
      cmp           r2, r3
      beq           invalidInput                                  @ available value not found    

      ldr           r4, [r1, r2, lsl #2]                          @ pre-index addressing
      cmp           r0, r4
      beq           exitPromptValueE                              @ value found, exit loop

      add           r2, r2, #1                                    @ index++
      b             loopFermatNumbers   

  exitPromptValueE:

  # generate prime numbers
  ldr               r0, =bitLength                                @ bit length (k)            
  lsr               r0, r0, #1                                    @ k/2

  generatePrimeNumbersLoop:
    bl                genprime

    b                generatePrimeNumbersLoop

  exitGeneratePrimeNumbersLoop:

  # mov               r1, r0

  # # allocate memory
  # mov               r4, 0x4                                 @ size_t (4 bytes)
  # mov               r0, 0x10                                @ array length
  # mov               r1, r4                                   
  # bl                calloc                                  
  # mov               r5, r0                                  @ base address

  # print
  ldr               r0, =output
  bl                printf

  b                 exit

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf
  
  exit:
    ldr             r8, [fp, #temp5]
    ldr             r7, [fp, #temp4]
    ldr             r6, [fp, #temp3]
    ldr             r5, [fp, #temp2]
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

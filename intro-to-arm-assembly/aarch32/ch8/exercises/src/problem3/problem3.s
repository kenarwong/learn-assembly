@ Program name:       problem3.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Determine prime numbers

@ Constant program data
        .section  .rodata
        .align    2
prompt:
  .asciz "Enter limit (between 3-100): "
input:
  .asciz "%d"
output:
  .asciz "%d"
error:
  .asciz "You entered invalid input."
spacer: 
  .asciz ", "
newline:
  .asciz "\n"
constants:
  .align 2
  .word 3                             @ range minimum
  .word 100                           @ range maximum
  .word 2                             @ check prime minimum

@ Program code
        .equ    value, -8
        .equ    constantsAddress, -12
        .equ    temp1, -16
        .equ    temp2, -20
        .equ    temp3, -24
        .equ    temp4, -28
        .equ    temp5, -32
        .equ    temp6, -36
        .equ    locals, 32
        .equ    const1, 0
        .equ    const2, 4
        .equ    const3, 8
        .text
        .align  2
        .global main
        .global __aeabi_idivmod
        .syntax unified
        .type   main, %function

main:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]
  str             r6, [fp, temp3]
  str             r7, [fp, temp4]
  str             r8, [fp, temp5]
  str             r10, [fp, temp6]

  # initial prompt 
  ldr             r0, =prompt
  bl              printf
  ldr             r0, =input
  add             r1, fp, value
  bl              scanf
  ldr             r0, [fp, value]                         @ user limit

  # load constants
  ldr             r1, =constants
  str             r1, [fp, constantsAddress] 
  ldr             r2, [r1, const1]                        @ range minimum
  ldr             r3, [r1, const2]                        @ range maximum

  # validate input
  mov             r4, #0
  cmp             r0, r2
  movlt           r4, #1                                  @ lt 3

  cmp             r0, r3
  movgt           r4, #1                                  @ gt 100

  cmp             r4, #1                                  @ lt 3 | gt 100
  beq             exit                                    @ failed validation

  # initialize outer loop
  ldr             r0, [fp, constantsAddress] 
  ldr             r5, [r0, const1]                        @ i
  ldr             r6, [fp, value]                         @ n
  mov             r10, #0                                 @ number of primes

  # loop range min -> n
  rangeLoop:
    cmp           r5, r6
    bge           exit                                    @ i >= n

      # initialize inner loop
      ldr         r0, [fp, constantsAddress] 
      ldr         r7, [r0, const3]                        @ j
      lsr         r8, r5, #1                              @ i/2

      # loop check min -> n/2
      checkPrimeLoop:
        cmp       r7, r8              
        bgt       primeFound                              @ j > i/2

        mov       r0, r5
        mov       r1, r7
        bl        __aeabi_idivmod                         @ i % j

        cmp       r1, #0
        beq       exitCheckPrimeLoop                      @ i % j == 0 (i.e. divisible)

        add       r7, r7, #1                              @ j++
        b         checkPrimeLoop

    primeFound:
      add         r10, r10, #1                             @ number of primes++

      # don't preprend separator if only first prime found
      mov         r0, #1
      cmp         r10, r0
      beq         displayPrime

      # prepend separator
      ldr         r0, =spacer
      bl          printf

      displayPrime:
        # display prime
        ldr         r0, =output
        mov         r1, r5
        bl          printf

    exitCheckPrimeLoop:
      add           r5, r5, #1                              @ i++
      b             rangeLoop

  exit:
    # add newline
    ldr         r0, =newline
    bl          printf

    ldr             r10, [fp, temp6]
    ldr             r8, [fp, temp5]
    ldr             r7, [fp, temp4]
    ldr             r6, [fp, temp3]
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    mov             r0, #0
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

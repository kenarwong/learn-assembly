@ Program name:       problem7.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Determine prime factors, with uniqueness

@ Constant program data
        .section  .rodata
        .align    2
prompt:
  .asciz "Enter a number (between 3-100): "
input:
  .asciz "%d"
output:
  .asciz "%d"
error:
  .asciz "You entered invalid input.\n"
spacer: 
  .asciz ", "
newline:
  .asciz "\n"
constants:
  .word 3                             @ range minimum
  .word 100                           @ range maximum
  .word 2                             @ first prime number 

@ Program code
        .equ    value, -8
        .equ    temp1, -12
        .equ    temp2, -16
        .equ    temp3, -20
        .equ    temp4, -24
        .equ    temp5, -28
        .equ    temp6, -32
        .equ    locals, 28
        .equ    rangeMin, 0
        .equ    rangeMax, 4
        .equ    firstPrime, 8
        .text
        .align  2
        .global main
        # .global __aeabi_idiv
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

  # initial prompt 
  ldr               r0, =prompt
  bl                printf
  ldr               r0, =input
  add               r1, fp, value
  bl                scanf
  ldr               r4, [fp, value]                       @ n

  # validate input
  ldr               r0, =constants
  ldr               r1, [r0, rangeMin]                    
  cmp               r4, r1
  blt               invalidInput                          @ lt rangeMin, failed validation

  ldr               r1, [r0, rangeMax]
  cmp               r4, r1
  bgt               invalidInput                          @ gt rangeMax, failed validation

  # initialize
  ldr               r5, [r0, firstPrime]                  @ i (divisor)
  mov               r6, #0                                @ array index

  lsr               r0, r4, 1                             @ size = n/2
  bl                malloc
  mov               r7, r0                                @ int array[size]

  mov               r8, #0                                @ prime occurrences

  # exit if number is prime
  mov               r0, r4
  bl                checkPrime
  cmp               r0, #1
  beq               exit                                  @ if prime, exit

  getPrimeOccurrencesLoop:
    # check if divisor is prime
    mov             r0, r5
    bl              checkPrime
    cmp             r0, #0                      
    beq             continuePrimeOccurrencesLoop          @ if not prime, skip

    whileDivisibleLoop:
      cmp           r4, #1                                
      beq           displayPrimes                         @ n == 1, exit

      mov           r0, r4
      mov           r1, r5
      bl            __aeabi_idivmod                       @ n/i

      cmp           r1, #0
      bne           continuePrimeOccurrencesLoop          @ n % i != 0, no longer divisible, get next divisor

      mov           r4, r0                                @ quotient becomes new dividend
      str           r5, [r7, r6]                          @ array[index] = prime factor
      add           r6, r6, #4                            @ array index++
      add           r8, r8, #1                            @ occurrences++

      b             whileDivisibleLoop          

  continuePrimeOccurrencesLoop:
    add             r5, r5, #1                            @ i++
    b               getPrimeOccurrencesLoop

  displayPrimes:
    # initialize
    mov             r4, #0                                @ i
    mov             r5, #0                                @ array index
    mov             r6, #0                                @ last prime factor (to check for uniqueness)

    displayPrimesLoop:
      cmp           r4, r8                                 
      beq           exit                                  @ i == occurences, exit

      mov           r0, r6
      ldr           r6, [r7, r5]                          @ prime factor = array[index]
      cmp           r6, r0
      beq           continueDisplayPrimesLoop             @ if prime factor is same as last, skip
                                                          @ comment line to remove uniqueness skip

      # don't preprend separator if only first prime found
      cmp           r4, #0
      beq           displayPrimeNumber

      # prepend spacer
      ldr           r0, =spacer
      bl            printf

      displayPrimeNumber:
        # display prime
        ldr         r0, =output
        mov         r1, r6
        bl          printf

      continueDisplayPrimesLoop:
        add           r4, r4, #1                            @ i++
        add           r5, r5, #4                            @ array index++
        b displayPrimesLoop

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf

  exit:
    ldr             r0, =newline
    bl              printf

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

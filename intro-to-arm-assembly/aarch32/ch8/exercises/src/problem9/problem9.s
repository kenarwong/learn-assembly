@ Program name:       problem9.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Determine smallest number of coins

@ Constant program data
        .section  .rodata
        .align    2
prompt:
  .asciz "Enter a value (between 0-100): "
input:
  .asciz "%d"
output:
  .asciz "%d"
quantityOutputStart:
  .asciz "The smallest number of coins to produce your amount: "
quantityOutputEnd1:
  .asciz "%d %s.\n"
quantityOutputEnd2:
  .asciz "%d %s and %d %s.\n"
quantityOutputEnd3:
  .asciz "%d %s, %d %s, and %d %s.\n"
quantityOutputEnd4:
  .asciz "%d %s, %d %s, %d %s, and %d %s.\n"
error:
  .asciz "You entered invalid input.\n"
spacer: 
  .asciz ", "
newline:
  .asciz "\n"
constants:
  .word 1                             @ range minimum
  .word 100                           @ range maximum
  .word 8                             @ plurality label offset
quarterLabel:
  .align 3
  .asciiz "quarter"
  .align 3
  .asciiz "quarters"
nickelLabel:
  .align 3
  .asciiz "nickel"
  .align 3
  .asciiz "nickels"
dimeLabel:
  .align 3
  .asciiz "dime"
  .align 3
  .asciiz "dimes"
pennyLabel:
  .align 3
  .asciiz "penny"
  .align 3
  .asciiz "pennies"

@ Program code
        .equ    value, -8
        .equ    temp1, -12
        .equ    temp2, -16
        .equ    temp3, -20
        .equ    temp4, -24
        .equ    temp5, -28
        .equ    temp6, -32
        .equ    coinValues, -36
        .equ    coinQuantities, -40
        .equ    locals, 36
        .equ    rangeMin, 0
        .equ    rangeMax, 4
        .equ    quarter, 0
        .equ    dime, 1
        .equ    nickel, 2
        .equ    penny, 3
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

  # initial prompt 
  ldr               r0, =prompt
  bl                printf
  ldr               r0, =input
  add               r1, fp, value
  bl                scanf
  ldr               r4, [fp, value]                       @ amount

  # validate input
  ldr               r0, =constants
  ldr               r1, [r0, rangeMin]                    
  cmp               r4, r1
  blt               invalidInput                          @ lt rangeMin, failed validation

  ldr               r1, [r0, rangeMax]
  cmp               r4, r1
  bgt               invalidInput                          @ gt rangeMax, failed validation

  # initialize
  add               r0, fp, coinValues
  mov               r1, #25                               @ quarter
  strb              r1, [r0, quarter]                     @ store byte
  mov               r1, #10                               @ dime
  strb              r1, [r0, dime]                        @ store byte
  mov               r1, #5                                @ nickel
  strb              r1, [r0, nickel]                      @ store byte
  mov               r1, #1                                @ penny
  strb              r1, [r0, penny]                       @ store byte

  mov               r0, #0
  ldr               r0, [fp, coinQuantities]              @ coin quantities

  mov               r5, #0                                @ i
  mov               r6, #4                                @ 4 coins
  mov               r8, #0                                @ unique coin count (for determining display format)

  # coin loop
  coinLoop:
    cmp             r5, r6
    beq             getQuantities                         @ i == 4, end loop

    add             r0, fp, coinValues
    ldrb            r1, [r0, r5]                          @ get coin value

    mov             r0, r4
    bl              __aeabi_idivmod                       @ amount/coin value
    
    cmp             r0, #0
    beq             continueCoinLoop                      @ quotient = 0, no occurrences
                                                          @ don't store, don't increment unique coins count

    mov             r4, r1                                @ update dividend with remainder

    mov             r1, r0
    add             r0, fp, coinQuantities
    strb            r1, [r0, r5]                          @ store coin quantity

    add             r8, r8, #1                            @ unique coin count++

    continueCoinLoop:
      add             r5, r5, #1                          @ i++
      b               coinLoop

  getQuantities:
    mov             r0, #0                                @ i 
    add             r1, fp, coinQuantities                @ base address

    getQuantitesLoop:
      cmp           r0, r8
      beq           displayCoinQuantities                 @ i == unique coint count, end loop

      # load coin quantities
      ldrb            r4, [r1, r0]                        @ get quarter quantity



  displayCoinQuantities:


    # start display
    ldr             r0, =quantityOutput
    bl              printf

    ldr             r0, =output
    bl              printf


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

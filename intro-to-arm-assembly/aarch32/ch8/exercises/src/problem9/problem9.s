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
  .word 8                             @ coin struct size 
                                      @ coin quantity (int, 4 bytes)
                                      @ label address (1 word, 4 bytes)
coinValues:
  .byte 25                            @ quarter value
  .byte 10                            @ dime value
  .byte 5                             @ nickel value
  .byte 1                             @ penny value
  .align 3
coinLabels:                           @ coin labels used for printing
quarterLabel:
  .asciz "quarter"
  .space 8
  .asciz "quarters"
  .align 3
dimeLabel:
  .asciz "dime"
  .align 3
  .space 8
  .asciz "dimes"
  .align 3
  .space 8
nickelLabel:
  .asciz "nickel"
  .align 3
  .space 8
  .asciz "nickels"
  .space 8
pennyLabel:
  .asciz "penny"
  .align 3
  .space 8
  .asciz "pennies"

@ Program code
        .equ    value, -8
        .equ    temp1, -12
        .equ    temp2, -16
        .equ    temp3, -20
        .equ    temp4, -24
        .equ    temp5, -28
        .equ    temp6, -32
        .equ    temp7, -36
        .equ    locals, 32
        # constants index
        .equ    rangeMin, 0
        .equ    rangeMax, 4
        .equ    coinStructSize, 8
        # utility constants
        .equ    charBitMask, 0xffffff00
        .text
        .align  2
        .global main
        .global __aeabi_idivmod
        .syntax unified
        .type   main, %function

@ Macro to calculate coin label address
  .macro GET_COIN_LABEL reg, coinIndexReg, quantityReg
    ldr             \reg, =coinLabels
    add             \reg, \reg, \coinIndexReg, lsl #5               @ i*32
                                                                    @ each coin label section is 4 double words (32 bytes)
                                                                    @ first 2 double words is non-plural label
                                                                    @ second 2 double words is plural label

    cmp             \quantityReg, #2                                @ check if plural
    addpl           \reg, \reg, #16                                 @ add 2 double words length (16 bytes) to base
  .endm

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
  str             r9, [fp, temp6]
  str             r10, [fp, temp7]

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
  ldr               r0, =coinValues
  ldr               r6, [r0, #0]                          @ word holding 4 bytes of coin values

  ldr               r0, =constants
  ldr               r9, [r0, coinStructSize]              @ coin struct size

  mov               r1, #4                                 
  mul               r0, r9, r1                            @ array size = 4*(coin struct size)
  bl                malloc
  mov               r7, r0                                @ array pointer
  mov               r10, r0                               @ array index

  mov               r8, #0                                @ unique coin count 

  mov               r5, #0                                @ i = 0 

  # coin loop (to get least amount of coins must be in order of coins large to small)
  coinLoop:
    cmp             r5, #4
    beq             pushStructsToStack                    @ i == 4, end loop

    # get coin value
    lsl             r0, r5, #3                            @ shamt = i*8
    lsr             r0, r6, r0                            @ right shift to first byte
    bic             r1, r0, #charBitMask                  @ apply bit mask

    # get quotient (coin quantity)
    mov             r0, r4
    bl              __aeabi_idivmod                       @ amount/coin value
    mov             r3, r0                                @ coin quantity
    mov             r4, r1                                @ update dividend with remainder
    
    # check if any coins, otherwise skip 
    cmp             r3, #0
    beq             continueCoinLoop                      @ quotient = 0, no occurrences
                                                          @ don't store, don't increment unique coins count

    # store to heap
    mov             r0, r10                               @ struct pointer
    mov             r1, r3                                @ coin quantity
    GET_COIN_LABEL  r2, r5, r3                            @ coin label address
    bl              loadCoinStruct

    add             r10, r10, r9                          @ array index++ (can't use post-indexed increment)
    add             r8, r8, #1                            @ unique coin count++

    continueCoinLoop:
      add           r5, r5, #1                            @ i++
      b             coinLoop

  # need push to stack in reverse order for print arguments
  pushStructsToStack:
    movs            r5, r8                                @ i = unique coin count

    pushStructsToStackLoop:
      beq           displayCoinQuantities                 @ i == 0, end loop

      # get struct from heap
      sub           r10, r10, r9                          @ array index--
      mov           r0, r10
      bl            getCoinStructFields

      # store to stack
      sub           sp, sp, r9                            @ allocate struct space on stack
      mov           r0, sp                                @ struct pointer
      bl            loadCoinStruct

      subs          r5, r5, #1                            @ i--
      b             pushStructsToStackLoop

  displayCoinQuantities:
    # start display
    ldr             r0, =quantityOutputStart
    bl              printf

    # get first r1-r3 arguments (required by printf if >3 arguments)
    mov             r0, sp
    bl              getCoinStructFields
    mov             r4, r1
    mov             r5, r2

    add             sp, sp, r9                            @ deallocate struct space on stack

    mov             r0, sp
    bl              getCoinStructFields
    mov             r6, r1

    add             sp, sp, #4                            @ (temporarily) deallocate field space (1 byte) on stack

    # determine print format
    cmp             r8, #1
    ldreq           r0, =quantityOutputEnd1
    cmp             r8, #2
    ldreq           r0, =quantityOutputEnd2
    cmp             r8, #3
    ldreq           r0, =quantityOutputEnd3
    cmp             r8, #4
    ldreq           r0, =quantityOutputEnd4

    # print formatted string
    mov             r1, r4
    mov             r2, r5
    mov             r3, r6
    bl              printf

    sub             sp, sp, #4                            @ reallocate field space (1 byte) on stack to align with stack restoration

  deallocateMemory:
    # free heap
    mov               r0, r7
    bl                free

    # free stack
    subs            r0, r8, #1                            @ i = unique coin count - 1 (first struct already popped)

    deallocateStackLoop:
      beq           exit                                  @ if i == 0, exit

      add           sp, sp, r9                            @ deallocate struct space on stack
      subs          r0, r0, #1                            @ i--

      b             deallocateStackLoop

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf

  exit:
    ldr             r0, =newline
    bl              printf

    ldr             r10, [fp, temp7]
    ldr             r9, [fp, temp6]
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

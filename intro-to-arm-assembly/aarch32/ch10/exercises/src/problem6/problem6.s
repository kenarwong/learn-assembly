@ Program name:       problem6.s
@ Author:             Ken Hwang
@ Date:               1/2/2025
@ Purpose:            Fibonacci sequence

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a max Fibonacci number to calc: "
input:
  .asciz "%d"
output:
  .asciz "%d"
invalidInput:
  .asciz "Invalid input.\n"

@ Program code
        .equ    limit,        -8
        .equ    array,        -12
        .equ    temp1,        -16
        .equ    temp2,        -20
        .equ    locals,       12
        .text
        .align  2
        .global main
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

  # prompt limit
  ldr             r0, =prompt
  bl              printf

  ldr             r0, =input
  add             r1, fp, limit
  bl              scanf

  # validation
  ldr             r4, [fp, limit]                         @ max limit
  cmp             r4, #2
  bmi             displayInvalidInput                     @ < 2, failed validation

  # allocate memory
  lsl             r0, r4, #2                              @ bytes
  bl              malloc
  mov             r2, r0                                  @ base addr
  mov             r5, r0                                  @ base addr
  str             r5, [fp, array]                         

  # f(0) = 0, f(1) = 1
  mov             r0, #0
  str             r0, [r2], #4
  mov             r1, #1
  str             r1, [r2], #4

  # loop
  mov             r3, #2                                  @ i = 2

  fibonacciLoop:
    cmp           r3, r4
    beq           fibonacciEndLoop                        @ i == limit, end loop

    # calculate next
    adds            r0, r0, r1 
    bvs             overflowDetected                      @ stop on overflow

    str             r0, [r2], #4                          @ store

    # swap r0 and r1
    eor             r0, r0, r1 
    eor             r1, r1, r0 
    eor             r0, r0, r1      
    
    add             r3, r3, #1                            @ i++
    b               fibonacciLoop
  
  fibonacciEndLoop:
    # print fibonacci sequence
    mov             r0, r5
    mov             r1, r4
    bl              printIntArray

    b               cleanUp

  overflowDetected:
    # handle overflow 
    b               cleanUp

  cleanUp:
    # deallocate memory
    mov             r0, r5
    bl              free

    b               exit 

  # display invalid
  displayInvalidInput:
    ldr             r0, =invalidInput
    bl              printf

  exit:
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

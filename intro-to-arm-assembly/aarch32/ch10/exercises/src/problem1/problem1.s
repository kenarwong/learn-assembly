@ Program name:       problem1.s
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Demonstrate print int array in reverse

@ Constant program data
        .section  .rodata
        .align  2
myArray:
  .word 55
  .word 21
  .word 78
  .word 19
arrSize:
  .word 4

@ Program code
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

  ldr             r0, =myArray
  ldr             r1, =arrSize
  ldr             r1, [r1, #0]
  sub             r1, r1, #1                        @ 0-based end index
  bl              printIntArrayReverse

  mov             r0, #0
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

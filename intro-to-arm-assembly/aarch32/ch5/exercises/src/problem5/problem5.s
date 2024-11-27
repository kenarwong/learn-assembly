
@ Program name:       problem5.s
@ Author:             Ken Hwang
@ Date:               11/26/2024
@ Purpose:            Decimal operand2 values 

@ Constant program data
        .section  .rodata
        .align  2
format:
  .asciz "%d\n"

@ Program code
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub     sp, sp, #8
  str     fp, [sp, #0]
  str     lr, [sp, #4]
  add     fp, sp, #4

  # a) 24
  ldr     r0, =format
  mov     r1, #24
  bl      printf

  # b) 15
  ldr     r0, =format
  mov     r1, #15
  bl      printf

  # c) 34
  ldr     r0, =format
  mov     r1, #34
  bl      printf

  # d) 27
  ldr     r0, =format
  mov     r1, #27
  bl      printf

  # e) 8
  ldr     r0, =format
  mov     r1, #8
  bl      printf

  # All of the values are valid as operand2 values because they can all be represented by 8-bits (< 255)
  # They also do not need any rotation

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits


@ Program name:       problem6.s
@ Author:             Ken Hwang
@ Date:               11/26/2024
@ Purpose:             

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

  # No values given

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits

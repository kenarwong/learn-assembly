@ Program name:       problem7.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Convert A to lowercase

@ Constant program data
        .section  .rodata
        .align  2
format:
  .asciz "%c, %c\n"
 
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

  # message
  mov     r1, 0x41
  ldr     r0, =format             
  orr     r2, r1, 0x20

  bl      printf

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits

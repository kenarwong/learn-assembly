@ Program name:       problem8.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Invert bits

@ Constant program data
        .section  .rodata
        .align  2
format:
  .asciz "%032b\n%032b\n"
 
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
  mov     r1, 0x55
  orr     r1, r1, r1, lsl #8
  orr     r1, r1, r1, lsl #16
  mov     r3, 0xFF
  orr     r3, r3, r3, lsl #8
  orr     r3, r3, r3, lsl #16
  eor     r2, r1, r3

  ldr     r0, =format             
  bl      printf

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits

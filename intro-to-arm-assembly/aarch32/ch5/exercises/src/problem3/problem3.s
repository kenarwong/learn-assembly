
@ Program name:       problem3.s
@ Author:             Ken Hwang
@ Date:               11/26/2024
@ Purpose:            8-bit operand2 values 

@ Constant program data
        .section  .rodata
        .align  2
format:
  .asciz "%d\n"

@ Program code
        .text
        .global __aeabi_idiv
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub     sp, sp, #8
  str     fp, [sp, #0]
  str     lr, [sp, #4]
  add     fp, sp, #4

  # a) 198
  ldr     r0, =format
  mov     r1, #0b11000110 
  bl      printf

  # b) 260
  ldr     r0, =format
  mov     r1, #0b01000001, 30
  bl      printf

  # c) 9216
  ldr     r0, =format
  mov     r1, #0b00100100, 24
  bl      printf

  # d) 2162688
  ldr     r0, =format
  mov     r1, #0b00100001, 16
  bl      printf

  # e) -75
  ldr     r0, =format
  mvn     r1, #0b01001010
  bl      printf

  # e) -260
  ldr     r0, =format
  mvn     r1, #0b01000000
  lsl     r1, r1, #2              # not a rotate
  bl      printf

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits

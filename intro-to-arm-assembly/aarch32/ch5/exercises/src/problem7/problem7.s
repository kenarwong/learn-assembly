
@ Program name:       problem7.s
@ Author:             Ken Hwang
@ Date:               11/26/2024
@ Purpose:            Largest positive even and odd immediates

@ Constant program data
        .section  .rodata
        .align  2
unsignedFormat:
  .asciz "%u\n"

signedFormat:
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

  # largest positive even immediate
  ldr     r0, =unsignedFormat
  mov     r1, #0b11111111, 8              @ unsigned: 4278190080
  bl      printf

  ldr     r0, =signedFormat
  mov     r1, #0b01111111, 8              @ signed: 2130706432
  bl      printf

  # largest positive odd immediate
  ldr     r0, =unsignedFormat
  mov     r1, #0b11111111, 6              @ unsigned: 4227858435
  bl      printf

  ldr     r0, =signedFormat
  mov     r1, #0b11011111, 6              @ signed: 2080374787
  bl      printf

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits

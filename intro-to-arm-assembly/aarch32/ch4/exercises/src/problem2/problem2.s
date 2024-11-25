@ Program name:       problem2.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Calculate percentage with only multiplication and integer numbers

@ Constant program data
        .section  .rodata
        .align  2
format:
  .asciz "%d%% of %d = %d\n"
 
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

  # 2^16 = 65536, r0 * 655 / 65536 ~= r0 / 100
  # need construct #655 from two 8-bit numbers
  mov     r0, #143            
  mov     r1, #2          
  orr     r0, r0, r1, lsl #8

  mov     r1, #60
  mov     r2, #9

  # calculate 60% of 9
  # r3 = 9 * 60 * 655 / 65536
  mul     r3, r0, r1
  mul     r3, r3, r2
  asr     r3, r3, #16

  # message
  ldr     r0, =format             
  bl      printf

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits


@ Program name:       problem7.s
@ Author:             Ken Hwang
@ Date:               11/28/2024
@ Purpose:            Examine invalid instruction

@ Constant program data
        .section  .rodata
        .align  2
binaryFormat:
  .asciz "%b\n"
hexFormat:
  .asciz "%x\n"

@ Program code
        .equ    ins1, -8
        .equ    ins2, -12
        .equ    locals, 8
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

  ldr             r1, [pc]
  str             r1, [fp, ins1]
  mul             r1, r2, r3                   

  # Bits 7 and 4 are the same bits used by operand2's shift with register format
  # For that format the bits must be set as 0 and 1, respectively
  # For MUL, both being set to 1 will distinguish it from other formats

  ldr             r0, =hexFormat
  ldr             r1, [fp, ins1]
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins1]
  bl              printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

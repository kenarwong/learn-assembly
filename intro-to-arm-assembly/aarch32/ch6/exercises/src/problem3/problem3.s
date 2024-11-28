
@ Program name:       problem3.s
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
  lsl             r1, #8, 4                   @ compiles to lsl r1, r1, #8
                                              @ LSL does not have an <imm12> operand2 format

  # mov           r1, #8

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

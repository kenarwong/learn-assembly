
@ Program name:       problem2.s
@ Author:             Ken Hwang
@ Date:               11/28/2024
@ Purpose:            Convert instruction to machine code

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

  # LSL (Immediate)
  # 1110 000 1101 0 0000 0001 00000 00 0 0010
  # 0xe1a01002
  ldr             r1, [pc]
  str             r1, [fp, ins1]
  lsl             r1, r2, #0
   
  ldr             r0, =hexFormat
  ldr             r1, [fp, ins1]
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins1]
  bl              printf

  # MOV (Register, Shifted Register, Rs)
  # 1110 000 1101 0 0000 0001 0000 0 00 1 0010
  # 0xe1a01012
  ldr             r1, [pc]
  str             r1, [fp, ins2]
  mov             r1, r2, lsl r0                  @ same as lsl

  ldr             r0, =hexFormat
  ldr             r1, [fp, ins2]
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins2]
  bl              printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

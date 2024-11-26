@ Program name:       problem11.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Calculate 2's complement

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter value: "
input:
  .asciz "%d"
format:
  .asciz "2's complement of %d is %d\n"
 
@ Program code
        .equ    arg1, -8
        .equ    locals, 4
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

  # first value
  ldr             r0, =prompt
  bl              printf

  ldr             r0, =input
  add             r1, fp, #arg1
  bl              scanf

  # call twosComplement function
  ldr             r0, [fp, #arg1]
  bl              twosComplement
  mov             r2, r0 

  # message
  ldr             r0, =format
  ldr             r1, [fp, #arg1]
  bl              printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Calling sequence:
@        r0: value
@        bl      twosComplement
@        2's complement returned in r0

@ Program code
        .text
        .align  2
        .global twosComplement
        .type   twosComplement, %function
        .syntax unified

twosComplement:
  sub            sp, sp, #8
  str            fp, [sp, #0]
  str            lr, [sp, #4]
  add            fp, sp, #4

  # invert and add 1
  mvn           r0, r0
  add           r0, r0, #1

  ldr           fp, [sp, #0]
  ldr           lr, [sp, #4]
  add           sp, sp, #8
  bx            lr 

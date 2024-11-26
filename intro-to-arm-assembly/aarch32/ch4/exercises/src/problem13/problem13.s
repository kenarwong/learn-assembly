@ Program name:       problem13.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Multiply by 10

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter value: "
input:
  .asciz "%d"
format:
  .asciz "%d * 10 = %d\n"
 
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

  # value
  ldr             r0, =prompt
  bl              printf

  ldr             r0, =input
  add             r1, fp, #arg1
  bl              scanf

  # multiply by 10
  ldr             r1, [fp, #arg1]
  ldr             r0, =format
  lsl             r2, r1, #3
  add             r2, r2, r1, lsl #1
  bl              printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

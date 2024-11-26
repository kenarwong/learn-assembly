@ Program name:       problem9.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Swap with temp

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter first value: "
input1:
  .asciz "%d"
prompt2:
  .asciz "Enter second value: "
input2:
  .asciz "%d"
format:
  .asciz "first value: %d, second value: %d\n"
 
@ Program code
        .equ    arg1, -8
        .equ    arg2, -12
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

  # first value
  ldr             r0, =prompt1
  bl              printf

  ldr             r0, =input1
  add             r1, fp, #arg1
  bl              scanf

  # second value
  ldr             r0, =prompt2
  bl              printf

  ldr             r0, =input2
  add             r1, fp, #arg2
  bl              scanf

  # call swap function
  ldr             r0, [fp, #arg1]
  ldr             r1, [fp, #arg2]
  bl              swap
  mov             r3, r0 
  mov             r2, r1 
  mov             r1, r3 

  # message
  ldr             r0, =format
  bl              printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Calling sequence:
@        r0: first value
@        r1: second value
@        bl      swap
@        value r1 returned in r0
@        value r0 returned in r1

@ Program code
        .text
        .align  2
        .global swap
        .type   swap, %function
        .syntax unified

swap:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  # swap with temp
  mov            r2, r0
  mov            r0, r1
  mov            r1, r2

  ldr           fp, [sp, #0]
  ldr           lr, [sp, #4]
  add           sp, sp, #8
  bx            lr 

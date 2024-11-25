@ Program name:       problem1.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Calculate modulus

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter first number: "
input1:
  .asciz "%d"
prompt2:
  .asciz "Enter second number: "
input2:
  .asciz "%d"
format:
  .asciz "%d mod %d = %d\n"
 
@ Program code
        .equ    arg1, -8
        .equ    arg2, -12
        .equ    locals, 8
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
  sub     sp, sp, #locals

  # first number
  ldr     r0, =prompt1
  bl      printf

  ldr     r0, =input1              
  add     r1, fp, #arg1
  bl      scanf

  # second number
  ldr     r0, =prompt2
  bl      printf

  ldr     r0, =input2
  add     r1, fp, #arg2
  bl      scanf

  # call mod function
  ldr     r0, [fp, #arg1]
  ldr     r1, [fp, #arg2]
  bl mod
  mov r3, r0

  # message
  ldr     r0, =format             
  ldr     r1, [fp, #arg1]
  ldr     r2, [fp, #arg2]
  bl      printf

  mov     r0, #0
  add     sp, sp, #locals
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

@ Calling sequence:
@        r0: first number
@        r1: second number
@        bl      mod
@        r0 mod r1 returned in r0

@ Program code
        .text
        .align  2
        .global mod
        .type   mod, %function
        .syntax unified

mod:
  sub     sp, sp, #8
  str     fp, [sp, #0]
  str     lr, [sp, #4]
  add     fp, sp, #4

  # calculate modulus
  loop:
    mov   r2, r0
    subs  r0, r0, r1
    bpl   loop

  # return value
  mov     r0, r2

  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 


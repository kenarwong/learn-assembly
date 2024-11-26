
@ Program name:       problem6.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Calculate miles per hour

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter miles: "
input1:
  .asciz "%d"
prompt2:
  .asciz "Enter hours: "
input2:
  .asciz "%d"
format:
  .asciz "%.1f miles per hour\n"
 
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

  # miles
  ldr             r0, =prompt1
  bl              printf

  ldr             r0, =input1              
  add             r1, fp, #arg1
  bl              scanf

  # hours
  ldr             r0, =prompt2
  bl              printf

  ldr             r0, =input2
  add             r1, fp, #arg2
  bl              scanf

  # call calculateMilesPerHour function
  ldr             r0, [fp, #arg1]
  ldr             r1, [fp, #arg2]
  bl              calculateMilesPerHour

  # message
  ldr             r0, =format

  # print float (only takes 64-bit double)
  vcvt.f64.f32    d0, s0
  vmov            r2, s0                    @ s[0] = d0[0]
  vmov            r3, s1                    @ s[1] = d0[1]
  bl              printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Calling sequence:
@        r0: miles
@        r1: hours
@        bl      calculateMilesPerHour
@        calculated value returned in s0

@ Program code
        .text
        .align  2
        .global calculateMilesPerHour
        .type   calculateMilesPerHour, %function
        .syntax unified

calculateMilesPerHour:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  vmov            s0, r0 
  vcvt.f32.s32    s0, s0
  vmov            s2, r1 
  vcvt.f32.s32    s2, s2


  # calculate miles per hour
  vdiv.f32      s4, s0, s2
  vmov          s0, s4

  ldr           fp, [sp, #0]
  ldr           lr, [sp, #4]
  add           sp, sp, #8
  bx            lr 

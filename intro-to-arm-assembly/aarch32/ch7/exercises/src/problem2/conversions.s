@ Program name:       conversions.s
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Three conversion functions
@                     k2m: Kilometers to miles
@                     mph: Miles per hour
@                     k2mph: Kilometers to miles per hour

@ Program name:       k2m
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Converts kilometers to miles
@                     Only performs integer division
@ Input:              r0 value in kilometers
@ Output:             r0 value in miles

@ Program code
        .text
        .align  2
        .global k2m
        .global __aeabi_idiv
        .syntax unified
        .type   k2m, %function

k2m:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  # convert kilometers to miles
  mov r1, #10
  mul r0, r0, r1      @ multiply by 10

  # r0/16
  mov r1, #16
  bl __aeabi_idiv     @ divide by 16

  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       mph
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Calculate miles per hour
@                     Only performs integer division
@ Input:              r0 value in miles
@                     r1 value in hours
@ Output:             r0 miles per hour

@ Program code
        .text
        .align  2
        .global mph
        .global __aeabi_idiv
        .syntax unified
        .type   mph, %function

mph:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  # calculate miles per hour
  bl __aeabi_idiv     @ r0/r1

  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       k2mph
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Convert kilometers to miles, then calculate miles per hour
@                     Only performs integer division
@ Input:              r0 value in kilometers
@                     r1 value in hours
@ Output:             r0 kilometers per hour

@ Program code
        .equ    kilometers, -8
        .equ    hours, -12
        .equ    locals, 8
        .text
        .align  2
        .global k2mph
        .syntax unified
        .type   k2mph, %function

k2mph:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals

  str             r0, [fp, kilometers]
  str             r1, [fp, hours]

  # convert kilometers to miles
  bl              k2m             @ result in r0

  # calculate miles per hour
  ldr             r1, [fp, hours]
  bl              mph             @ result in r0

  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       CToF
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Convert Celsius to Fahrenheit
@ Input:              r0 - temperature in celsius
@ Output:             r0 - temperature in Fahrenheit

@ Program code
        .equ    temp1, -8
        .equ    temp2, -12
        .equ    locals, 8
        .text
        .align  2
        .global CToF
        .syntax unified
        .type   main, %function

CToF:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  vstr            s0, [fp, temp1]
  vstr            s2, [fp, temp2]

  # C*(9/5) + 32
  mov             r1, #9
  vmov            s0, r1
  vcvt.f32.s32    s0, s0
  mov             r1, #5
  vmov            s2, r1
  vcvt.f32.s32    s2, s2
  vdiv.f32        s0, s0, s2

  vmov            s2, r0 
  vcvt.f32.s32    s2, s2
  vmul.f32        s0, s0, s2

  mov             r1, #32
  vmov            s2, r1
  vcvt.f32.s32    s2, s2
  vadd.f32        s0, s0, s2

  vmov            r0, s0

  vldr            s2, [fp, temp2]
  vldr            s0, [fp, temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       Inches2Ft
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Convert Inches to Feet
@ Input:              r0 value in inches
@ Output:             r0 value in feet

@ Program code
        .text
        .align  2
        .global Inches2Ft
        .global __aeabi_idiv
        .syntax unified
        .type   main, %function

Inches2Ft:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  # r0/12
  mov             r1, #12
  bl __aeabi_idiv                 @ result in r0

  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

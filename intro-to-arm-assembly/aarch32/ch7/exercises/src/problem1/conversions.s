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

@ Program code
        .text
        .align  2
        .global k2m
        .global __aeabi_idiv
        .syntax unified
        .type   main, %function

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

@ Program code
        .text
        .align  2
        .global mph
        .global __aeabi_idiv
        .syntax unified
        .type   main, %function

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

@ Program code
        .equ    kilometers, -8
        .equ    hours, -12
        .equ    locals, 8
        .text
        .align  2
        .global k2mph
        .syntax unified
        .type   main, %function

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

@ Program name:       problem15.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            

@ Constant program data
        .section  .rodata
        .align  2
cons:
  .word 12
 
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

  # load from memory
  ldr             r1, =cons 
  str             r1, [r1, #0]

  # Write by immediate
  mov             r2, #12

  # Loading constants from memory may be more expensive than writing by immediate, 
  # but are more flexible. Values can be re-used, modified without modifying the instruction itself,
  # and can be accessed by other functions. It also separates data from code.
  # 
  # Additionally, writing with immediate values is limited to 8 bits (with 4 bits of rotation), which
  # results in a limited range of values.
  #
  # Lastly, if the value from memory is cached, there may be no difference in performance.

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

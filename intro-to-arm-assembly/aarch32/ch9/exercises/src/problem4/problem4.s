@ Program name:       problem4.s
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Demonstrate digit reversal (decimal)

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a value: "
input:
  .asciz "%d"
output:
  .asciz "The digits reversed of %d are: %d \n"

@ Program code
        .equ    value, -8
        .equ    locals,       8
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

  # prompt value
  ldr             r0, =prompt
  bl              printf

  ldr             r0, =input
  add             r1, fp, value
  bl              scanf

  # recurse
  ldr             r0, [fp, value]
  mov             r1, #0                      @ initialize sum (0)
  bl              reverseDigits

  # display output
  mov             r2, r0
  ldr             r0, =output
  ldr             r1, [fp, value]
  bl              printf

  exit:
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       reverseDigits
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Recursively reverse digits of a decimal integer
@ Input:              r0 - value
@                     r1 - sum
@ Output:             r0 - sum

@ Program code
        .equ    value,        -8
        .equ    modulo,       -12
        .equ    sum,          -16
        .equ    locals,       12
        .text
        .align  2
        .global __aeabi_idivmod
        .syntax unified
        .type   reverseDigits, %function

reverseDigits:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, value]
  str             r5, [fp, modulo]
  str             r6, [fp, sum]

  # initialize
  mov             r4, r0                      @ value
  mov             r6, r1                      @ sum

  # base case     
  cmp             r4, #0          
  beq             return                      @ amount == 0, return 

  # get modulo
  mov             r0, r4
  mov             r1, #10                      
  bl              __aeabi_idivmod             @ value/10
  mov             r4, r0                      @ quotient
  mov             r5, r1                      @ modulo

  # sum
  lsl             r0, r6, #3 
  add             r0, r0, r6, lsl #1          @ sum*10
  add             r6, r5, r0                  @ sum + modulo

  # recurse
  mov             r0, r4                      @ value
  mov             r1, r6                      @ sum
  bl              reverseDigits
  mov             r6, r0

  return:
    mov             r0, r6                    @ return sum

    str             r6, [fp, sum]
    ldr             r5, [fp, modulo]
    ldr             r4, [fp, value]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

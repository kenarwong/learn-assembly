
@ Program name:       reverseString.s
@ Author:             Ken Hwang
@ Date:               1/2/2025
@ Purpose:            Recursive function to reverse a string array
@ Input:              r0 - string address
@                     r1 - reverse string address
@ Output:             r0 - next string address
@                     r1 - next reverse string address

@ Program code
        .equ    value,  -8
        .equ    temp1,  -12
        .equ    locals, 12
        .equ    size_t, 1
        .text
        .align  2
        .global reverseString
        .syntax unified
        .type   reverseString, %function

reverseString:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]

  # load byte from string address
  # array* += size_t
  ldrb              r4, [r0], #size_t

  # base case
  cmp               r4, #0
  beq               exitReverseString

  # recurse
  bl                reverseString

  # store byte in reversed string address
  # reverseArray* += size_t
  strb              r4, [r1], #size_t

  exitReverseString:
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits


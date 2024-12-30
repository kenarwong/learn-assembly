@ Program name:       bubbleSort
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Bubble sort an array
@ Input:              r0 - array base
@                     r1 - array length

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals, 8
        .equ    size_t, 4
        .text
        .align  2
        .global bubbleSort
        .type   bubbleSort, %function

bubbleSort:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, #temp1]
  str             r5, [fp, #temp2]
  str             r6, [fp, #temp3]


  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

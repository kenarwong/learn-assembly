@ Program name:       printIntArrayReverse
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Print an int array in reverse
@ Input:              r0 - array base
@                     r1 - end loop index

@ Constant program data
        .section  .rodata
        .align  2
.data
  printOutput: .asciz "The value for element [%d] is %d\n"

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals, 8
        .text
        .align  2
        .global printIntArrayReverse
        .type   printIntArrayReverse, %function

printIntArrayReverse:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, #temp1]
  str             r5, [fp, #temp2]

  add             r4, r0, r1, lsl #2                @ end address
  movs            r5, r1                            @ end index

  # loop array index
  printIntArrayReverseLoop:
    bmi             printIntArrayReverseEndLoop     @ index < 0, end loop
  
    ldr             r0, =printOutput             
    mov             r1, r5
    ldr             r2, [r4], #-4                   @ post-index decrement
    bl              printf

    subs            r5, r5, #1                      @ index--
    b               printIntArrayReverseLoop

  printIntArrayReverseEndLoop:

  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

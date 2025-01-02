@ Program name:       printIntArray
@ Author:             Ken Hwang
@ Date:               1/2/2024
@ Purpose:            Print a int array
@ Input:              r0 - array base
@                     r1 - array length

@ Constant program data
        .section  .rodata
        .align  2
.data
  printOutput: .asciz "array[%d] = %d\n"

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    locals, 12
        .equ    size_t, 4
        .text
        .align  2
        .global printIntArray
        .type   printIntArray, %function

printIntArray:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, #temp1]
  str             r5, [fp, #temp2]
  str             r6, [fp, #temp3]

  mov             r4, r0                            @ start address
  movs            r5, r1                            @ array length (n)
  mov             r6, #0                            @ i

  # loop 
  printIntArrayLoop:
    cmp             r6, r5
    bge             printIntArrayEndLoop            @ i >= n, end loop
  
    ldr             r0, =printOutput             
    mov             r1, r6
    ldr             r2, [r4], #size_t               @ post-index increment
    bl              printf

    add             r6, r6, #1                      @ i++
    b               printIntArrayLoop

  printIntArrayEndLoop:

  ldr             r6, [fp, #temp3]
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

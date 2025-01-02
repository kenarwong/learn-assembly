@ Program name:       printByteArray
@ Author:             Ken Hwang
@ Date:               1/2/2025
@ Purpose:            Print a byte array
@ Input:              r0 - array base
@                     r1 - byte array length
@                     r2 - binary string length

@ Constant program data
        .section  .rodata
        .align  2
printOutput: 
  .asciz "array[%d] = "
binaryChar:
  .asciz "%u"
newline:
  .asciz "\n"

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    temp4,  -20
        .equ    temp5,  -24
        .equ    temp6,  -28
        .equ    locals, 24
        .text
        .align  2
        .global printByteArray
        .type   printByteArray, %function

printByteArray:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, #temp1]
  str             r5, [fp, #temp2]
  str             r6, [fp, #temp3]
  str             r7, [fp, #temp4]
  str             r8, [fp, #temp5]
  str             r9, [fp, #temp6]

  mov             r4, r0                            @ start address
  movs            r5, r1                            @ array length (n)
  mov             r6, #0                            @ i
  mov             r0, #1
  sub             r2, r2, #1
  lsl             r7, r0, r2                        @ binary start position 

  # loop 
  printByteArrayLoop:
    cmp             r6, r5
    bge             printByteArrayEndLoop           @ i >= n, end loop
  

    ldr             r0, =printOutput             
    mov             r1, r6
    bl              printf

    # initialize
    mov             r8, r7                          @ j = binary start position
    ldrb            r9, [r4, r6]                    @ load byte

    printBinaryLoop:
      cmp           r8, #0    
      beq           endPrintBinaryLoop              @ j == 0, end loop


      # print bit 1 or 0
      mov           r1, #1                          @ assume > 0
      ands          r2, r9, r8                      @ j && value
      moveq         r1, #0                          @ if 0, set as 0

      ldr           r0, =binaryChar
      bl            printf

      lsr           r8, r8, #1                      @ j >> 1
      b             printBinaryLoop

    endPrintBinaryLoop:
      ldr           r0, =newline
      bl            printf

    add             r6, r6, #1                      @ i++
    b               printByteArrayLoop

  printByteArrayEndLoop:

  ldr             r9, [fp, #temp6]
  ldr             r8, [fp, #temp5]
  ldr             r7, [fp, #temp4]
  ldr             r6, [fp, #temp3]
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

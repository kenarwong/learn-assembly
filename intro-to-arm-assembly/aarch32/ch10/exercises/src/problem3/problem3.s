@ Program name:       problem3.s
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Create an array of random values, perform operations on array

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a max limit: "
input:
  .asciz "%u"
minMaxOutput:
  .asciz "The minimum value is %d and the maximum value is %d.\n"
sumAvgOutput:
  .asciz "The sum is %d and the average is %d.\n"
medianOutput:
  .asciz "The median value is %d.\n"
error:
  .asciz "You entered invalid input.\n"
arrayLength:
  .word 100

@ Program code
        .equ    value,  -8
        .equ    temp1,  -12
        .equ    temp2,  -16
        .equ    temp3,  -20
        .equ    temp4,  -24
        .equ    temp5,  -28
        .equ    locals,  24
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]
  str               r7, [fp, #temp4]
  str               r8, [fp, #temp5]

  # initial prompt   
  ldr               r0, =prompt
  bl                printf
  ldr               r0, =input
  add               r1, fp, value
  bl                scanf
  ldr               r4, [fp, value]                         @ r4 = user value

  # validate input
  mov               r1, 0x0
  cmp               r4, r1
  ble               invalidInput                            @ le 0 | gt INT_MAX, failed validation

  # allocate memory
  ldr               r5, =arrayLength                          
  ldr               r5, [r5, #0]                            @ r5 = array length
  lsl               r0, r5, #2                              @ length * 4 bytes 
  bl                malloc 
  mov               r6, r0                                  @ r6 = base addr

  # populate array
  mov               r0, #0                                  @ seed
  mov               r8, r6                                  @ r7 = current address
  movs              r7, r5                                  @ r7 = i (array length)

  populateArrayLoop:
    beq             populateArrayEndLoop                    @ i == 0, end loop             

    # get random number
    mov             r1, r4                                  @ range
    bl              Random

    # store number
    str             r0, [r8], #4                            @ base addr + 4 bytes

    subs            r7, r7, #1                              @ i--
    b               populateArrayLoop

  populateArrayEndLoop:
  
  # a) print array
  mov               r0, r6
  mov               r1, r5
  bl                printIntArray

  # b) get min max
  mov               r0, r6
  mov               r1, r5
  bl                getMinMax
  mov               r2, r1
  mov               r1, r0

  # print min max
  ldr               r0, =minMaxOutput
  bl                printf

  # c) get sum avg
  mov               r0, r6
  mov               r1, r5
  bl                getSumAvg
  mov               r3, r2                                   
  mov               r2, r1
  mov               r1, r0

  # check overflow
  cmp               r3, #1                                  @ if overflow = 1
  beq               exit

  # print sum avg
  ldr               r0, =sumAvgOutput
  bl                printf

  # d) bubble sort
  mov               r0, r6
  mov               r1, r5
  bl                bubbleSort

  # print sorted array
  mov               r0, r6
  mov               r1, r5
  bl                printIntArray

  # e) median value
  sub               r0, r5, #1                              @ 0-based length
  lsr               r0, r0, #1                              @ median index = length / 2
  mov               r1, #size_t                             @ size_t
  mla               r2, r0, r1, r6                          @ median address = base addr + median index * size_t

  # print median value
  ldr               r0, =medianOutput
  ldr               r1, [r2, #0]
  bl                printf

  # free memory
  mov               r0, r6
  bl                free

  b               exit

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf
  
  exit:
    ldr             r8, [fp, #temp5]
    ldr             r7, [fp, #temp4]
    ldr             r6, [fp, #temp3]
    ldr             r5, [fp, #temp2]
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

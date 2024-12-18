@ Program name:       problem2.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Sentinel loop to collect user entries

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Please enter a number (-1 to end) \n"
input:
  .asciz "%d"
output:
  .asciz "You entered %d\n"
result1: 
  .asciz "The largest value is: %d\n"
result2: 
  .asciz "The smallest value is: %d\n"
result3: 
  .asciz "The average of the values is: %d\n"
newline:
  .asciz "\n"

@ Program code
        .equ    value, -8
        .equ    temp1, -12
        .equ    temp2, -16
        .equ    temp3, -20
        .equ    temp4, -24
        .equ    temp5, -28
        .equ    locals, 24
        .text
        .align  2
        .global main
        .global __aeabi_idiv
        .syntax unified
        .type   main, %function

main:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]
  str             r6, [fp, temp3]
  str             r7, [fp, temp4]
  str             r8, [fp, temp5]

  # initial prompt 
  ldr             r0, =prompt
  bl              printf
  ldr             r0, =input
  add             r1, fp, value
  bl              scanf
  ldr             r1, [fp, value]

  # initialize metrics
  mov             r4, #0              @ count
  mov             r5, #0              @ total
  mov             r6, r1              @ largest
  mov             r7, r1              @ smallest
  mov             r8, #0              @ average

  startSentinelLoop:
    mov           r0, #-1
    cmp           r1, r0
    beq           endSentinelLoop

      # Loop Block

      # print back value
      ldr         r0, =output
      bl          printf
      ldr         r1, [fp, value]

      # update metrics
      add         r4, r4, #1              @ count
      add         r5, r5, r1              @ total

      checkLargest:
        cmp       r6, r1                  
        bge       checkSmallest           @ if r6 >= value, skip
        mov       r6, r1                  @ largest

      checkSmallest:
        cmp       r7, r1
        ble       getNext                 @ if r7 <= value, skip
        mov       r7, r1                  @ smallest

      # prompt
      getNext:
        ldr       r0, =prompt
        bl        printf
        ldr       r0, =input
        add       r1, fp, value
        bl        scanf
        ldr       r1, [fp, value]         @ update with new value

      b           startSentinelLoop

  endSentinelLoop:

  # exit if no values
  cmp         r4, #0
  beq         exit

  # average
  mov         r0, r5
  mov         r1, r4
  bl          __aeabi_idiv            @ total/count
  mov         r8, r0                  @ average

  # results
  # largest
  ldr         r0, =result1
  mov         r1, r6
  bl          printf

  # smallest
  ldr         r0, =result2
  mov         r1, r7
  bl          printf

  # average
  ldr         r0, =result3
  mov         r1, r8
  bl          printf

  exit:
    ldr             r8, [fp, temp5]
    ldr             r7, [fp, temp4]
    ldr             r6, [fp, temp3]
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    mov             r0, #0
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

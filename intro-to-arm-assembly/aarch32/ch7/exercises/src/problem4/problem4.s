@ Program name:       problem4.s
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Test library money operations

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter first dollar amount (2 decimals places): "
input1:
  .asciz "%d.%2d"
prompt2:
  .asciz "Enter second dollar amount (2 decimals places): "
input2:
  .asciz "%d.%2d"
output1: 
  .asciz "Sum of values is: "
output2: 
  .asciz "Difference of values is: "
output3: 
  .asciz "Product of values is: "
output4: 
  .asciz "Quotient of values is: "
newline:
  .asciz "\n"

@ Program code
        .equ    wholePart1, -8
        .equ    decimalPart1, -12
        .equ    wholePart2, -16
        .equ    decimalPart2, -20
        .equ    resultWholePart, -24
        .equ    resultDecimalPart, -28
        .equ    locals, 24
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

  # prompt for first money amount
  ldr r0, =prompt1
  bl printf

  # read first money amount
  ldr r0, =input1
  add r1, fp, wholePart1
  add r2, fp, decimalPart1
  bl scanf

  # prompt for second money amount
  ldr r0, =prompt2
  bl printf

  # read second money amount
  ldr r0, =input2
  add r1, fp, wholePart2
  add r2, fp, decimalPart2
  bl scanf

  # addition
  add r0, fp, wholePart1
  add r1, fp, wholePart2
  add r2, fp, resultWholePart
  bl moneyAdd

  # print result
  ldr r0, =output1
  bl printf

  add r0, fp, resultWholePart
  bl moneyPrint

  ldr r0, =newline
  bl printf

  # subtraction
  add r0, fp, wholePart1
  add r1, fp, wholePart2
  add r2, fp, resultWholePart
  bl moneySub

  # print result
  ldr r0, =output2
  bl printf

  add r0, fp, resultWholePart
  bl moneyPrint

  ldr r0, =newline
  bl printf

  # multiplication
  add r0, fp, wholePart1
  add r1, fp, wholePart2
  add r2, fp, resultWholePart
  bl moneyMul

  # print result
  ldr r0, =output3
  bl printf

  add r0, fp, resultWholePart
  bl moneyPrint

  ldr r0, =newline
  bl printf

  # division
  add r0, fp, wholePart1
  add r1, fp, wholePart2
  add r2, fp, resultWholePart
  bl moneyDiv

  # print result
  ldr r0, =output4
  bl printf

  add r0, fp, resultWholePart
  bl moneyPrint

  ldr r0, =newline
  bl printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

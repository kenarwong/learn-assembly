@ Program name:       problem1.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Demonstrate branch logic 

@ Constant program data
        .section  .rodata
        .align  2
output1:
  .asciz "Branch not taken\n"
output2:
  .asciz "Branch taken\n"

@ Program code
        .text
        .align  2
        .global main
        @ .syntax unified
        .type   main, %function

main:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  MOV r1, #5
  MOV r2, #12
  CMP r1, r2
  SUBNES r1, r1, r2                 @ Will execute if CMP statement is NE
  BLT branchTaken                   @ Will take branch if r1 is less than r2
    ldr             r0, =output1
    bl              printf
    b               exit


  branchTaken:
    ldr             r0, =output2
    bl              printf
    b               exit

  exit:
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits



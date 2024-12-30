@ Program name:       problem3.s
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Convert decimal to hex

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a number from 0 to 15: "
input:
  .asciz "%d"
output:
  .asciz "your number is 0x%x\n"
error:
  .asciz "You entered invalid input.\n"

@ Program code
        .equ    value,  -8
        .equ    locals,  8
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

  # initial prompt   
  ldr               r0, =prompt
  bl                printf
  ldr               r0, =input
  add               r1, fp, value
  bl                scanf
  ldr               r2, [fp, value]                         @ user value

  # validate input
  mov               r1, 0x0
  cmp               r2, r1
  blt               invalidInput                            @ lt 0, failed validation

  mov               r1, 0x10
  cmp               r2, r1
  bge               invalidInput                            @ ge 16, failed validation

  # convert to hex
  ldr               r0, =output
  mov               r1, r2
  bl                printf

  b                 exit

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf
  
  exit:
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

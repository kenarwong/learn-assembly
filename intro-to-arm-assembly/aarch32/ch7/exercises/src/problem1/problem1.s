@ Program name:       problem1.s
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:             

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter kilometers: "
input1:
  .asciz "%d"
prompt2:
  .asciz "Enter miles: "
input2:
  .asciz "%d"
prompt3:
  .asciz "Enter hours: "
input3:
  .asciz "%d"
prompt4:
  .asciz "Enter kilometers: "
input4:
  .asciz "%d"
prompt5:
  .asciz "Enter hours: "
input5:
  .asciz "%d"
newline:
  .asciz "\n"

@ Program code
        .equ    response1, -8
        .equ    response2, -12
        .equ    response3, -16
        .equ    response4, -20
        .equ    response5, -24
        .equ    locals, 20
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

  # Problem 1a

  # prompt for kilometers
  ldr r0, =prompt1
  bl printf

  # read kilometers
  ldr r0, =input1
  add r1, fp, response1
  bl scanf

  # scale up by 1000
  ldr r0, [fp, response1]
  mov r1, #1000
  mul r0, r0, r1

  # call k2m
  bl k2m                    @ result in r0

  # print (scale down by 1000)
  mov r1, #1000
  bl printScaledInt
  ldr r0, =newline
  bl printf

  # Problem 1b

  # prompt for miles
  ldr r0, =prompt2
  bl printf

  # read miles
  ldr r0, =input2
  add r1, fp, response2
  bl scanf

  # prompt for hours
  ldr r0, =prompt3
  bl printf

  # read hours
  ldr r0, =input3
  add r1, fp, response3
  bl scanf

  # scale up by 1000 (miles)
  ldr r0, [fp, response2]
  mov r1, #1000
  mul r0, r0, r1

  # call mph
  ldr r1, [fp, response3]
  bl mph                    @ result in r0

  # print (scale down by 1000)
  mov r1, #1000
  bl printScaledInt
  ldr r0, =newline
  bl printf

  # Problem 1c

  # prompt for kilometers
  ldr r0, =prompt4
  bl printf

  # read kilometers
  ldr r0, =input4
  add r1, fp, response4
  bl scanf

  # prompt for hours
  ldr r0, =prompt5
  bl printf

  # read hours
  ldr r0, =input5
  add r1, fp, response5
  bl scanf

  # scale up by 1000 (kilometers)
  ldr r0, [fp, response4]
  mov r1, #1000
  mul r0, r0, r1

  # call k2mph
  ldr r1, [fp, response3]
  bl k2mph                   @ result in r0

  # print (scale down by 1000)
  mov r1, #1000
  bl printScaledInt
  ldr r0, =newline
  bl printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

# Program name:       problem1.s
# Author:             Ken Hwang
# Date:               11/7/2024
# Purpose:            Prompt user name and age
 
.text
.global main

main:
  # save to stack
  sub sp, sp, #4
  str lr, [sp, #0]

  # name prompt
  LDR r0, =prompt1
  bl printf

  # scan name
  LDR r0, =input1              
  LDR r1, =name
  bl scanf

  # age prompt
  LDR r0, =prompt2
  bl printf

  # scan age
  LDR r0, =input2
  LDR r1, =age
  bl scanf

  # message
  ldr r0, =format             
  ldr r1, =name
  ldr r2, =age
  ldr r2, [r2, #0]
  bl printf

  # restore stack
  ldr lr, [sp, #0]
  add sp, sp, #4

  # exit
  mov r7, #1                  
  mov r0, #0                  
  svc 0                       

.data
  prompt1:  .asciz "Enter your name: "
  input1:   .asciz "%s"
  prompt2:  .asciz "Enter your age: "
  input2:   .asciz "%d"
  format:   .asciz "The user %s is %d years old.\n"
  name:     .space 40
  age:      .word 0

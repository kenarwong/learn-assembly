# Program name:       problem3.s
# Author:             Ken Hwang
# Date:               11/7/2024
# Purpose:            Print a table
 
.text
.global main

main:
  # save to stack
  sub sp, sp, #4
  str lr, [sp, #0]

  # print row 1
  ldr r0, =format
  ldr r1, =name1
  ldr r2, =age1
  ldr r2, [r2, #0]
  bl printf

  # print row 2
  ldr r0, =format
  ldr r1, =name2
  ldr r2, =age2
  ldr r2, [r2, #0]
  bl printf

  # print row 3
  ldr r0, =format
  ldr r1, =name3
  ldr r2, =age3
  ldr r2, [r2, #0]
  bl printf

  # print row 4
  ldr r0, =format
  ldr r1, =name4
  ldr r2, =age4
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
  name1:  .asciz "Dave"
  age1:   .word 35
  name2:  .asciz "Bob"
  age2:   .word 42
  name3:  .asciz "Janet"
  age3:   .word 32
  name4:  .asciz "Pam"
  age4:   .word 26
  format: .asciz "%s\t%d\n"

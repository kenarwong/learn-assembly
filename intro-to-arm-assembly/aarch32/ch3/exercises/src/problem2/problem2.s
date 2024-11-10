# Program name:       problem2.s
# Author:             Ken Hwang
# Date:               11/7/2024
# Purpose:            Print 2 strings and 1 int, then 2 ints and 1 string
 
.text
.global main

main:
  # save to stack
  sub sp, sp, #4
  str lr, [sp, #0]

  # 2 strings and 1 int
  ldr r0, =format1             
  ldr r1, =string1
  ldr r2, =string2
  mov r3, #5
  bl printf

  # 2 ints and 1 string
  ldr r0, =format2             
  mov r1, #7
  mov r2, #9
  ldr r3, =string1
  bl printf

  # restore stack
  ldr lr, [sp, #0]
  add sp, sp, #4

  # exit
  mov r7, #1                  
  mov r0, #0                  
  svc 0                       

.data
  string1:  .asciz "a"
  string2:  .asciz "b"
  format1:   .asciz "%s, %s, %d\n"
  format2:   .asciz "%d, %d, %s\n"

# Program Name: template.s
# Author: Ken Hwang 
# Date: 11/7/2024
# Purpose: This program is template that can be used to start ARM assembly
#

.text
.global main

main:
  # save to stack
  sub sp, sp, #4
  str lr, [sp, #0]

  # enter your program here.

  # restore stack
  ldr lr, [sp, #0]
  add sp, sp, #4

  # exit
  mov r7, #1                  
  mov r0, #0                  
  svc 0                       

.data
# Program name:       problem5.s
# Author:             Ken Hwang
# Date:               11/7/2024
# Purpose:            Print float
 
.text
.global main

main:
  # save to stack
  sub sp, sp, #4
  str lr, [sp, #0]

  # float prompt
  ldr r0, =prompt
  bl printf

  # scan float
  ldr r0, =input
  ldr r1, =num
  bl scanf

  # convert
  ldr r1, =num                    @ r1 is cleared out from scanf
  ldr r1, [r1, #0]
  vmov s14, r1 
  vcvt.F64.F32 d5, s14

  # print float (only takes 64-bit double)
  ldr r0, =format
  vmov r1, s10                    @ s[10] = d5[0], printf takes r1 and r2 arguments for floats
  vmov r2, s11                    @ s[11] = d5[1]
  bl printf

  # restore stack
  ldr lr, [sp, #0]
  add sp, sp, #4

  # exit
  mov r7, #1                  
  mov r0, #0                  
  svc 0                       

.data
  prompt: .asciz "Input float: "
  input:  .asciz "%f"
  format: .asciz "%.6f\n"
  num:    .float 0

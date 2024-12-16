@ Program name:       problem2.s
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:             

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter temperature (C): "
input1:
  .asciz "%d"
output1:
  .asciz "Temperature (F): %.2f\n"
prompt2:
  .asciz "Enter inches: "
input2:
  .asciz "%d"
newline:
  .asciz "\n"

@ Program code
        .equ    response1, -4
        .equ    response2, -8
        .equ    locals, 8
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub             sp, sp, #4
  str             lr, [sp, #0]
  sub             sp, sp, #locals

# Problem 2a

# prompt for temperature
ldr r0, =prompt1
bl printf

# read temperature
ldr r0, =input1
add r1, sp, response1
bl scanf

# call CToF
ldr r0, [sp, response1]
bl CToF                         @ result in r0

vmov s14, r0 
vcvt.F64.F32 d5, s14

# print float 
ldr r0, =output1
vmov r1, s10                    @ s[10] = d5[0], printf takes r1 and r2 arguments for floats
vmov r2, s11                    @ s[11] = d5[1]
bl printf                       @ Does not work with frame pointer for some reason

# Problem 2b

# prompt for inches
ldr r0, =prompt2
bl printf

# read inches
ldr r0, =input2
add r1, sp, response2
bl scanf

# scale up by 1000
ldr r0, [sp, response2]
mov r1, #1000
mul r0, r0, r1

# Convert
bl Inches2Ft
mov r1, r0 

# print (scale down by 1000)
mov r1, #1000
bl printScaledInt
ldr r0, =newline
bl printf

mov             r0, #0
add             sp, sp, #locals
ldr             lr, [sp, #0]
add             sp, sp, #4
bx              lr 

.section  .note.GNU-stack,"",%progbits


@ Program name:       problem4.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Convert from feet to inches and vice versa

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Press 0 to convert from feet to inches, or 1 for inches to feet\n"
input1:
  .asciz "%d"
prompt2:
  .asciz "Enter value: "
input2:
  .asciz "%d"
feetToInchesFormat:
  .asciz "%d feet is %d inches\n"
inchesToFeetFormat:
  .asciz "%d inches is %d' %d\"\n"
 
@ Program code
        .equ    arg1, -8
        .equ    arg2, -12
        .equ    locals, 8
        .text
        .global __aeabi_idiv
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub     sp, sp, #8
  str     fp, [sp, #0]
  str     lr, [sp, #4]
  add     fp, sp, #4
  sub     sp, sp, #locals

  # convert from feet to inches or inches to feet
  ldr     r0, =prompt1
  bl      printf

  ldr     r0, =input1              
  add     r1, fp, #arg1
  bl      scanf

  # value
  ldr     r0, =prompt2
  bl      printf

  ldr     r0, =input2
  add     r1, fp, #arg2
  bl      scanf

  # call convertLength function
  ldr     r0, [fp, #arg1]
  ldr     r1, [fp, #arg2]
  bl      convertLength
  mov     r2, r0
  mov     r3, r1

  # message
  ldr     r0, [fp, #arg1]
  cmp     r0, #0
  bne     useInchestoFeetFormat      

  useFeetToInchesFormat:
    ldr     r0, =feetToInchesFormat
    b       printConvertedLength
  
  useInchestoFeetFormat:
    ldr     r0, =inchesToFeetFormat
    b       printConvertedLength

  printConvertedLength:
    ldr     r1, [fp, #arg2]
    bl      printf

  mov     r0, #0
  add     sp, sp, #locals
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits

@ Calling sequence:
@        r0: 0 for feet to inches, 1 for inches to feet
@        r1: value
@        bl      convertLength
@        converted value returned in r0
@        if converting inches to feet, remainder inches returned in r1

@ Program code
        .text
        .align  2
        .global convertLength
        .type   convertLength, %function
        .syntax unified

convertLength:
  sub     sp, sp, #8
  str     fp, [sp, #0]
  str     lr, [sp, #4]
  add     fp, sp, #4

  cmp     r0, #0
  mov     r2, #12
  bne     inchesToFeet

  # calculate feet to inches
  feetToInches:
    mul     r0, r1, r2
    b       exitConvertLength

  # calculate inches to feet
  inchesToFeet:
    mov     r0, r1
    mov     r1, r2
    bl      __aeabi_idivmod
    b       exitConvertLength

  exitConvertLength:
    ldr     fp, [sp, #0]
    ldr     lr, [sp, #4]
    add     sp, sp, #8
    bx      lr 


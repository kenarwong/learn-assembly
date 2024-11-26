
@ Program name:       problem5.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Convert from kilometers to miles and vice versa

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Press 0 to convert from kilometers to miles, or 1 for miles to kilometers\n"
input1:
  .asciz "%d"
prompt2:
  .asciz "Enter value: "
input2:
  .asciz "%d"
kilometersToMilesFormat:
  .asciz "%d kilometers is %.3f miles\n"
milesToKilometersFormat:
  .asciz "%d miles is %.3f kilometers\n"
 
@ Program code
        .equ    arg1, -8
        .equ    arg2, -12
        .equ    locals, 8
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

  # convert from kilometers to miles or miles to kilometers
  ldr             r0, =prompt1
  bl              printf

  ldr             r0, =input1              
  add             r1, fp, #arg1
  bl              scanf

  # value
  ldr             r0, =prompt2
  bl              printf

  ldr             r0, =input2
  add             r1, fp, #arg2
  bl              scanf

  # call convertLength function
  ldr             r0, [fp, #arg1]
  ldr             r1, [fp, #arg2]
  bl              convertLength

  # message
  ldr             r0, [fp, #arg1]
  cmp             r0, #0
  bne             useMilesToKilometersFormat      

  useKilometersToMilesFormat:
    ldr           r0, =kilometersToMilesFormat
    b             printConvertedLength
  
  useMilesToKilometersFormat:
    ldr           r0, =milesToKilometersFormat
    b             printConvertedLength

  printConvertedLength:
    ldr           r1, [fp, #arg2]

    # print float (only takes 64-bit double)
    vcvt.f64.f32  d0, s0
    vmov          r2, s0                    @ s[0] = d0[0]
    vmov          r3, s1                    @ s[1] = d0[1]
    bl            printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Calling sequence:
@        r0: 0 for kilometers to miles, 1 for miles to kilometers
@        r1: value
@        bl      convertLength
@        converted value returned in s0

@ Constant program data
        .section  .rodata
        .align  2
mileToKilometersConversion: 
  .float 1.60934

@ Program code
        .text
        .align  2
        .global convertLength
        .type   convertLength, %function
        .syntax unified

convertLength:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  vmov            s0, r1 
  vcvt.f32.s32    s0, s0
  ldr             r1, =mileToKilometersConversion  
  vldr.32         s2, [r1, #0]

  cmp             r0, #0
  bne             milesToKilometers

  # calculate kilometers to miles
  kilometersToMiles:
    vdiv.f32      s4, s0, s2
    vmov          s0, s4
    b             exitConvertLength

  # calculate miles to kilometers
  milesToKilometers:
    vmul.f32      s0, s0, s2
    b             exitConvertLength

  exitConvertLength:
    ldr           fp, [sp, #0]
    ldr           lr, [sp, #4]
    add           sp, sp, #8
    bx            lr 


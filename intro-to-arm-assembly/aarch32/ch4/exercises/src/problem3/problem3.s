
@ Program name:       problem3.s
@ Author:             Ken Hwang
@ Date:               11/25/2024
@ Purpose:            Convert from Celsius to Fahrenheit and vice versa

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Press 0 to convert from Celsius to Fahrenheit, or 1 for Fahrenheit to Celsius\n"
input1:
  .asciz "%d"
prompt2:
  .asciz "Enter temperature: "
input2:
  .asciz "%d"
celsiusToFahrenheitFormat:
  .asciz "%d degrees Celsius is %d degrees Fahrenheit\n"
fahrenheitToCelsiusFormat:
  .asciz "%d degrees Fahrenheit is %d degrees Celsius\n"
 
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

  # convert from Celsius to Fahrenheit or Fahrenheit to Celsius
  ldr     r0, =prompt1
  bl      printf

  ldr     r0, =input1              
  add     r1, fp, #arg1
  bl      scanf

  # temperature
  ldr     r0, =prompt2
  bl      printf

  ldr     r0, =input2
  add     r1, fp, #arg2
  bl      scanf

  # call convertTemp function
  ldr     r0, [fp, #arg1]
  ldr     r1, [fp, #arg2]
  bl      convertTemp
  mov     r2, r0

  # message
  ldr     r0, [fp, #arg1]
  cmp     r0, #0
  bne     useFahrenheitToCelsiusFormat

  useCelsiusToFahrenheitFormat:
    ldr     r0, =celsiusToFahrenheitFormat
    b       printConvertedTemperature
  
  useFahrenheitToCelsiusFormat:
    ldr     r0, =fahrenheitToCelsiusFormat
    b       printConvertedTemperature

  printConvertedTemperature:
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
@        r0: 0 for Celsius to Fahrenheit, 1 for Fahrenheit to Celsius
@        r1: temperature
@        bl      convertTemp
@        converted temperature returned in r0

@ Program code
        .text
        .align  2
        .global convertTemp
        .type   convertTemp, %function
        .syntax unified

convertTemp:
  sub     sp, sp, #8
  str     fp, [sp, #0]
  str     lr, [sp, #4]
  add     fp, sp, #4

  cmp     r0, #0
  beq     celsiusToFahrenheit
  bne     fahrenheitToCelsius

  # calculate celsius to fahrenheit
  celsiusToFahrenheit:
    mov     r2, #9
    mul     r0, r1, r2
    mov     r1, #5
    bl      __aeabi_idiv
    add     r0, r0, #32
    b       exitConvertTemp

  # calculate fahrenheit to celsius
  fahrenheitToCelsius:
    sub     r0, r1, #32
    mov     r2, #5
    mul     r0, r0, r2
    mov     r1, #9
    bl      __aeabi_idiv
    b       exitConvertTemp

  exitConvertTemp:
    ldr     fp, [sp, #0]
    ldr     lr, [sp, #4]
    add     sp, sp, #8
    bx      lr 


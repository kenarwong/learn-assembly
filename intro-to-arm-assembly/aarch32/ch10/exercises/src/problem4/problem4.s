@ Program name:       problem4.s
@ Author:             Ken Hwang
@ Date:               1/2/2024
@ Purpose:            Create k-strings from a binary set

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter length k for k-strings (1-8): "
input:
  .asciz "%d"
error:
  .asciz "You entered invalid input.\n"

@ Program code
        .equ    value,  -8
        .equ    temp1,  -12
        .equ    temp2,  -16
        .equ    locals, 12
        .equ    size_t, 1
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]

  # initial prompt   
  ldr               r0, =prompt
  bl                printf
  ldr               r0, =input
  add               r1, fp, value
  bl                scanf
  ldr               r4, [fp, value]                         @ k

  # validate input
  mov               r1, #0
  cmp               r4, r1
  ble               invalidInput                            @ le 0, failed validation

  mov               r1, #8
  cmp               r4, r1
  bgt               invalidInput                            @ gt 8, failed validation

  # number of k-strings = |S|^k
  mov               r1, #1                                  
  lsl               r5, r1, r4                              @ number of k-strings: 2^k = 1 << k

  # allocate memory
  mov               r0, #size_t
  mov               r1, r5
  bl                calloc
  mov               r1, r0                                  @ base addr

  # populate (bytes) with natural numbers from 0 to (|S|^k) - 1
  mov               r2, #0                                  @ i = 0

  populateKStringsLoop:
    cmp             r2, r5
    beq             endPopulateKStringsLoop                 @ if i == number of k-strings, end loop
    
    strb            r2, [r1], #size_t                       @ store i

    add             r2, r2, #1                              @ i++
    b               populateKStringsLoop

  endPopulateKStringsLoop:
  mov               r1, #size_t
  mul               r1, r1, r5                              @ array length

  mov               r5, r0                                  @ base addr 

  # print byte array
  mov               r2, r4                                  @ binary k-string length 
  bl                printByteArray

  # free memory
  mov               r0, r5
  bl                free

  b                 exit

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf
  
  exit:
    ldr             r5, [fp, #temp2]
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

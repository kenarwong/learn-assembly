@ Program name:       problem2.s
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Convert decimal to hex

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a number from 0 to 15: "
input:
  .asciz "%d"
output:
  .asciz "your number is %s\n"
error:
  .asciz "You entered invalid input.\n"

@ Program code
        .equ    value,  -8
        .equ    temp1,  -12
        .equ    temp2,  -16
        .equ    locals,  12
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
  ldr               r2, [fp, value]                         @ user value

  # validate input
  mov               r0, 0x0
  cmp               r2, r0
  blt               invalidInput                            @ lt 0, failed validation

  mov               r0, 0x10
  cmp               r2, r0
  bge               invalidInput                            @ ge 16, failed validation

  # allocate memory
  mov               r4, 0x4                                 @ size_t (4 bytes)
  mov               r0, 0x10                                @ array length
  mov               r1, r4                                   
  bl                calloc                                  
  mov               r5, r0                                  @ base address

  # populate hex conversion strings
  mov               r1, 0x0                                 @ i = 0
  mov               r2, r5                                  @ address

  populateHexStringLoop:
    cmp             r1, 0x10
    beq             populateHexStringEndLoop                @ i == 16, end loop

    mov             r0, 0x30                                @ ASCII "0"
    strb            r0, [r2], #1                            @ base addr + 1 byte
    mov             r0, 0x78                                @ ASCII "x"
    strb            r0, [r2], #1                            @ base addr + 1 byte

    cmp             r1, #10                                 
    bge             calculateASCIIatof                      @ if i >= 10

    calculateASCII0to9:
      orr           r0, r1, 0x30                            @ ASCII 0-9: 0b0011xxxx
      b             storeASCII

    calculateASCIIatof:
      sub           r0, r1, #9                              @ i - 9 (1-based, a = 1, b = 2, ...)
      orr           r0, r0, 0x60                            @ ASCII a-f: 0b0110xxxx
      b             storeASCII
  
    storeASCII:
      strb          r0, [r2], #1                            @ base addr + 1 byte
      mov           r0, #0                                  @ ASCII null 
      strb          r0, [r2], #1                            @ base addr + 1 byte

      add           r1, r1, #1                              @ i++
      b             populateHexStringLoop         

  populateHexStringEndLoop:

  # convert user value to address
  ldr               r0, [fp, value]                         @ user value
  mul               r0, r0, r4                              @ value * size_t
  add               r1, r5, r0                              @ base addr + (value * size_t)

  # print
  ldr               r0, =output
  bl                printf

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

@ Program name:       problem5.s
@ Author:             Ken Hwang
@ Date:               1/2/2025
@ Purpose:            Reverse string

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Type a word: "
input:
  .asciz "%49s%n"                                           @ limit string to half of stringCharLength (less null terminator)
                                                            @ record number of character's scanned
output:
  .asciz "Reversed: %s\n"
stringCharLength:
  .word  100                                                @ to store both string and reversed string

@ Program code
        .equ    temp1,            -8
        .equ    temp2,            -12
        .equ    numberOfChars,    -16
        .equ    locals,           12
        .equ    size_t,           1                         @ size of char in bytes
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

  # allocate memory
  ldr               r4, =stringCharLength
  ldr               r4, [r4, #0]                            @ length of both strings

  mov               r0, r4
  mov               r1, #size_t           
  bl                calloc
  mov               r5, r0                                  @ string pointer

  # initial prompt   
  ldr               r0, =prompt
  bl                printf

  ldr               r0, =input
  mov               r1, r5                                  @ string address
  add               r2, fp, #numberOfChars                  @ record number of characters scanned
  bl                scanf

  # reverse string
  mov               r0, r5                                  @ string addr
  add               r1, r5, r4, lsr #1                      @ reverse string addr (second half of allocated memory size)

  # mov               r2, #size_t                             @ char size
  # add               r3, fp, #numberOfChars                  @ string length 
  # mul               r2, r2, r3                              @ string size

  bl                reverseString

  # print reversed string
  ldr               r0, =output
  # mov               r1, r5                                  @ string address
  add               r1, r5, r4, lsr #1                      @ reverse string addr (second half of allocated memory size)
  bl                printf

  # free memory
  mov               r0, r5
  bl                free

  ldr               r5, [fp, #temp2]
  ldr               r4, [fp, #temp1]
  add               sp, sp, #locals
  mov               r0, #0
  ldr               fp, [sp, #0]
  ldr               lr, [sp, #4]
  add               sp, sp, #8
  bx                lr 

  .section  .note.GNU-stack,"",%progbits

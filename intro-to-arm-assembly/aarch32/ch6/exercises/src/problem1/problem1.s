
@ Program name:       problem1.s
@ Author:             Ken Hwang
@ Date:               11/28/2024
@ Purpose:            Bit masks for operations 

@ Constant program data
        .section  .rodata
        .align  2
binaryFormat:
  .asciz "%b\n"
hexFormat:
  .asciz "%x\n"

@ Program code
        .equ    ins1, -8
        .equ    ins2, -12
        .equ    ins3, -16
        .equ    ins4, -20
        .equ    ins5, -24
        .equ    ins6, -28
        .equ    ins6a, -32
        .equ    ins7, -36
        .equ    ins7a, -40
        .equ    ins8, -44
        .equ    ins8a, -48
        .equ    ins9, -52
        .equ    ins9a, -56
        .equ    ins10, -60
        .equ    locals, 56
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

  # Bit mask for OpType [25:27] is 0x0e000000
  # Bit mask for OpCode [24:21] is 0x01e00000


  # MOV (Register, Shifted Register, ShAmt)
  # mask: 0b00000001101000000000000000000000
  ldr             r1, [pc]                        @ (IF) mov r2,r3
  str             r1, [fp, ins1]             
  mov             r2, r3
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins1]             
  bl              printf

  # MOV (Modified Immediate)
  # mask: 0b00000011101000000000000000000000
  ldr             r1, [pc, #-0]                  @ (IF) mov r1,#1,2
  str             r1, [fp, ins2]
  mov             r2, #2, 4 
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins2]
  bl              printf

  # MOV (Register, Shifted Register, ShAmt)
  # mask: 0b00000001101000000000000000000000
  ldr             r1, [pc]                        @ (IF) mov r1,r2,lsl #3
  str             r1, [fp, ins3]             
  mov             r2, r3, lsl #3                  @ same as lsl
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins3]             
  bl              printf

  # MOV (Register, Shifted Register, Rs)
  # mask: 0b00000001101000000000000001010000
  ldr             r1, [pc]                        @ (IF) mov r1,r2,asr r3
  str             r1, [fp, ins4]             
  mov             r2, r3, asr r3                  @ same as asr
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins4]             
  bl              printf

  # MUL (Register)
  # mask: 0b00000000000000000000000010010000
  ldr             r1, [pc]                        @ (IF) mul r2,r2,r3
  str             r1, [fp, ins5]             
  mul             r2, r2, r3                  
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins5]             
  bl              printf

  # Load (Register)
  # mask: 0b00000110000100000000000000000000
  mov             r0, 2
  str             r0, [fp, ins6a]
  mov             r0, ins6a
  ldr             r1, [pc]                          @ (IF) str r2,[fp,r0]
  str             r1, [fp, ins6]             
  ldr             r2, [fp, r0]
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins6]             
  bl              printf

  # Load (Immediate)
  # mask: 0b00000100000100000000000000000000
  str             r2, [fp, ins7a]             
  ldr             r1, [pc]                          @ (IF) ldr r2,[fp,ins7a]
  str             r1, [fp, ins7]             
  ldr             r2, [fp, ins7a]
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins7]             
  bl              printf

  # Store (Register)
  # mask: 0b00000110000000000000000000000000
  mov             r0, ins8a
  ldr             r1, [pc]                          @ (IF) str r2,[fp,r0]
  str             r1, [fp, ins8]             
  str             r2, [fp, r0]
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins8]             
  bl              printf

  # Store (Immediate)
  # mask: 0b00000100000000000000000000000000
  ldr             r1, [pc]                          @ (IF) str r2,[fp,ins9a]
  str             r1, [fp, ins9]             
  str             r2, [fp, ins9a]             
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins9]             
  bl              printf

  # Add (Register)
  # mask: 0b00000000100000000000000000000000
  ldr             r1, [pc]                          @ (IF) add r2,r2,r3
  str             r1, [fp, ins10]             
  add             r2, r2, r3
   
  ldr             r0, =hexFormat
  bl              printf

  ldr             r0, =binaryFormat
  ldr             r1, [fp, ins10]             
  bl              printf

  mov             r0, #0
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits


@ Program name:       problem4.s
@ Author:             Ken Hwang
@ Date:               11/26/2024
@ Purpose:            Operand2 decimal values 

@ Constant program data
        .section  .rodata
        .align  2
format:
  .asciz "%d\n"

@ Program code
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub     sp, sp, #8
  str     fp, [sp, #0]
  str     lr, [sp, #4]
  add     fp, sp, #4

  # a) 1024
  ldr     r0, =format
  # mov     r1, #0b1, 22

  mov     r1, #0b1
  lsl     r1, r1, #10                 @ 32 - 22 = 10
                                      @ 2^10 = 1024
  bl      printf

  # b) 144
  ldr     r0, =format
  # mov     r1, #0b1001, 28

  mov     r1, #0b1001
  lsl     r1, r1, #4                  @ 32 - 28 = 4
                                      @ 9 << 4 = 9 * 2^4 = 144
  bl      printf

  # c) 580
  ldr     r0, =format
  # mov     r1, #0b10010001, 30

  mov     r1, #0b10010001
  lsl     r1, r1, #2                  @ 32 - 30 = 2
                                      @ 145 << 2 = 145 * 2^2 = 580
  bl      printf

  # d) 589824
  ldr     r0, =format
  # mov     r1, #0b1001, 16

  mov     r1, #0b1001
  lsl     r1, r1, #16                 @ 32 - 16 = 16
                                      @ 9 << 16 = 9 * 2^16 = 589824
  bl      printf

  # d) -35
  ldr     r0, =format
  # mvn     r1, #0b100010             

  mov     r1, #0b11011101, 8          @ -(34 + 1) = -35
  asr     r1, r1, 24
  bl      printf

  # e) -36865
  ldr     r0, =format
  # mvn     r1, #0b1001, 20           

  ldr     r0, =format
  mov     r1, #0b11110110, 8          @ -(9*2^12 + 1) = -36865
  asr     r1, r1, 12                
  mov     r2, 0xff
  orr     r1, r1, r2
  mov     r2, 0xf
  orr     r1, r1, r2, lsl #8          
  bl      printf

  mov     r0, #0
  ldr     fp, [sp, #0]
  ldr     lr, [sp, #4]
  add     sp, sp, #8
  bx      lr 

  .section  .note.GNU-stack,"",%progbits

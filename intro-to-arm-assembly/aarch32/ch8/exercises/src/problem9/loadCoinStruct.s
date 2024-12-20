@ Program name:       loadCoinStruct.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Load a coin struct at pointer with fields
@ Input:              r0 - struct pointer 
@                     r1 - quantity  
@                     r2 - label address 

@ Program code
        .equ    quantity, 0
        .equ    label, 4
        .text
        .align  2
        .global loadCoinStruct
        .type   loadCoinStruct, %function

loadCoinStruct:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  str             r1, [r0, #quantity]
  str             r2, [r0, #label]

  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       getCoinStructFields.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Load registers with fields of coin struct at pointer
@ Input:              r0 - struct pointer 
@ Output:             r1 - quantity
@                     r2 - label address  

@ Program code
        .equ    quantity, 0
        .equ    label, 4
        .text
        .align  2
        .global getCoinStructFields
        .type   getCoinStructFields, %function

getCoinStructFields:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  ldr             r1, [r0, #quantity]
  ldr             r2, [r0, #label]

  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

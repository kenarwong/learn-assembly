@ Program name:       problem7.s
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Demonstrate recursive factorial 

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a value: "
input:
  .asciz "%d"
output:
  .asciz "!%d = %d\n"
overflowOutput:
  .asciz "Overflow!\n"

@ Program code
        .equ    value,        -8
        .equ    locals,       8
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

  # prompt value
  ldr             r0, =prompt
  bl              printf

  ldr             r0, =input
  add             r1, fp, value
  bl              scanf

  # handle negative
  mov             r1, #0
  ldr             r0, [fp, value]
  cmp             r0, r1
  movmi           r0, #0
  strmi           r0, [fp, value]

  # recurse
  mov             r1, #1                    @ initialize product (1)
  bl              factorialRecurse
  cmp             r1, #1                    @ check overflow
  beq             overflowDetected

  # display output
  mov             r2, r0
  ldr             r0, =output
  ldr             r1, [fp, value]
  bl              printf

  b               exit

  # display overflow
  overflowDetected:
    ldr             r0, =overflowOutput
    bl              printf

  exit:
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       factorialRecurse
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Recursively multiply by n * F(n-1)
@ Input:              r0 - value
@                     r1 - product
@ Output:             r0 - product
@                     r1 - overflow

@ Program code
        .equ    value,        -8
        .equ    product,      -12
        .equ    overflow,     -16
        .equ    locals,       12
        .text
        .align  2
        .type   factorialRecurse, %function

factorialRecurse:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, value]
  str             r5, [fp, product]
  str             r6, [fp, overflow]

  # initialize
  mov             r4, r0                  @ value
  mov             r5, r1                  @ product

  # base case     
  cmp             r4, #1          
  movle           r6, #0                  @ initialize overflow (0)
  ble             return                  @ value <= 1, return 

  # recurse
  sub             r0, r4, #1              @ value--
  mov             r1, r5                  @ product
  bl              factorialRecurse
  mov             r5, r0
  mov             r6, r1          

  # add
  umull           r5, r0, r5, r4          @ product * value
  cmp             r0, #0          
  movne           r6, #1                  @ upper byte != 0, overflow 

  return:
    mov             r0, r5                @ return product
    mov             r1, r6                @ return overflow

    ldr             r5, [fp, product]
    ldr             r4, [fp, value]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

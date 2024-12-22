@ Program name:       problem3.s
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Demonstrate recursive multiplication 

@ Constant program data
        .section  .rodata
        .align  2
prompt1:
  .asciz "Enter a value: "
prompt2:
  .asciz "Enter a multiplier: "
input:
  .asciz "%d"
output:
  .asciz "%d * %d = %d\n"

@ Program code
        .equ    multiplicand, -8
        .equ    multiplier,   -12
        .equ    negation,     -16
        .equ    locals,       12
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

  # prompt multiplicand
  ldr             r0, =prompt1
  bl              printf

  ldr             r0, =input
  add             r1, fp, multiplicand
  bl              scanf

  # prompt multiplier
  ldr             r0, =prompt1
  bl              printf

  ldr             r0, =input
  add             r1, fp, multiplier
  bl              scanf

  # handle negative
  mov             r2, #0
  ldr             r0, [fp, multiplicand]
  cmp             r0, r2
  movmi           r2, #1
  mvnmi           r0, r0
  addmi           r0, r0, #1

  mov             r3, #0
  ldr             r1, [fp, multiplier]
  cmp             r1, r3
  movmi           r3, #1
  mvnmi           r1, r1
  addmi           r1, r1, #1

  eor             r2, r2, r3
  str             r2, [fp, negation]

  # recurse
  mov             r2, #0                      @ initialize sum (0)
  bl              mulRecurse

  # handle negative
  ldr             r1, [fp, negation]
  cmp             r1, #1
  mvneq           r0, r0
  addeq           r0, r0, #1

  # display output
  mov             r3, r0
  ldr             r0, =output
  ldr             r1, [fp, multiplicand]
  ldr             r2, [fp, multiplier]
  bl              printf

  exit:
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       mulRecurse
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Recursively add to sum for multiplier amount of times 
@ Input:              r0 - multiplicand
@                     r1 - multiplier
@                     r2 - sum
@ Output:             r0 - sum

@ Program code
        .equ    multiplicand, -8
        .equ    multiplier,   -12
        .equ    sum,          -16
        .equ    locals,       12
        .text
        .align  2
        .type   mulRecurse, %function

mulRecurse:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, multiplicand]
  str             r5, [fp, multiplier]
  str             r6, [fp, sum]

  # initialize
  mov             r4, r0          @ multiplicand
  mov             r5, r1          @ multiplier
  mov             r6, r2          @ sum

  # base case     
  cmp             r5, #0          
  beq             return          @ multiplier == 0, return 

  # recurse
  mov             r0, r4          @ multiplicand
  sub             r1, r5, #1      @ multiplier--
  mov             r2, r6          @ sum
  bl              mulRecurse

  # add
  add             r6, r0, r4      @ sum + multiplicand

  return:
    mov             r0, r6          @ return sum

    ldr             r6, [fp, sum]
    ldr             r5, [fp, multiplier]
    ldr             r4, [fp, multiplicand]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

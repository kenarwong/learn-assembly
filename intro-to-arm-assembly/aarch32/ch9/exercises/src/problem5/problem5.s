@ Program name:       problem5.s
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Demonstrate recursive squared value 

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a value: "
input:
  .asciz "%d"
output:
  .asciz "%d^2 = %d\n"
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
  mvnmi           r0, r0
  addmi           r0, r0, #1

  # recurse
  mov             r1, r0                      @ initialize count (n)
  mov             r2, #0                      @ initialize sum (0)
  bl              squareRecurse
  cmp             r1, #1                      @ check overflow
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

@ Program name:       squareRecurse
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Recursively add to sum for count amount of times 
@ Input:              r0 - value
@                     r1 - count
@                     r2 - sum
@ Output:             r0 - sum
@                     r1 - overflow

@ Program code
        .equ    value,        -8
        .equ    count,        -12
        .equ    sum,          -16
        .equ    overflow,     -20
        .equ    locals,       16
        .text
        .align  2
        .type   squareRecurse, %function

squareRecurse:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, value]
  str             r5, [fp, count]
  str             r6, [fp, sum]
  str             r7, [fp, overflow]

  # initialize
  mov             r4, r0                  @ value
  mov             r5, r1                  @ count
  mov             r6, r2                  @ sum

  # base case     
  cmp             r5, #0          
  moveq           r7, #0                  @ initialize no overflow (0)
  beq             return                  @ count == 0, return 

  # recurse
  mov             r0, r4                  @ value
  sub             r1, r5, #1              @ count--
  mov             r2, r6                  @ sum
  bl              squareRecurse
  mov             r6, r0          
  mov             r7, r1          

  # add
  adds            r6, r6, r4              @ sum + value
  movvs           r7, #1                  @ overflow detected (1)

  return:
    mov             r0, r6                @ return sum
    mov             r1, r7                @ return overflow

    ldr             r7, [fp, overflow]
    ldr             r6, [fp, sum]
    ldr             r5, [fp, count]
    ldr             r4, [fp, value]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

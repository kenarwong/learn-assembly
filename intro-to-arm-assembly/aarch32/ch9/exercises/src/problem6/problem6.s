@ Program name:       problem6.s
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Demonstrate recursive fibonacci 

@ Constant program data
        .section  .rodata
        .align  2
prompt:
  .asciz "Enter a limit (>=2): "
input:
  .asciz "%d"
output:
  .asciz "%d"
openBracket:
  .asciz "["
closedBracket:
  .asciz "]\n"
separator:
  .asciz ","
invalidInput:
  .asciz "Invalid input.\n"

@ Program code
        .equ    limit,        -8
        .equ    array,        -12
        .equ    temp1,        -16
        .equ    temp2,        -20
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
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]

  # prompt limit
  ldr             r0, =prompt
  bl              printf

  ldr             r0, =input
  add             r1, fp, limit
  bl              scanf

  # validation
  ldr             r0, [fp, limit]
  cmp             r0, #2
  bmi             displayInvalidInput                     @ < 2, failed validation

  # allocate memory
  lsl             r0, r0, #2                              @ bytes
  bl              malloc
  mov             r2, r0
  str             r2, [fp, array]

  # f(0) = 0, f(1) = 1
  mov             r0, #0
  str             r0, [r2], #4
  mov             r1, #1
  str             r1, [r2], #4

  # recurse
  ldr             r3, [fp, limit]             
  sub             r3, r3, #2                              @ limit = limit - 2
  bl              fibonnaciRecurse

  # display output sequence
  ldr             r4, [fp, limit]                         @ i = limit
  ldr             r5, [fp, array]                         @ array pointer

  ldr             r0, =openBracket
  bl              printf
  
  # display first number
  ldr             r0, =output
  ldr             r1, [r5], #4
  bl              printf

  sub             r4, r4, #1                            @ i--

  displayFibonacciSequenceLoop:
    cmp             r4, #0 
    beq             displayFibonacciSequenceLoopEnd       @ i == 0, exit

    ldr             r0, =separator
    bl              printf

    ldr             r0, =output
    ldr             r1, [r5], #4
    bl              printf

    sub             r4, r4, #1                            @ i--
    b               displayFibonacciSequenceLoop

  displayFibonacciSequenceLoopEnd:
    ldr             r0, =closedBracket
    bl              printf

    # deallocate memory
    ldr             r0, [fp, array]                       @ array pointer
    bl              free

    b               exit 

  # display invalid
  displayInvalidInput:
    ldr             r0, =invalidInput
    bl              printf

  exit:
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    mov             r0, #0
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       fibonnaciRecurse
@ Author:             Ken Hwang
@ Date:               12/22/2024
@ Purpose:            Recursive add and store fibonacci numbers
@ Input:              r0 - F(n)
@                     r1 - F(n+1)
@                     r2 - array index
@                     r3 - count

@ Program code
        .text
        .align  2
        .type   fibonnaciRecurse, %function

fibonnaciRecurse:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  # base case     
  cmp             r3, #0          
  beq             return                    @ count == 0, return 

  # calculate next
  adds            r0, r0, r1 
  bvs             overflowDetected

  str             r0, [r2], #4              @ store

  # swap r0 and r1
  eor             r0, r0, r1 
  eor             r1, r1, r0 
  eor             r0, r0, r1      

  # recurse
  sub             r3, r3, #1                @ count--
  bl              fibonnaciRecurse

  b               return

  overflowDetected:
    # stop recursion, unwind stack

  return: 
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

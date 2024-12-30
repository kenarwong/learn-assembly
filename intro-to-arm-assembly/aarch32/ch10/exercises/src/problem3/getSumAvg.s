@ Program name:       getSumAvg
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Return sum and average of an int array
@ Input:              r0 - array base
@                     r1 - array length
@ Output:             r0 - sum
@                     r1 - average
@                     r2 - overflow (1 = overflow)

@ Constant program data
        .section  .rodata
        .align  2
.data
  printSumOverflow: .asciz "Overflow!\n"

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals, 8
        .equ    size_t, 4
        .text
        .align  2
        .global getSumAvg
        .type   getSumAvg, %function

getSumAvg:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, #temp1]
  str             r5, [fp, #temp2]

  mov             r4, r0                      @ base addr
  mov             r5, r1                      @ array length (n)

  # initialize
  mov             r0, #0                      @ sum
  mov             r1, #0                      @ i

  # loop
  getSumAvgLoop:
    cmp           r1, r5
    beq           getSumAvgEndLoop            @ i == n, end loop

    ldr           r2, [r4], #size_t           @ base addr + size_t

    adds          r0, r0, r2                  @ sum += number
    bvs           reportOverflow              @ abort on overflow

    add           r1, r1, #1                  @ i++
    b getSumAvgLoop
  
  getSumAvgEndLoop:

  mov             r4, r0                      @ save sum

  # calculate average
  bl              __aeabi_idiv                @ sum/i
  mov             r1, r0                      @ average
  mov             r0, r4                      @ sum
  mov             r2, #0                      @ overflow = 0

  b exitSumAvg

  reportOverflow:
    ldr           r0, =printSumOverflow
    bl            printf

    mov           r2, #1                      @ overflow = 1

  exitSumAvg:
    ldr             r5, [fp, #temp2]
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

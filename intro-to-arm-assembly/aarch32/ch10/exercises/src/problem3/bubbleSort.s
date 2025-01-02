@ Program name:       bubbleSort
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Bubble sort an int array
@ Input:              r0 - array base
@                     r1 - array length

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    temp4,  -20
        .equ    locals, 16
        .equ    size_t, 4
        .text
        .align  2
        .global bubbleSort
        .type   bubbleSort, %function

bubbleSort:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, #temp1]
  str             r5, [fp, #temp2]
  str             r6, [fp, #temp3]
  str             r7, [fp, #temp4]

  mov             r4, r0                            @ base addr
  sub             r5, r1                            @ length (n)
  sub             r6, r1, #1                        @ k = n - 1 (number of passes)

  bubbleSortLoop:
    # check k 
    cmp           r6, #0
    beq           bubbleSortEndLoop                 @ if k == 0, end loop

    # initialize
    mov           r0, #0                            @ i
    mov           r3, r4                            @ current addr
    sub           r7, #0                            @ track swap (0 = no swaps occurred)

    bubbleSortPass:
      cmp         r0, r6                            
      beq         endBubbleSortPass                 @ if i == k, end pass

      # load values
      ldr         r1, [r3, #0]
      ldr         r2, [r3, #size_t]

      # compare
      cmp         r1, r2
      ble         continueBubbleSortPass            @ if r1 <= r2, do nothing
                                                    @ else swap
      # swap
      str         r2, [r3, #0]
      str         r1, [r3, #size_t]
      mov         r7, #1                            @ mark swap occurred

      continueBubbleSortPass:
        add       r3, r3, #size_t                   @ current addr += size_t
        add       r0, r0, #1                        @ i++
        b bubbleSortPass
    
    endBubbleSortPass:
      # check swaps
      cmp         r7, #0
      beq         bubbleSortEndLoop                 @ if no swaps, exit loop

      sub         r6, r6, #1                        @ k--
      b           bubbleSortLoop

  bubbleSortEndLoop:

  ldr             r7, [fp, #temp4]
  ldr             r6, [fp, #temp3]
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

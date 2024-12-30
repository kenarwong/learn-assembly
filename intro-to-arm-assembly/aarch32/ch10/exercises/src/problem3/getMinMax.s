@ Program name:       getMinMax
@ Author:             Ken Hwang
@ Date:               12/30/2024
@ Purpose:            Return min and max values in an int array
@ Input:              r0 - array base
@                     r1 - array length
@ Output:             r0 - min value
@                     r1 - max value

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals, 8
        .equ    size_t, 4
        .text
        .align  2
        .global getMinMax
        .type   getMinMax, %function

getMinMax:
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
  ldr             r0, [r0, #0]                @ min
  mov             r1, r0                      @ max
  mov             r2, #0                      @ i

  # vldm            r0, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
  # vmax.s32        s2, s1, s0

  # loop
  getMinMaxLoop:
    cmp           r2, r5
    beq           getMinMaxEndLoop            @ i == n, end loop

    ldr           r3, [r4], #size_t           @ base addr + size_t

    compareMin:
      cmp           r3, r0
      bge           compareMax                @ if array[addr] < min
      mov           r0, r3
      b             continueMinMaxLoop

    compareMax:
      cmp           r3, r1
      ble           continueMinMaxLoop        @ if array[addr] > max
      mov           r1, r3

    continueMinMaxLoop:
      add           r2, r2, #1                @ i++
      b             getMinMaxLoop

  getMinMaxEndLoop:

  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       money
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Library to perform mathemetical operations on money values
@                     Performs integer arithmetic on money values
@                     Money value format: 64 bytes
@                       - First 8 bytes: whole part
@                       - Second 8 bytes: decimal part (2 decimal point precision)

@ Program name:       moneyAdd
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Add two money values
@                     Performs addition on two money values
@ Input:              r0: Address of first money value
@                     r1: Address of second money value
@                     r2: Address to store result

@ Program code
        .equ    temp1, -8
        .equ    temp2, -12
        .equ    temp3, -16
        .equ    temp4, -20
        .equ    temp5, -24
        .equ    locals, 20
        .text
        .align  2
        .global moneyAdd
        .syntax unified
        .type   moneyAdd, %function

moneyAdd:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]
  str             r6, [fp, temp3]
  str             r7, [fp, temp4]
  str             r8, [fp, temp5]

  ldr             r4, [r0, #0]
  ldr             r5, [r0, #-4]
  ldr             r6, [r1, #0]
  ldr             r7, [r1, #-4]
  mov             r8, r2

  add             r0, r4, r6            @ add whole parts
  add             r1, r5, r7            @ add decimal parts
  mov             r2, #100               
  subs            r3, r1, r2            @ subtract 100 from decimal sum
  bmi             moneyAddSetOutput     @ if decimal parts do not carry, skip add carry
  add             r0, r0, 1             @ add carry to whole parts
  mov             r1, r3                @ set decimal parts to remainder

    moneyAddSetOutput:
      str         r0, [r8, #0]          @ store result whole part
      str         r1, [r8, #-4]         @ store result decimal part

  ldr             r8, [fp, temp5]
  ldr             r7, [fp, temp4]
  ldr             r6, [fp, temp3]
  ldr             r5, [fp, temp2]
  ldr             r4, [fp, temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       moneySub
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Subtract two money values
@                     Performs subtraction on two money values
@ Input:              r0: Address of subtrahend money value
@                     r1: Address of mimuend money value
@                     r2: Address to store result

@ Program code
        .equ    temp1, -8
        .equ    temp2, -12
        .equ    temp3, -16
        .equ    temp4, -20
        .equ    temp5, -24
        .equ    locals, 20
        .text
        .align  2
        .global moneySub
        .syntax unified
        .type   moneySub, %function

moneySub:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]
  str             r6, [fp, temp3]
  str             r7, [fp, temp4]
  str             r8, [fp, temp5]

  ldr             r4, [r0, #0]
  ldr             r5, [r0, #-4]
  ldr             r6, [r1, #0]
  ldr             r7, [r1, #-4]
  mov             r8, r2

  mov             r2, #100            

  subs            r0, r4, r6              @ subtract whole parts
  bmi             moneySubWholeNeg

    moneySubWholePos:
      subs        r1, r5, r7              @ subtract decimal parts
      bmi         moneySubWholePosDecimalNeg

      moneySubWholePosDecimalPos:         @ same sign
        b         moneySubSetOutput

      moneySubWholePosDecimalNeg:         @ opposite sign
        sub       r0, r0, 1               @ borrow
        add       r1, r2, r1              @ get remainder from 100
        b         moneySubSetOutput

    moneySubWholeNeg:
      subs        r1, r5, r7              @ subtract decimal parts
      bmi         moneySubWholeNegDecimalNeg

      moneySubWholeNegDecimalPos:         @ opposite sign
        add       r0, r0, 1               @ borrow
        sub       r1, r2, r1              @ subtract from 100
        b         moneySubSetOutput

      moneySubWholeNegDecimalNeg:         @ same sign
        mvn       r1, r1                  @ convert decimal to positive integer, keep magnitude
        add       r1, r1, 1               @ complement + 1

        b         moneySubSetOutput

  moneySubSetOutput:
    str         r0, [r8, #0]          @ store result whole part
    str         r1, [r8, #-4]         @ store result decimal part

  ldr             r8, [fp, temp5]
  ldr             r7, [fp, temp4]
  ldr             r6, [fp, temp3]
  ldr             r5, [fp, temp2]
  ldr             r4, [fp, temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       moneyMul
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Multiply two money values
@                     Performs multiplication on two money values
@ Input:              r0: Address of multiplicand money value
@                     r1: Address of multiplier money value
@                     r2: Address to store result

@ Program code
        .equ    temp1, -8
        .equ    temp2, -12
        .equ    temp3, -16
        .equ    temp4, -20
        .equ    temp5, -24
        .equ    locals, 20
        .text
        .align  2
        .global moneyMul
        .global __aeabi_idiv
        .global __aeabi_idivmod
        .syntax unified
        .type   moneyMul, %function

moneyMul:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]
  str             r6, [fp, temp3]
  str             r7, [fp, temp4]
  str             r8, [fp, temp5]

  ldr             r4, [r0, #0]
  ldr             r5, [r0, #-4]
  ldr             r6, [r1, #0]
  ldr             r7, [r1, #-4]
  mov             r8, r2

  mul             r0, r4, r6              @ multiply whole parts

  mov             r1, #0                  @ decimal parts running sum
  mla             r1, r4, r7, r1          @ multiply whole part of multiplicand with decimal part of multiplier
  mla             r1, r6, r5, r1          @ multiply whole part of multiplier with decimal part of multiplicand

  mul             r2, r5, r7              @ multiply decimal parts (not scaled)

  mov             r4, r0                  @ reserve whole parts
  mov             r5, r1                  @ reserve decimal parts
  mov             r6, r2                  @ reserve decimal parts  (not scaled)

  # scale down non-scaled decimal parts
  mov             r0, r6
  mov             r1, #100
  bl              __aeabi_idiv
  add             r5, r5, r0              @ add to scaled decimal parts

  # get carry from decimal parts and decimal remainder
  mov             r0, r5
  mov             r1, #100
  bl              __aeabi_idivmod
  add             r4, r4, r0              @ add carry to whole parts
  mov             r5, r1                  @ decimal remainder

  # set output
  str         r4, [r8, #0]          @ store result whole part
  str         r5, [r8, #-4]         @ store result decimal part

  ldr             r8, [fp, temp5]
  ldr             r7, [fp, temp4]
  ldr             r6, [fp, temp3]
  ldr             r5, [fp, temp2]
  ldr             r4, [fp, temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       moneyDiv
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Divide two money values
@                     Performs division on two money values
@ Input:              r0: Address of dividend money value
@                     r1: Address of divisor money value
@                     r2: Address to store result

@ Program code
        .equ    temp1, -8
        .equ    temp2, -12
        .equ    temp3, -16
        .equ    temp4, -20
        .equ    temp5, -24
        .equ    locals, 20
        .text
        .align  2
        .global moneyDiv
        .global __aeabi_idiv
        .global __aeabi_idivmod
        .syntax unified
        .type   moneyDiv, %function

moneyDiv:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]
  str             r6, [fp, temp3]
  str             r7, [fp, temp4]
  str             r8, [fp, temp5]

  ldr             r4, [r0, #0]
  ldr             r5, [r0, #-4]
  ldr             r6, [r1, #0]
  ldr             r7, [r1, #-4]
  mov             r8, r2

  # scale up numbers
  mov             r2, #100
  mla             r0, r4, r2, r5      @ scale dividend by 100
  mul             r0, r0, r2          @ scale dividend again by 100
  mla             r1, r6, r2, r7      @ scale divisor by 100

  bl              __aeabi_idiv        @ r0/r1

  # scale down by 100
  mov             r1, #100
  bl              __aeabi_idivmod     @ r0/100

  # set output
  str             r0, [r8, #0]          @ store result whole part
  str             r1, [r8, #-4]         @ store result decimal part

  ldr             r8, [fp, temp5]
  ldr             r7, [fp, temp4]
  ldr             r6, [fp, temp3]
  ldr             r5, [fp, temp2]
  ldr             r4, [fp, temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

  .section  .note.GNU-stack,"",%progbits

@ Program name:       moneyPrint
@ Author:             Ken Hwang
@ Date:               12/16/2024
@ Purpose:            Print money value
@ Input:              r0: Address of money value

@ Constant program data
        .section  .rodata
        .align  2
printFormat:
  .asciz "$%d.%02d\n"

@ Program code
        .text
        .align  2
        .global moneyPrint
        .syntax unified
        .type   moneyPrint, %function

moneyPrint:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4

  ldr             r1, [r0, #0]
  ldr             r2, [r0, #-4]
  ldr             r0, =printFormat
  bl printf

  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ @ Program name:       tensComplement
@ @ Author:             Ken Hwang
@ @ Date:               12/16/2024
@ @ Purpose:            Get ten's complement of decimal value
@ @ Input:              r0: Decimal value
@ @ Output:             r0: Ten's complement of decimal value
@ 
@ @ Program code
@         .text
@         .align  2
@         .global __aeabi_idiv
@         .syntax unified
@         .type   tensComplement, %function
@ 
@ tensComplement:
@   sub             sp, sp, #8
@   str             fp, [sp, #0]
@   str             lr, [sp, #4]
@   add             fp, sp, #4
@ 
@   mov             r3, r0            @ N
@   mov             r1, #10           @ r
@   mov             r2, #0            @ n
@ 
@   decimalLoop:
@     cmp           r0, r1            @ r0 < 10
@     blt           exitDecimalLoop   @ exit if remainder is less than 10
@     # r0/10
@     bl            __aeabi_idiv      @ divide by 10
@     add           r2, r2, 1         @ increment n
@ 
@     b             decimalLoop
@ 
@   exitDecimalLoop:
@     add           r2, r2, 1         @ increment n one more time
@     mov           r0, r1            @ temp variable
@ 
@     nLoop:
@       cmp         r2, #0            @ exit once reached 0
@       beq         tensComplementSetOutput
@       mul         r1, r1, r0        @ r^n 
@       sub         r2, r2, 1         @ decrement
@ 
@       b nLoop
@   
@   tensComplementSetOutput:
@     sub r0, r1, r3                  @ r^n - N
@ 
@   ldr             fp, [sp, #0]
@   ldr             lr, [sp, #4]
@   add             sp, sp, #8
@   bx              lr 
@ 
@   .section  .note.GNU-stack,"",%progbits
 
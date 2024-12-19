@ Program name:       checkPrime
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Determine if prime number
@ Input:              r0 - number
@ Output:             r0 - 1 is prime, 0 is not prime

@ Program code
        .equ    temp1, -8
        .equ    temp2, -12
        .equ    temp3, -16
        .equ    temp4, -20
        .equ    temp5, -24
        .equ    locals, 20
        .text
        .align  2
        .global checkPrime
        .global __aeabi_idivmod
        .syntax unified
        .type   checkPrime, %function

checkPrime:
  sub             sp, sp, #8
  str             fp, [sp, #0]
  str             lr, [sp, #4]
  add             fp, sp, #4
  sub             sp, sp, #locals
  str             r4, [fp, temp1]
  str             r5, [fp, temp2]
  str             r6, [fp, temp3]
  str             r7, [fp, temp4]

  mov         r4, r0                                  @ n
  mov         r5, #0                                  @ return value

  # initialize loop
  mov         r6, #2                                  @ i
  lsr         r7, r4, #1                              @ n/2

  # loop check 2 -> n/2
  checkPrimeLoop:
    cmp       r6, r7              
    bgt       primeFound                              @ i > n/2

    mov       r0, r4
    mov       r1, r6
    bl        __aeabi_idivmod                         @ n % i

    cmp       r1, #0
    beq       exitCheckPrime                          @ n % i == 0 (i.e. divisible)

    add       r6, r6, #1                              @ i++
    b         checkPrimeLoop

  primeFound:
    mov       r5, #1

  exitCheckPrime:
    mov       r0, r5
  
    ldr             r7, [fp, temp4]
    ldr             r6, [fp, temp3]
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

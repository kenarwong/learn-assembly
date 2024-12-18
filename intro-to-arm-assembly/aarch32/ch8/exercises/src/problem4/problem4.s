@ Program name:       problem4.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Determine prime numbers, guard against numbers

@ Constant program data
        .section  .rodata
        .align    2
prompt:
  .asciz "Enter number: "
input:
  .asciz "%d"
output:
  .asciz "%d"
displayPrimeStart:
  .asciz "Number "
displayIsPrime:
  .asciz " is a prime\n"
displayIsNotPrime:
  .asciz " is not prime\n"
error:
  .asciz "You entered invalid input.\n"

@ Program code
        .equ    value, -8
        .equ    locals, 4
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals

  # initial prompt   
  ldr               r0, =prompt
  bl                printf
  ldr               r0, =input
  add               r1, fp, value
  bl                scanf
  ldr               r0, [fp, value]                         @ user value

  # validate input
  mov               r1, #-1
  cmp               r0, r1
  beq               exit                                    @ allow -1, but negative numbers can't be prime, so just exit

  mov               r1, #2
  cmp               r0, r1
  ble               invalidInput                            @ le 2, failed validation

  # display result
  ldr               r0, =displayPrimeStart
  bl                printf

  ldr               r0, =output
  ldr               r1, [fp, value]                         @ user value
  bl                printf

  ldr               r0, [fp, value]                         @ user value
  bl                checkPrime
  mov               r1, #0                                  
  cmp               r0, r1                                  
  beq               notPrime                                @ 1 = prime, 0 = not prime

  prime:
    ldr             r0, =displayIsPrime
    bl              printf
    b               exit

  notPrime:
    ldr             r0, =displayIsNotPrime
    bl              printf
    b               exit

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf

  exit:
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    mov             r0, #0
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

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

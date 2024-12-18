@ Program name:       problem5.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Random number guessing game

@ Constant program data
        .section  .rodata
        .align    2
prompt:
  .asciz "Enter a maximum value for a random number (greater than 1): "
input:
  .asciz "%d"
displayGuess:
  .asciz "Guess a number: "
displayCorrect:
  .asciz "You guessed the number!\n"
displayTooLow:
  .asciz "You guessed too low.\n"
displayTooHigh:
  .asciz "You guessed too high.\n"
displayGuessCount:
  .asciz "Number of guesses: %d\n"
error:
  .asciz "You entered invalid input.\n"

@ Program code
        .equ    value, -8
        .equ    guess, -12
        .equ    temp1, -16
        .equ    temp2, -20
        .equ    temp3, -24
        .equ    temp4, -28
        .equ    locals, 24
        .text
        .align  2
        .global main
        .global __aeabi_idivmod
        .syntax unified
        .type   main, %function

main:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, temp1]
  str               r5, [fp, temp2]
  str               r6, [fp, temp3]
  str               r7, [fp, temp4]

  # initial prompt   
  ldr               r0, =prompt
  bl                printf
  ldr               r0, =input
  add               r1, fp, value
  bl                scanf
  ldr               r0, [fp, value]                         @ user value

  # validate input
  mov               r1, #1
  cmp               r0, r1
  ble               invalidInput                            @ le 1, failed validation

  # generate random number
  bl                srand                                  
  mov               r0, #0                                 
  bl                rand                                  
  ldr               r1, [fp, value]                        @ maximum value
  bl                __aeabi_idivmod                        
  add               r4, r1, #1                             

  # start guessing loop
  mov               r5, #0                                  @ guess count
  mov               r6, #0                                  @ last guess

  guessLoop:

    # prompt guess
    ldr             r0, =displayGuess
    bl              printf
    ldr             r0, =input
    add             r1, fp, value
    bl              scanf
    ldr             r6, [fp, value]                         @ user guess
    
    add             r5, r5, #1                              @ count++

    # feedback
    cmp             r6, r4                                  
    beq             correct                                 @ correct guess
    blt             tooLow                                  

    tooHigh:
      ldr           r0, =displayTooHigh
      bl            printf
      b             guessLoop

    tooLow:
      ldr           r0, =displayTooLow
      bl            printf
      b             guessLoop

  # correct guess
  correct:
    ldr           r0, =displayCorrect
    bl            printf

    ldr           r0, =displayGuessCount
    mov           r1, r5
    bl            printf

    b             exit

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf

  exit:
    ldr             r7, [fp, temp4]
    ldr             r6, [fp, temp3]
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    mov             r0, #0
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

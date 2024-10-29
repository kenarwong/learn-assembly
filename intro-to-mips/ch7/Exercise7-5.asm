# File:     Exercise7-5.asm
# Author:   Ken Hwang
# Purpose:  Random number guessing game

.text
.globl main

main:
  # Prompt user for input
  li $v0, 4
  la $a0, prompt
  syscall

  li $v0, 5
  syscall
  move $s0, $v0                         # $s0 is max value

  # generate random number
  li $v0, 42
  li $a0, 0
  move $a1, $s0
  syscall
  move $s1, $a0                         # $s1 is random number

  # start guessing loop
  li $t0, 0                    # track guess count
  li $t1, 0                    # last guess  

  guessLoop:
    # Prompt user for guess
    li $v0, 4
    la $a0, displayGuess
    syscall

    li $v0, 5
    syscall
    move $t1, $v0                       

    addi $t0, $t0, 1                  # guess count++

    beq $t1, $s1, correct               # exit loop on correct guess
    blt $t1, $s1, tooLow

    tooHigh:
      li $v0, 4
      la $a0, displayTooHigh
      syscall

      j continueLoop

    tooLow:
      li $v0, 4
      la $a0, displayTooLow
      syscall

      j continueLoop

    continueLoop:
      j guessLoop

correct:
  li $v0, 4
  la $a0, displayCorrect
  syscall

  li $v0, 4
  la $a0, displayGuessCount
  syscall

  li $v0, 1
  move $a0, $t0                       
  syscall

exit:
  # exit
  li $v0, 10
  syscall

.data
  prompt:                      .asciiz "Enter a maximum value for a random number: "
  displayGuess:                .asciiz "Guess the number: "
  displayCorrect:              .asciiz "You guess the number!\n"
  displayTooLow:               .asciiz "You guessed too low.\n"
  displayTooHigh:              .asciiz "You guessed too high.\n"
  displayGuessCount:           .asciiz "Number of guesses: "
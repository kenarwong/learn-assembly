# File:     Exercise7-5.asm
# Author:   Ken Hwang
# Purpose:  Random number guessing game

.text
.globl main

main:
  # Prompt user for input
  addi $v0, $zero, 4
  la $a0, prompt
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0                         # $s0 is max value

  # generate random number
  addi $v0, $zero, 42
  li $a0, 0
  move $a1, $s0
  syscall
  move $s1, $a0                         # $s1 is random number

  # start guessing loop
  addi $t0, $zero, 0                    # track guess count
  addi $t1, $zero, 0                    # last guess  

  guessLoop:
    # Prompt user for guess
    addi $v0, $zero, 4
    la $a0, displayGuess
    syscall

    addi $v0, $zero, 5
    syscall
    move $t1, $v0                       

    beq $t1, $s1, correct               # exit loop on correct guess
    blt $t1, $s1, tooLow

    tooHigh:
      addi $v0, $zero, 4
      la $a0, displayTooHigh
      syscall

      j continueLoop

    tooLow:
      addi $v0, $zero, 4
      la $a0, displayTooLow
      syscall

      j continueLoop

    continueLoop:
      addi $t0, $t0, 1                  # guess count++
      j guessLoop

correct:
  addi $v0, $zero, 4
  la $a0, displayCorrect
  syscall

  addi $v0, $zero, 4
  la $a0, displayGuessCount
  syscall

  addi $v0, $zero, 1
  move $a0, $t0                       
  syscall

exit:
  # exit
  addi $v0, $zero, 10
  syscall

.data
  prompt:                      .asciiz "Enter a maximum value for a random number: "
  displayGuess:                .asciiz "Guess the number: "
  displayCorrect:              .asciiz "You guess the number!\n"
  displayTooLow:               .asciiz "You guessed too low.\n"
  displayTooHigh:              .asciiz "You guessed too high.\n"
  displayGuessCount:           .asciiz "Number of guesses: "
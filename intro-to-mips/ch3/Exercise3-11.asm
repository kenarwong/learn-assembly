# File:     Exercise3-11.asm
# Author:   Ken Hwang
# Purpose:  Implement rem operator

.text
.globl main

main:
  # Prompt user for input1
  addi $v0, $zero, 4
  la $a0, prompt1
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0

  # Prompt user for input2
  addi $v0, $zero, 4
  la $a0, prompt2
  syscall

  addi $v0, $zero, 5
  syscall
  move $s1, $v0

  # rem operator
  div $s0, $s1
  mfhi $s2

  # Display the result
  addi $v0, $zero, 4
  la $a0, result
  syscall

  addi $v0, $zero, 1
  move $a0, $s2
  syscall

  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt1:            .asciiz "Enter first value: "
  prompt2:            .asciiz "\nEnter second value: "
  result:             .asciiz "\nThe remainder is: "
# File:     Exercise3-3.asm
# Author:   Ken Hwang
# Purpose:  Implement NOT with XOR (2's complement)

.text
.globl main

main:

  # Prompt user for input
  addi $v0, $zero, 4
  la $a0, prompt
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0

  addi $v0, $zero, 4
  la $a0, display
  syscall

  addi $v0, $zero, 35
  move $a0, $s0
  syscall

  # Perform bitwise NOT operation with XOR, then add 1
  xori $s1, $s0, -1
  addi $s1, $s1, 1

  # Display the result
  addi $v0, $zero, 4
  la $a0, result1
  syscall

  addi $v0, $zero, 35
  move $a0, $s1
  syscall

  addi $v0, $zero, 4
  la $a0, result2
  syscall

  addi $v0, $zero, 1
  move $a0, $s1
  syscall

  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt:   .asciiz "Enter a value: "
  display:   .asciiz "\nYour value in binary is: "
  result1:  .asciiz "\nThe 2's complement in binary is: "
  result2:  .asciiz "\nThe 2's complement in decimal is: "
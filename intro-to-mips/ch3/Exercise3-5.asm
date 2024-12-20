# File:     Exercise3-5.asm
# Author:   Ken Hwang
# Purpose:  Multiply by 10 with shift and add

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

  # Multiply by 10
  # A * 10 = A*(8 + 2) = A*8 + A*2
  sll $t0, $s0, 3
  sll $t1, $s0, 1
  add $s1, $t0, $t1

  # Display the result
  addi $v0, $zero, 4
  la $a0, result
  syscall

  addi $v0, $zero, 1
  move $a0, $s1
  syscall

  # Multiply by 10
  addi $t0, $zero, 10
  add $t1, $zero, $s0
  mult $t1, $t0
  mflo $s2

  bne $s1, $s2, Exit
  # Display validation check 
  addi $v0, $zero, 4
  la $a0, valid
  syscall

Exit:
  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt:   .asciiz "Enter a value: "
  result:   .asciiz "\nThe result of your value times 10 (using shift and add) is: "
  valid:   .asciiz "\nThis value is equal to the result of the mult operation"
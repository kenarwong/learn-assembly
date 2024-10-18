# File:     Exercise3-7.asm
# Author:   Ken Hwang
# Purpose:  Divide by 8 with shift 

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

  # Divide by 8 using shift (quotient only)
  sra $s1, $s0, 3

  # Display the result
  addi $v0, $zero, 4
  la $a0, result
  syscall

  addi $v0, $zero, 1
  move $a0, $s1
  syscall

  # Divide by 8 using div (quotient only)
  addi $t0, $zero, 8
  div $s0, $t0
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
  result:   .asciiz "\nThe quotient of your value divided by 8 (using shift) is: "
  valid:   .asciiz "\nThis value is equal to the quotient of the div operation"
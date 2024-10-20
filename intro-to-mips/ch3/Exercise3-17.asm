# File:     Exercise3-13.asm
# Author:   Ken Hwang
# Purpose:  Evaluate expressions
.text
.globl main

main:
  # Prompt user for n
  addi $v0, $zero, 4
  la $a0, prompt1
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0

  # Prompt user for T
  addi $v0, $zero, 4
  la $a0, prompt2
  syscall

  addi $v0, $zero, 5
  syscall
  move $s1, $v0

  # Prompt user for P
  addi $v0, $zero, 4
  la $a0, prompt3
  syscall

  addi $v0, $zero, 5
  syscall
  move $s2, $v0

  # R = 8314/1000
  ori $t0, $zero, 8314
  ori $t1, $zero, 1000

  # V = nRT / P
  or $s3, $zero, $t0
  mulo $s3, $s3, $s0
  mulo $s3, $s3, $s1
  div $s3, $s2
  mflo $s3
  div $s3, $t1
  mflo $s3

  # Display result
  ori $v0, $zero, 4
  la $a0, result
  syscall

  ori $v0, $zero, 1              
  add $a0, $zero, $s3
  syscall

Exit:
  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt1:            .asciiz "Enter value for n: "
  prompt2:            .asciiz "\nEnter value for T: "
  prompt3:            .asciiz "\nEnter value for P: "
  result:             .asciiz "\nThe result is: "
# File:     Exercise3-9.asm
# Author:   Ken Hwang
# Purpose:  Overflow check with positive numbers

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

  # Multiply both numbers
  mult $s0, $s1
  mflo $s2
  mfhi $s3

  # Display the result
  addi $v0, $zero, 4
  la $a0, result
  syscall

  addi $v0, $zero, 1
  move $a0, $s2
  syscall

  # Check overflow
  bne $s3, $zero, overflow    # If hi not 0, then overflow

nooverflow:
  # Display no overflow result
  addi $v0, $zero, 4
  la $a0, resultNoOverflow
  syscall

  j continue

overflow:
  # Display overflow result
  addi $v0, $zero, 4
  la $a0, resultOverflow
  syscall

continue:

  # mulo performs same multiplication steps, but breaks on overflow
  #mulo $t0, $s0, $s1

  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt1:            .asciiz "Enter first value: "
  prompt2:            .asciiz "\nEnter second value: "
  result:             .asciiz "\nThe result is: "
  resultOverflow:     .asciiz "\nThe result has overflow"
  resultNoOverflow:   .asciiz "\nThe result does not have overflow"
# File:     Exercise3-15.asm
# Author:   Ken Hwang
# Purpose:  XOR to swap

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

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  addi $v0, $zero, 4
  la $a0, displayValueBinary
  syscall

  addi $v0, $zero, 35
  move $a0, $s0
  syscall

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  # Prompt user for input2
  addi $v0, $zero, 4
  la $a0, prompt2
  syscall

  addi $v0, $zero, 5
  syscall
  move $s1, $v0

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  addi $v0, $zero, 4
  la $a0, displayValueBinary
  syscall

  addi $v0, $zero, 35
  move $a0, $s1
  syscall

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  # Swap 
  xor $t0, $s1, $s0         # parity bit
  xor $s0, $s0, $t0         # swap s0
  xor $s1, $s1, $t0         # swap s1

  # Display the result
  addi $v0, $zero, 4
  la $a0, result1
  syscall

  addi $v0, $zero, 1
  move $a0, $s0
  syscall

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  addi $v0, $zero, 4
  la $a0, displayResultBinary
  syscall

  addi $v0, $zero, 35
  move $a0, $s0
  syscall

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  addi $v0, $zero, 4
  la $a0, result2
  syscall

  addi $v0, $zero, 1
  move $a0, $s1
  syscall

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  addi $v0, $zero, 4
  la $a0, displayResultBinary
  syscall

  addi $v0, $zero, 35
  move $a0, $s1
  syscall

  addi $v0, $zero, 4
  la $a0, newline
  syscall

  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt1:              .asciiz "Enter first value: "
  prompt2:              .asciiz "Enter second value: "
  displayValueBinary:   .asciiz "Your value in binary is "
  result1:              .asciiz "Your first value is now: "
  result2:              .asciiz "Your second value is now: "
  displayResultBinary:  .asciiz "This result binary is "
  newline:              .asciiz "\n"
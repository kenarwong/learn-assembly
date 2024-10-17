# File:     Exercise3-2.asm
# Author:   Ken Hwang
# Purpose:  Implement NOT with XOR

.text
.globl main

main:

  addi $v0, $zero, 4
  la $a0, display
  syscall

  addi $v0, $zero, 5
  la $a0, prompt
  syscall

  xori $s0, $v0, -1

  addi $v0, $zero, 1
  move $a0, $s0
  syscall

  addi $v0, $zero, 10
  syscall

.data
  prompt:   .asciiz "Enter a value: "
  display:  .asciiz "The NOT is: "

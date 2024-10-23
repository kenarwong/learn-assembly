# File:     Exercise5-2.asm
# Author:   Ken Hwang
# Purpose:  Program to call utils.asm

.text
.globl main

main:
  la $a0, result
  li $a1, 0
  li $a2, 10 
  jal PrintInt

  # call the Exit subprogram to exit
  li $v0, 10
  syscall

.data
  result: .asciiz "A dummy value of zero: "
.include "utils.asm"
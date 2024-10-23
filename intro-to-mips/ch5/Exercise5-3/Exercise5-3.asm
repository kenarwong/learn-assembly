# File:     Exercise5-3.asm
# Author:   Ken Hwang
# Purpose:  Program to call utils.asm

.text
.globl main

main:
  jal PrintTab

  # call the Exit subprogram to exit
  li $v0, 10
  syscall

.include "utils.asm"
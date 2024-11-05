# File:     Exercise8-2.asm
# Author:   Ken Hwang
# Purpose:  Call fixed PrintInt subprogram

.text
.globl main

main:
  la $a0, stringToPrint
  li $a1, 1
  jal PrintInt

  li $v0, 4
  la $a0, lineAfterNewline
  syscall

  li $v0, 10
  syscall

.data
  stringToPrint:    .asciiz "Int to print: "
  lineAfterNewline: .asciiz "Line after newline"
.include "utils.asm"
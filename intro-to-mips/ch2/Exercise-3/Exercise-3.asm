# Program File: Exercise-3.asm
# Author: Ken Hwang
# Generate random number 

.text
.globl main

main:
  add $a0, $zero, $zero
  lbu $a1, upper
  li $v0, 41              # code for random int
  syscall

  move $a0, $v0           # move value to $a0
  li $v0, 1               # code for print integer
  syscall

  li $v0, 10              # code for exit
  syscall

.data
  upper: .byte 100
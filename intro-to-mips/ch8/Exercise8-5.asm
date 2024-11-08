# File:     Exercise8-5.asm
# Author:   Ken Hwang
# Purpose:  Recursive square

.text
.globl main

main:
  # Prompt user for input
  li $v0, 4
  la $a0, prompt
  syscall

  li $v0, 5
  syscall
  move $t0, $v0

  li $v0, 4
  la $a0, newline
  syscall

  move $a0, $t0
  li $a1, 0
  move $a2, $t0
  jal RecursiveSquare
  move $t0, $v0

  # report square
  li $v0, 4
  la $a0, square
  syscall

  li $v0, 1
  move $a0, $t0
  syscall
  
  j exit

.text
RecursiveSquare:
  # $a0: number
  # $a1: sum
  # $a2: count

  addi $sp, $sp, -0x04
  sw $ra, 0x00($sp)

  # base case
  beq $a2, 0, exitRecursion         # exit on 0

  add $a1, $a1, $a0                 # sum
  addi $a2, $a2, -1                 # decrement count

  jal RecursiveSquare

  exitRecursion:
  move $v0, $a1                     # return sum

  lw $ra, 0x00($sp)
  addi $sp, $sp, 0x04

  jr $ra

exit:
  li $v0, 10
  syscall

.data
  prompt:     .asciiz "Enter a number: "
  square:     .asciiz "The square is: "
  newline:    .asciiz "\n"
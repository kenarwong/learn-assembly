# File:     Exercise8-6.asm
# Author:   Ken Hwang
# Purpose:  Recursive algebraic series

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
  jal RecurseAlgebraicSeries
  move $t0, $v0

  # report sum
  li $v0, 4
  la $a0, sum
  syscall

  li $v0, 1
  move $a0, $t0
  syscall
  
  j exit

.text
RecurseAlgebraicSeries:
  # $a0: number
  # $a1: sum

  addi $sp, $sp, -0x04
  sw $ra, 0x00($sp)

  # base case
  beq $a0, 0, exitRecursion         # exit on 0

  add $a1, $a1, $a0                 # sum
  addi $a0, $a0, -1                 # decrement count

  jal RecurseAlgebraicSeries

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
  sum:        .asciiz "The sum of the algebraic series is: "
  newline:    .asciiz "\n"
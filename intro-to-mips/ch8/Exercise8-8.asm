# File:     Exercise8-8.asm
# Author:   Ken Hwang
# Purpose:  Recursive factorial

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
  li $a1, 1
  jal RecursiveFactorial
  move $t0, $v0

  # report factorial
  li $v0, 4
  la $a0, factorial
  syscall

  li $v0, 1
  move $a0, $t0
  syscall
  
  j exit

.text
RecursiveFactorial:
  # $a0: number
  # $a1: product

  addi $sp, $sp, -0x04
  sw $ra, 0x00($sp)

  # base case
  beq $a0, 1, exitRecursion         # exit on 1

  mul $a1, $a1, $a0                 # multiply
  addi $a0, $a0, -1                 # decrement count

  jal RecursiveFactorial

  exitRecursion:
  move $v0, $a1                     # return product

  lw $ra, 0x00($sp)
  addi $sp, $sp, 0x04

  jr $ra

exit:
  li $v0, 10
  syscall

.data
  prompt:     .asciiz "Enter a number: "
  factorial:  .asciiz "The factorial is: "
  newline:    .asciiz "\n"
# File:     Exercise8-7.asm
# Author:   Ken Hwang
# Purpose:  Recursive Fibonnaci

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
  jal RecursiveFibonacci
  move $t0, $v0

  # report fibonacci
  li $v0, 4
  la $a0, fibonacci
  syscall

  li $v0, 1
  move $a0, $t0
  syscall
  
  j exit

.text
RecursiveFibonacci:
  # $a0: number
  # $a1: sum
  # $a2: original number

  addi $sp, $sp, -0x0c
  sw $a0, 0x04($sp)
  sw $ra, 0x00($sp)

  # base case
  beq $a0, 1, addOne                # add 1
  beq $a0, 2, addOne                # add 1

  addi $a0, $a0, -1                 # f(n-1)
  jal RecursiveFibonacci

  lw $a0, 0x04($sp)
  addi $a0, $a0, -2                 # f(n-2)
  jal RecursiveFibonacci

  j exitRecursiveCall

  addOne:
    addi $a1, $a1, 1                # add to sum
  
  exitRecursiveCall:
    lw $a0, 0x04($sp)
    lw $ra, 0x00($sp)
    addi $sp, $sp, 0x0c

    bne $a0, $a2, exitRecursion       # if not top of recursion, exit
    move $v0, $a1                     # else, set output as sum

  exitRecursion:
    jr $ra

exit:
  li $v0, 10
  syscall

.data
  prompt:     .asciiz "Enter a number: "
  fibonacci:  .asciiz "The fibonacci number is: "
  newline:    .asciiz "\n"
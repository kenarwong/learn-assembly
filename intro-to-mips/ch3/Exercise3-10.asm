# File:     Exercise3-10.asm
# Author:   Ken Hwang
# Purpose:  Examine mulo operation

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

  # Prompt user for input2
  addi $v0, $zero, 4
  la $a0, prompt2
  syscall

  addi $v0, $zero, 5
  syscall
  move $s1, $v0

  mulo $t0, $s0, $s1          # real instructions
                              # mult $s0, $s1         
                              # mfhi $at            # overflow
                              # mflo $t0            # lower order bits
                              # sra $t0, $t0, 0x1f  # sign-extend t0 to 0
                              # beq $1, $8, 0x01    # check if overflow is 0 or -0
                              # break               # break if not

  # Display the result
  addi $v0, $zero, 4
  la $a0, result
  syscall

  addi $v0, $zero, 1
  move $a0, $s2
  syscall

  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt1:            .asciiz "Enter first value: "
  prompt2:            .asciiz "\nEnter second value: "
  result:             .asciiz "\nThe result is: "
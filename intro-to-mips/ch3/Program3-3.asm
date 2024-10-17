# File: Program3-3.asm
# Author: Charles W. Kann
# Purpose: To have a user enter a number,and print 0 if
# the number is even, 1 if the number is odd

.text
.globl main

main:
  # Get input value
  addi $v0, $zero, 4
  la $a0, prompt      # Write Prompt
  syscall
  addi $v0, $zero, 5  # Retrieve input
  syscall
  move $s0, $v0
  
  # Check if odd or even
  addi $t0, $zero, 2  # Store 2 in $t0
  div $t0, $s0, $t0   # Divide input by 2
  mfhi $s1            # Save remainder in $s1

  # Print output
  addi $v0, $zero, 4
  la $a0, result
  syscall

  addi $v0, $zero, 1
  move $a0, $s1
  syscall

  # Print result string
  # Print result
  # Exit program
  addi $v0, $zero, 10
  syscall
.data
  prompt: .asciiz "Enter your number: "
  result: .asciiz "A result of 0 is even, 1 is odd: result = "
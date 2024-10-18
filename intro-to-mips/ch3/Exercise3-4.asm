# File: Exercise3-4.asm
# Author: Ken Hwang
# Purpose: Demonstrate universality of NAND and NOR

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

  addi $v0, $zero, 4
  la $a0, display
  syscall

  addi $v0, $zero, 35
  move $a0, $s0
  syscall

  # Prompt user for input2
  addi $v0, $zero, 4
  la $a0, prompt2
  syscall

  addi $v0, $zero, 5
  syscall
  move $s1, $v0

  addi $v0, $zero, 4
  la $a0, display
  syscall

  addi $v0, $zero, 35
  move $a0, $s1
  syscall

  # Perform bitwise NAND 
  # A NAND B = (A AND B)'
  and $s2, $s0, $s1
  xori $s2, $s2, -1

  # Display result
  la $a0, resultNANDbinary
  la $a1, resultNANDdecimal
  jal displayResult

  # Perform bitwise AND with NOR 
  # A AND B = [(A OR A)' OR (B OR B)']'
  nor $t0, $s0, $s0
  nor $t1, $s1, $s1
  nor $s2, $t1, $t0

  # Display result
  la $a0, resultANDbinary
  la $a1, resultANDdecimal
  jal displayResult

  # Perform bitwise OR with NOR 
  # A OR B = [(A OR B)' OR (A OR B)']'
  nor $t0, $s0, $s1
  nor $t1, $s0, $s1
  nor $s2, $t1, $t0

  # Display result
  la $a0, resultORbinary
  la $a1, resultORdecimal
  jal displayResult

  # Perform bitwise NOT with NOR 
  # !A = A NOR 0 = A NOR A
  nor $s2, $s0, $zero

  # Display result
  la $a0, result1NOTbinary
  la $a1, result1NOTdecimal
  jal displayResult

  nor $s2, $s1, $zero

  # Display result
  la $a0, result2NOTbinary
  la $a1, result2NOTdecimal
  jal displayResult

  # Exit
  addi $v0, $zero, 10
  syscall

displayResult:

  # Display the result
  addi $v0, $zero, 4
  #move $a0, $a0
  syscall

  addi $v0, $zero, 35
  move $a0, $s2
  syscall

  addi $v0, $zero, 4
  move $a0, $a1
  syscall

  addi $v0, $zero, 1
  move $a0, $s2
  syscall

  jr $ra

.data
  prompt1:   .asciiz "Enter first value: "
  display:   .asciiz "\nYour value in binary is: "
  prompt2:   .asciiz "\nEnter second value: "

  resultNANDbinary:  .asciiz "\nThe NAND of two values in binary is: "
  resultNANDdecimal:  .asciiz "\nThe NAND in decimal is: "

  resultANDbinary:  .asciiz "\nThe AND (using NOR) of the two values in binary is: "
  resultANDdecimal:  .asciiz "\nThe AND in decimal is: "

  resultORbinary:  .asciiz "\nThe OR (using NOR) of the two values in binary is: "
  resultORdecimal:  .asciiz "\nThe OR in decimal is: "

  result1NOTbinary:  .asciiz "\nThe NOT (using NOR) of the first value in binary is: "
  result1NOTdecimal:  .asciiz "\nThe NOT in decimal is: "

  result2NOTbinary:  .asciiz "\nThe NOT (using NOR) of the second value in binary is: "
  result2NOTdecimal:  .asciiz "\nThe NOT in decimal is: "

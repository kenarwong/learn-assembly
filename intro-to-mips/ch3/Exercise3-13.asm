# File:     Exercise3-13.asm
# Author:   Ken Hwang
# Purpose:  Evaluate expressions
.text
.globl main

main:
  # Prompt user for x
  addi $v0, $zero, 4
  la $a0, prompt1
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0

  # Prompt user for y
  addi $v0, $zero, 4
  la $a0, prompt2
  syscall

  addi $v0, $zero, 5
  syscall
  move $s1, $v0

  # Prompt user for z
  addi $v0, $zero, 4
  la $a0, prompt3
  syscall

  addi $v0, $zero, 5
  syscall
  move $s2, $v0

  # 5x + 3y + z
  ori $t0, $zero, 5
  mulo $s3, $t0, $s0      # s3 = 5x
  ori $t0, $zero, 3
  mulo $t0, $t0, $s1      # t1 = 3y
  add $t0, $t0, $s2       # t1 = 3y + z
  add $s3, $s3, $t0       # s3 = 5x + 3y + z

  # Display result
  ori $v0, $zero, 4
  la $a0, exp1
  syscall

  ori $v0, $zero, 4
  la $a0, result
  syscall

  ori $v0, $zero, 1              
  add $a0, $zero, $s3
  syscall

  # ((5x + 3y + z) / 2) * 3
  ori $t0, $zero, 3
  mulo $s3, $s3, $t0          # s3 = s3 * 3
  ori $t0, $zero, 2
  div $s3, $t0                # s3 = s3 / 2
  mflo $s3

  # Display result
  ori $v0, $zero, 4
  la $a0, exp2
  syscall

  ori $v0, $zero, 4
  la $a0, result
  syscall

  ori $v0, $zero, 1              
  add $a0, $zero, $s3
  syscall

  # x^3 + 2x^2 + 3x + 4
  mulo $t0, $s0, $s0                # x*x
  mulo $s3, $t0, $s0                # x*x*x
  sll $t1, $t0, 1                   # 2*x*x*
  ori $t0, $zero, 3              
  mulo $t2, $s0, $t0                # 3x 
  addi $t2, $t2, 4                  # 3x + 4
  add $t1, $t1, $t2                 # 2x^2 + 3x + 4
  add $s3, $s3, $t1                 # x^3 + 2x^2 + 3x + 4 

  # Display result
  ori $v0, $zero, 4
  la $a0, exp3
  syscall

  ori $v0, $zero, 4
  la $a0, result
  syscall

  ori $v0, $zero, 1              
  add $a0, $zero, $s3
  syscall

  # (4x / 3) * y
  ori $t0, $zero, 4
  mulo $s3, $s0, $t0                # 4x
  mulo $s3, $s3, $s1                # 4x * y
  ori $t0, $zero, 3
  div $s3, $t0                      # 4x * y / 3
  mflo $s3

  # Display result
  ori $v0, $zero, 4
  la $a0, exp4
  syscall

  ori $v0, $zero, 4
  la $a0, result
  syscall

  ori $v0, $zero, 1              
  add $a0, $zero, $s3
  syscall

Exit:
  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt1:            .asciiz "Enter value for x: "
  prompt2:            .asciiz "\nEnter value for y: "
  prompt3:            .asciiz "\nEnter value for z: "
  result:             .asciiz "\nThe result is: "
  exp1:               .asciiz "\na) 5x + 3y + z"
  exp2:               .asciiz "\nb) ((5x + 3y + z) / 2) * 3"
  exp3:               .asciiz "\nc) x^3 + 2x^2 + 3x + 4"
  exp4:               .asciiz "\nd) (4x / 3) * y"
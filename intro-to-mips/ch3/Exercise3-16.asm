# File:     Exercise3-16.asm
# Author:   Ken Hwang
# Purpose:  Check even or odd with shift

.text
.globl main

main:
  # Prompt user for input
  addi $v0, $zero, 4
  la $a0, prompt
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0

  # shift off until LSB and shift back
  sll $s0, $s0, 0x1f
  srl $s0, $s0, 0x1f

  beq $s0, $zero, even

odd:
  # Display the result
  addi $v0, $zero, 4
  la $a0, isodd
  syscall

  j exit

even:
  # Display the result
  addi $v0, $zero, 4
  la $a0, iseven
  syscall

exit:
  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt:             .asciiz "Enter a value: "
  iseven:               .asciiz "Your value is even"
  isodd:                .asciiz "Your value is odd"
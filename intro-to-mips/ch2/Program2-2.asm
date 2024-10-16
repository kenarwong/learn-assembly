# Program File: Program2-2.asm
# Author: Ken Hwang
# Read an integer number from user, print back to console

.text
main:
  la $a0, msg
  li $v0, 4             # code for print string
  syscall

  li $v0, 5             # code for read integer
  syscall

  move $s0, $v0         # move value to $s0

  la $a0, output
  li $v0, 4             # code for print string
  syscall

  move $a0, $s0         # move value to $a0
  li $v0, 1             # code for print integer
  syscall

  li $v0, 10            # code for exit
  syscall

.data
  msg:    .asciiz "Type an integer: "
  output: .asciiz "\nYou typed: "


# Program File: Program2-3.asm
# Author: Ken Hwang
# Read an string from user, print back to console

.text
main:
  la $a0, msg
  li $v0, 4             # code for print string
  syscall

  la $a0, input         # address of input buffer in data
  lw $a1, length        # number of characters
  li $v0, 8             # code for read string
  syscall

  la $a0, output
  li $v0, 4             # code for print string
  syscall

  la $a0, input         # address of input buffer to print
  li $v0, 4             # code for print string
  syscall

  li $v0, 10            # code for exit
  syscall

.data
  input:  .space    81                   # reserve number of bytes in data, add 1 for null
  length: .word     80
  msg:    .asciiz   "Type a string: "
  output: .asciiz   "\nYou typed: "
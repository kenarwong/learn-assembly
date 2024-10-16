# Program File: Exercise-7.asm
# Author: Ken Hwang
# Open dialog box and read string
# Write string back using message box

.text
.globl main

main:
  la $a0, msg
  la $a1, input
  lw $a2, length
  li $v0, 54              # code for InputDialogString
  syscall

  la $a0, output          
  la $a1, input           # address of input buffer to print
  li $v0, 59              # code for print string
  syscall

  li $v0, 10              # code for exit
  syscall

.data
  input:  .space    81                   # reserve number of bytes in data, add 1 for null
  length: .word     80
  msg:    .asciiz   "Type a string: "
  output: .asciiz   "\nYou typed: "
# Program File: Exercise-5.asm
# Author: Ken Hwang
# Read and print float

.text
.globl main

main:
  la $a0, msg
  li $v0, 4               # code for print string
  syscall

  li $v0, 6               # code for read float 
  syscall

  la $a0, output
  li $v0, 4               # code for print string
  syscall

  # float values are held in coproc's registers
  mov.d $f12, $f0         # move double precision float
  li $v0, 2               # code for print float
  syscall

  li $v0, 10              # code for exit
  syscall

.data
  msg:    .asciiz "Type a float: "
  output: .asciiz "\nYou typed: "
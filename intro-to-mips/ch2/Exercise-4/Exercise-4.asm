# Program File: Exercise-4.asm
# Author: Ken Hwang
# Sleep 4 seconds

.text
.globl main

main:
  lw $a0, duration
  li $v0, 32              # code for random int
  syscall

  li $v0, 10              # code for exit
  syscall

.data
  duration: .word 4000      # milliseconds
# File:     Exercise6-3.asm
# Author:   Ken Hwang
# Purpose:  Hexadecimal immediate

.text
  # lui $t0, 1001
  lui $t0, 0x1001
  lw $a0, 0($t0)
  li $v0, 1
  syscall

  li $v0, 10
  syscall

.data
  .word 8
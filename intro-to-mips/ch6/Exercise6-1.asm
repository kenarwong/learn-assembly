# File:     Exercise6-1.asm
# Author:   Ken Hwang
# Purpose:  Demonstrate la and lw microoperations

.text
main:
  # Addresses are 32-bit
  # $at must be used on anything >16 bit
  # because of instruction format
  la $s0, a     # lui $at, 0x00001001
                # ori $s0, $at, 0x00000000

  # Although $at must be used,
  # lw can leverage base addressing + offset
  lw $s1, b     # lui $at, 0x00001001
                # lw $s1, 0x00000004($at)

  li $v0, 10
  syscall

.data
  a:  .word   0x0000 
  b:  .word   0xffff  
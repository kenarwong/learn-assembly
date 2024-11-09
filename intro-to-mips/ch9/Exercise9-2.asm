# File:     Exercise9-2.asm
# Author:   Ken Hwang
# Purpose:  Convert decimal to hex character representation

.text
.globl main

main:
  lw $s1, numOfHexDigits                  # number of hex digits

  # malloc
  li $v0, 9
  mul $a0, $s1, 4                         # number of one-digit hex values * 4 char bytes ("0x" + # + "\0")
  syscall
  move $s0, $v0                           # base ptr

  # load string array
  li $t1, 0
  loadStringArray:
    beq $t1, $s1, endLoadStringArray

    # word base
    sll $t2, $t1, 2                       # byte addressed offset
    add $t0, $s0, $t2                     # base + offset

    # construct each character byte (4) in word
    li $t3, 0x30                          # "0"
    sb $t3, 0($t0)                        # store byte 0
    li $t3, 0x78                          # "x"
    sb $t3, 1($t0)                        # store byte 1

    # convert to hex char
    blt $t1, 0x0a, lessthan10 
    add $t3, $t1, 0x57                    # $t1 >= 0x0a
                                          # 0x0a + 0x57 = 0x61 ("a")
    b storeConvertedHexChar

    # $t1 < 0x0a
    lessthan10:
      add $t3, $t1, 0x30                  # 0x00 + 0x30 = 0x30 ("0")

    storeConvertedHexChar:
      sb $t3, 2($t0)                      # store byte 2

    li $t3, 0x00                          # "\0" (null terminate)
    sb $t3, 3($t0)                        # store byte 3

    addi $t1, $t1, 1                      # increment
    b loadStringArray
  
  endLoadStringArray:

  # Prompt user for input
  li $v0, 4
  la $a0, prompt
  syscall

  li $v0, 5
  syscall
  move $t0, $v0
  sll $t0, $t0, 2           # offset, byte addressed

  li $v0, 4
  la $a0, newline
  syscall

   # report hex
  li $v0, 4
  la $a0, hex
  syscall

  li $v0, 4
  add $a0, $s0, $t0         # indexed address
  syscall

.data
  prompt:             .asciiz "Enter a number from 0 to 15 "
  hex:                .asciiz "your number is "
  newline:            .asciiz "\n"
  numOfHexDigits:     .word   0x10
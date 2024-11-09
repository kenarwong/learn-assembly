# File:     Exercise9-1.asm
# Author:   Ken Hwang
# Purpose:  PrintIntArray in reverse

.text
.globl main

main:
  la $a0, array_base
  lw $a1, array_size
  jal PrintIntArrayReverse
  jal Exit

.data
  array_size: .word 5
  array_base:
    .word 12
    .word 7
    .word 3
    .word 5
    .word 11

.text
# Subprogram:               PrintIntArrayReverse
# Purpose:                  print an array of ints in reverse
# inputs:                   $a0 - the base address of the array
#                           $a1 - the size of the array
#
PrintIntArrayReverse:
    addi $sp, $sp, -16        # Stack record
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    move $s0, $a0             # save the base of the array to $s0

    # initialization for counter loop
    # $s1 is the array size - 1
    addi $s1, $a1, -1

  la $a0 open_bracket         # print open bracket
  jal PrintString

loop:
  # check ending condition
  sge $t0, $s1, $zero
  beqz $t0, end_loop

    sll $t0, $s1, 2           # multiply the loop counter by 4

    add $t0, $t0, $s0         # add offset to base

    lw $a1, 0($t0)
    la $a0, comma
    jal PrintInt              # print the integer from array

    addi $s1, $s1, -1         # decrement $s1
    b loop
end_loop:

  li $v0, 4                   # print close bracket
  la $a0, close_bracket
  syscall

  lw $ra, 0($sp)
  lw $s0, 4($sp)

  lw $s1, 8($sp)
  lw $s2, 12($sp)             # restore stack and return
  addi $sp, $sp, 16
  jr $ra

.data
  open_bracket:           .asciiz "["
  close_bracket:          .asciiz "]"
  comma:                  .asciiz ","
.include "utils.asm"
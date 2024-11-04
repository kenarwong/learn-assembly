# File:     Exercise8-1.asm
# Author:   Ken Hwang
# Purpose:  Calculate largest and average

.text
.globl main

main:
  li $v0, 4
  la $a0, prompt1         
  syscall

  li $v0, 5
  syscall
  move $s0, $v0

  li $v0, 4
  la $a0, newline         
  syscall

  li $v0, 4
  la $a0, prompt2         
  syscall

  li $v0, 5
  syscall
  move $s1, $v0

  li $v0, 4
  la $a0, newline         
  syscall

  li $v0, 4
  la $a0, prompt3         
  syscall

  li $v0, 5
  syscall
  move $s2, $v0

  li $v0, 4
  la $a0, newline         
  syscall

  li $v0, 4
  la $a0, prompt4         
  syscall

  li $v0, 5
  syscall
  move $s3, $v0

  li $v0, 4
  la $a0, newline         
  syscall

  move $a0, $s0
  move $a1, $s1
  move $a2, $s2
  move $a3, $s3
  jal largestAndAverage

  move $t0, $v0
  move $t1, $v1

  li $v0, 4
  la $a0, result1         
  syscall

  li $v0, 1
  move $a0, $t0
  syscall

  li $v0, 4
  la $a0, newline         
  syscall

  li $v0, 4
  la $a0, result2         
  syscall

  li $v0, 2
  mtc1 $t1, $f12                    # float is read from $f12
  syscall

  j Exit

largestAndAverage:
  addi $sp, $sp -0x20         
  swc1 $f1, 0x1c($sp)              
  swc1 $f0, 0x18($sp)              
  sw $s0, 0x14($sp)              
  sw $a3, 0x10($sp)              
  sw $a2, 0x0c($sp)              
  sw $a1, 0x08($sp)              
  sw $a0, 0x04($sp)              
  sw $ra, 0x00($sp)              

  # get largest first
  # compare a0, a1
  jal getLarger
  move $s0, $v0

  # compare a0, a1, a2
  move $a0, $s0
  lw $a2, 0x0c($sp)              
  move $a1, $a2
  jal getLarger
  move $s0, $v0

  # compare a0, a1, a2, a3
  move $a0, $s0
  lw $a3, 0x10($sp)              
  move $a1, $a3
  jal getLarger
  move $s0, $v0

  # get average
  # retrieve original values
  lw $a0, 0x04($sp)              
  lw $a1, 0x08($sp)              
  lw $a2, 0x0c($sp)              
  lw $a3, 0x10($sp)              

  # sum all integers
  add $t0, $a0, $zero
  add $t0, $a1, $t0
  add $t0, $a2, $t0
  add $t0, $a3, $t0

  # single-precision division
  mtc1 $t0, $f0
  cvt.s.w $f0, $f0
  li $t1, 4
  mtc1 $t1, $f1
  cvt.s.w $f1, $f1
  div.s $f0, $f0, $f1

  # return values
  move $v0, $s0                     # largest
  mfc1 $t0, $f0
  move $v1, $t0                     # average

  # restore remaining values
  lwc1 $f1, 0x1c($sp)              
  lwc1 $f0, 0x18($sp)              
  lw $s0, 0x14($sp)              
  lw $ra, 0x00($sp)              
  addi $sp, $sp -0x20         

  jr $ra

getLarger:
  bgt $a0, $a1, firstLarger
  # Else
    move $v0, $a1
    jr $ra

  firstLarger:
    move $v0, $a0
    jr $ra

Exit:
  li $v0, 10
  syscall

.data
  prompt1: .asciiz "Enter the first value: "
  prompt2: .asciiz "Enter the second value: "
  prompt3: .asciiz "Enter the third value: "
  prompt4: .asciiz "Enter the fourth value: "
  result1: .asciiz "The largest is: "
  result2: .asciiz "The average is: "
  newline: .asciiz "\n"
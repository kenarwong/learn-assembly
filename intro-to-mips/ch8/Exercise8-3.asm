# File:     Exercise8-3.asm
# Author:   Ken Hwang
# Purpose:  Calculate the median of three values

.text
.globl main

main:
  jal CalculateMedian

  li $v0, 10
  syscall

.text
CalculateMedian:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  li $v0, 4
  la $a0, prompt1         
  syscall

  li $v0, 5
  syscall
  move $t1, $v0

  li $v0, 4
  la $a0, newline         
  syscall

  li $v0, 4
  la $a0, prompt2         
  syscall

  li $v0, 5
  syscall
  move $t2, $v0

  li $v0, 4
  la $a0, newline         
  syscall

  li $v0, 4
  la $a0, prompt3         
  syscall

  li $v0, 5
  syscall
  move $t3, $v0

  li $v0, 4
  la $a0, newline         
  syscall

  li $v0, 4
  la $a0, median         
  syscall

  sgt $t4, $t1, $t3         # 0: t1 <= t3, 1: t1 >  t3
  # 0
    sgt $t5, $t2, $t3       # 0: t2 <= t3, 1: t2 >  t3

    # 0
      sgt $t6, $t1, $t2     # 0: t1 <= t2, 1: t1 > t2

      # 0
      # t1, t2, t3          # median t2

      # 1
      # t2, t1, t3          # median t1

    # 1
    # t1, t3, t2            # median t3

  # 1
    # sgt $t5, $t2, $t3       # 0: t2 <= t3, 1: t2 >  t3

    # 0
    # t2, t3, t1            # median t3

    # 1
      # sgt $t6, $t1, $t2     # 0: t1 <= t2, 1: t1 > t2

      # 0
      # t3, t1, t2          # median t1

      # 1
      # t3, t2, t1          # median t2

  # t4 t5 t6 | median
  #  0  0  0 | t2
  #  0  0  1 | t1
  #  0  1  x | t3
  #  1  0  x | t3
  #  1  1  0 | t1
  #  1  1  1 | t2

  # XOR(t4,t5) XOR(t4,t6) | median
  #          1          x | t3
  #          0          1 | t1
  #          0          0 | t2

  # median t3
  xor $t7, $t4, $t5
  beq $t7, 1, medianT3

  # median t1
  xor $t7, $t4, $t6
  beq $t7, 1, medianT1

  # median t2
  j medianT2
  
  medianT1:
    move $a0, $t1
    j reportMedian
  
  medianT2:
    move $a0, $t2
    j reportMedian
  
  medianT3:
    move $a0, $t3
    j reportMedian

  reportMedian:
    li $v0, 1
    syscall

  sw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra

.data
  prompt1:    .asciiz "Enter first number: "
  prompt2:    .asciiz "Enter second number: "
  prompt3:    .asciiz "Enter third number: "
  median:     .asciiz "The median is: "
  newline:    .asciiz "\n"
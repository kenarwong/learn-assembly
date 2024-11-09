# File:     Exercise9-3b.asm
# Author:   Ken Hwang
# Purpose:  AllocateArray always allocates double word size'd arrays 

.data
           .align 3
  float1:  .double 1.1
  float2:  .double 2.2

.text
.globl main

main:
  # Allocate 2 double word array
  li $a0, 2
  jal AllocateArray

  # Testing by storing double words to allocated memory address
  l.d $f0, float1
  l.d $f2, float2

  move $t0, $v0
  sdc1 $f0, 0($t0)

  li $t1, 1
  sll $t1, $t1, 3           # shift 4*2 = 8
  add $t0, $t0, $t1
  sdc1 $f2, 0($t0)

  li $v0, 10
  syscall

.text
# Subprogram:     AllocateArray
# Purpose:        To allocate an array of $a0 items,
#                 each of double word size 
# Author:         Ken Hwang
# Input:          $a0 - the number of items in the array
# Output:         $v0 - Address of the array allocated

AllocateArray:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  li $t0, 0x08

  mul $a0, $a0, $t0
  li $v0, 9
  syscall

  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
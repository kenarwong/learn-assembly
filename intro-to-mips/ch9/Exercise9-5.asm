# File:     Exercise9-5.asm
# Author:   Ken Hwang
# Purpose:  Selection Sort

.text
.globl main

main:
  la $a0, array_base
  lw $a1, array_size
  jal PrintIntArray

  la $a0, array_base
  lw $a1, array_size
  jal SelectionSort

  jal PrintNewLine
  la $a0, array_base
  lw $a1, array_size
  jal PrintIntArray

  jal Exit

.data
  array_size: .word 8
  array_base:
    .word 55
    .word 27
    .word 13
    .word 5
    .word 44
    .word 32
    .word 17
    .word 36

.text
# Subprogram:                 SelectionSort
# Purpose:                    Sort an array of integers
# Input parameters:           $a0 - array base pointer
#                             $a1 - length of array
# Side Effects:               Array is sorted
SelectionSort:
  # save context
  addi $sp, $sp, -0x24                 
  sw $s5, 0x20($sp)                    
  sw $s4, 0x1c($sp)                    
  sw $s3, 0x18($sp)                    
  sw $s2, 0x14($sp)                    
  sw $s1, 0x10($sp)                    
  sw $s0, 0x0c($sp)                    
  sw $a1, 0x08($sp)                    
  sw $a0, 0x04($sp)                    
  sw $ra, 0x00($sp)                    

  li $s0, 0                                             # i = 0
  move $s1, $a1                                         # n
  selectionSortOuterLoop:
    beq $s0, $s1, exitSelectionSortOuterLoop            # i < n 

    # arr[i]
    sll $s3, $s0, 2                                     # byte address
    add $s3, $a0, $s3                                   # base + offset
    lw $s3, 0($s3)                                      # smallest

    move $s2, $s0                                       # j = i
    selectionSortInnerLoop:
      beq $s2, $s1, exitSelectionSortInnerLoop          # j < n

      # arr[j]
      sll $s4, $s2, 2                                   # byte address
      add $s4, $a0, $s4                                 # base + offset
      lw $s4, 0($s4) 

      ble $s3, $s4, continueSelectionSortInnerLoop      # if (arr[i] > arr[j])
      
      move $s3, $s4                                     # smallest = arr[j]
      move $s5, $s2                                     # smallestIndex = j

      continueSelectionSortInnerLoop:

      addi $s2, $s2, 1                                  # j++
      b selectionSortInnerLoop  

    exitSelectionSortInnerLoop:

    # swap smallest value with value at index i
    # $a0 is already base pointer to array
    move $a1, $s0                                       # i
    move $a2, $s5                                       # smallestIndex
    jal swap                                            # swap(arr[i],arr[smallestIndex])

    addi $s0, $s0, 1                                    # i++
    b selectionSortOuterLoop
    
  exitSelectionSortOuterLoop:

  # restore context
  lw $s5, 0x20($sp)                    
  lw $s4, 0x1c($sp)                    
  lw $s3, 0x18($sp)                    
  lw $s2, 0x14($sp)                    
  lw $s1, 0x10($sp)                    
  lw $s0, 0x0c($sp)                    
  lw $a1, 0x08($sp)                    
  lw $a0, 0x04($sp)                    
  lw $ra, 0x00($sp)
  addi $sp, $sp, -0x24

  jr $ra                                                # return

# Subprogram:                 swap
# Purpose:                    swap values in an array of integers
# Input parameters:           $a0 - base pointer to array containing elements to swap
#                             $a1 - index of element 1
#                             $a2 - index of element 2
# Side Effects:               Array is changed to swap element 1 and 2
swap:
  # save context
  addi $sp, $sp, -4                 
  sw $ra, 0($sp)                    

  # byte address
  sll $t1, $a1, 2                   
  sll $t2, $a2, 2                   

  # base + offset
  add $t1, $a0, $t1                 
  add $t2, $a0, $t2                 

  # swap
  lw $t3, 0($t1)                    
  lw $t4, 0($t2)                    
  sw $t4, 0($t1)                    
  sw $t3, 0($t2)                    

  # restore context
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra                            # return

# Subprogram:                 PrintIntArray
# Purpose:                    print an array of ints
# inputs:                     $a0 - the base address of the array
#                             $a1 - the size of the array
#
PrintIntArray:
    addi $sp, $sp, -16        # Stack record
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    move $s0, $a0             # save the base of the array to $s0

    # initialization for counter loop
    # $s1 is the ending index of the loop
    # $s2 is the loop counter
    move $s1, $a1
    move $s2, $zero

  la $a0 open_bracket         # print open bracket
  jal PrintString

loop:
  # check ending condition
  sge $t0, $s2, $s1
  bnez $t0, end_loop

    sll $t0, $s2, 2           # Multiply the loop counter by
                              # by 4 to get offset (each element
                              # is 4 big).

    add $t0, $t0, $s0         # address of next array element
    lw $a1, 0($t0)            # Next array element
    la $a0, comma
    jal PrintInt              # print the integer from array

  addi $s2, $s2, 1            # increment $s0
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
  open_bracket: .asciiz "["
  close_bracket: .asciiz "]"
  comma: .asciiz ","
.include "utils.asm"
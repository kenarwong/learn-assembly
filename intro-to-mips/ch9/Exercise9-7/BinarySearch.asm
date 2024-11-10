# File:                       BinarySearch.asm
# Author:                     Ken Hwang
# Purpose:                    Helper function to call recursive binary search
# Input parameters:           $a0 - array pointer
#                             $a1 - size
#                             $a2 - value to search
# Output:                     $v0 - search value index
#                             $v1 - operations counted
.text
.globl BinarySearch

BinarySearch:
  # save context
  addi $sp, $sp, -0x14
  sw $s0, 0x10($sp)                    
  sw $a2, 0x0c($sp)                    
  sw $a1, 0x08($sp)                    
  sw $a0, 0x04($sp)                    
  sw $ra, 0x00($sp)                    

  # allocate heap variables
  li $v0, 9
  li $a0, 8                             # 2 words, 8 bytes
  syscall
  move $s0, $v0
  li $t0, 0
  sw $t0, 0($s0)                        # operation counts
  sw $t0, 4($s0)                        # searched value index

  lw $a0, 0x04($sp)                     # array pointer                        
  move $a3, $a2                         # value to search
  addi $a2, $a1, -1                     # end index (size - 1)
  li $a1, 0                             # start index (0)

  jal BinarySearchRecurse

  # return
  lw $v0, 4($s0)                        # searched value index
  lw $v1, 0($s0)                        # operation counts

  # restore context
  lw $s0, 0x10($sp)                    
  lw $a2, 0x0c($sp)                    
  lw $a1, 0x08($sp)                    
  lw $a0, 0x04($sp)                    
  lw $ra, 0x00($sp)                    
  addi $sp, $sp, 0x14

  jr $ra

# Subprogram:                 BinarySearchRecurse
# Purpose:                    Recursive binary search for value in a sorted array
# Input parameters:           $a0 - array pointer
#                             $a1 - start index
#                             $a2 - end index
#                             $a3 - value to search
BinarySearchRecurse:
  # save context
  addi $sp, $sp, -0x14
  sw $a3, 0x10($sp)                    
  sw $a2, 0x0c($sp)                    
  sw $a1, 0x08($sp)                    
  sw $a0, 0x04($sp)                    
  sw $ra, 0x00($sp)                    

  # mid = start + (end-start)/2
  sub $t0, $a2, $a1
  srl $t0, $t0, 1
  add $t0, $a1, $t0

  # arr[mid]
  sll $t1, $t0, 2
  add $t1, $a0, $t1
  lw $t1, 0($t1)

  # ++access count
  lw $t3, 0($s0)                        # load operation count
  addi $t3, $t3, 1                      # 
  sw $t3, 0($s0)                        # store operation count

  # arr[mid] == value to search
  beq $a3, $t1, endSearch

  # arr[mid] < value to search
  blt $a3, $t1, searchLower

  # arr[mid] > value to search
  b searchHigher

  endSearch:
    sw $t0, 4($s0)                      # store searched value index
    b exitBinarySearchRecurse           # base case

  searchLower:
    addi $a2, $t0, -1                 # start:mid-1
    jal BinarySearchRecurse  
    b exitBinarySearchRecurse

  searchHigher:
    addi $a1, $t0, 1                  # mid+1:end
    jal BinarySearchRecurse  
    b exitBinarySearchRecurse

  exitBinarySearchRecurse:

  # restore context
  lw $a3, 0x10($sp)                    
  lw $a2, 0x0c($sp)                    
  lw $a1, 0x08($sp)                    
  lw $a0, 0x04($sp)                    
  lw $ra, 0x00($sp)                    
  addi $sp, $sp, 0x14

  jr $ra
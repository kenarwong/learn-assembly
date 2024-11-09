.text
# Subprogram:     AllocateArray
# Purpose:        To allocate an array of $a0 items,
#                 each of size $a1.
# Author:         Charles Kann
# Input:          $a0 - the number of items in the array
#                 $a1 - the size of each item
# Output:         $v0 - Address of the array allocated

AllocateArray:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  mul $a0, $a0, $a1
  li $v0, 9
  syscall

  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
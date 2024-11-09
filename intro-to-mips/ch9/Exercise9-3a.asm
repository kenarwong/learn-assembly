# File:     Exercise9-3a.asm
# Author:   Ken Hwang
# Purpose:  Test AllocateArray boundary allocation
# 
# Result:   Unable to demonstrate that AllocateArray can fall on any boundary
#           It appears that even trying to force sbrk to allocate wrong number of bytes, 
#           it will always begin on a word boundary

.text
.globl main
.text
main:
  # Adding a byte prior to allocation
  la $t0, 0x10040000
  li $t1, 0xff
  sb $t1, 0($t0)

  # Attempting to allocate number of bytes (3) to fall short of word boundary
  la $a0, prompt                       # Read and print one character
  li $a1, 3
  jal PromptString
  move $a0, $v0
  jal PrintString

  # Attempting to allocate number of bytes (3) to fall short of word boundary
  li $a0, 1
  li $a1, 3
  jal AllocateArray

  # Testing by storing word to allocated memory address
  li $t0, 1
  sw $t0, 0($v0)

  jal Exit

.data
  prompt: .asciiz "Enter 1 character: "

.text
# Subprogram:                           PromptString
# Author:                               Charles Kann
# Purpose:                              To prompt for a string, allocate the string
#                                       and return the string to the calling subprogram.
# Input:                                $a0 - The prompt
#                                       $a1 - The maximum size of the string
# Output:                               $v0 - The address of the user entered string

PromptString:
  addi $sp, $sp, -12                    # Push stack
  sw $ra, 0($sp)
  sw $a1, 4($sp)
  sw $s0, 8($sp)

  li $v0, 4                             # Print the prompt
  syscall                               # in the function, so we know $a0 still has
                                        # the pointer to the prompt.

  li $v0, 9                             # Allocate memory
  lw $a0, 4($sp)
  syscall
  move $s0, $v0

  move $a0, $s0                         # Read the string
  li $v0, 8
  lw $a1, 4($sp)
  syscall

  move $v0, $s0                         # Save string address to return

  lw $ra, 0($sp)                        # Pop stack
  lw $s0, 8($sp)
  addi $sp, $sp, 12
  jr $ra

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

.include "utils.asm"
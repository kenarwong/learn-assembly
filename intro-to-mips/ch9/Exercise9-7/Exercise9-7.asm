# File:     Exercise9-7.asm
# Author:   Ken Hwang
# Purpose:  Measure Binary Search on different array sizes
#           Demonstrate that the algorithm's proportional 
#           time requirement (growth rate) is log(n)

.data
  debug:                      .word     0
  numRuns:                    .word     10
  size1:                      .word     10
  size2:                      .word     100
  size3:                      .word     1000
  size4:                      .word     10000
  assertFailedText:           .asciiz   "Assertion failed. Exiting."
  operationsCountText:        .asciiz   "Average number of access operations: "
  loopBinarySearchStartText:  .asciiz   "Looping binary search"
  loopBinarySearchSizeText:   .asciiz   "Size of array: "
  loopBinarySearchRunsText:   .asciiz   "Number of runs: "
  newline:                    .asciiz   "\n"

.text
.globl main

main:
  # random seed
  # li $v0, 40
  # li $a0, 1
  # li $a1, 1
  # syscall

  # size1
  lw $a0, size1                           # size
  lw $a1, numRuns                         # number of runs
  jal LoopBinarySearch

  # size2
  lw $a0, size2                           # size
  lw $a1, numRuns                         # number of runs
  jal LoopBinarySearch

  # size3
  lw $a0, size3                           # size
  lw $a1, numRuns                         # number of runs
  jal LoopBinarySearch

  # size4
  lw $a0, size4                           # size
  lw $a1, numRuns                         # number of runs
  jal LoopBinarySearch

  j exit

assertFailed:
  li $v0, 4
  la $a0, assertFailedText
  syscall
  j exit

exit:
  li $v0, 10
  syscall

.text
# Subprogram:                 LoopBinarySearch
# Purpose:                    Loop through binary searches of a set array size
#                             Report average count of operations over all runs
# Input parameters:           $a0 - size
#                             $a1 - number of runs
LoopBinarySearch:
  # save context
  addi $sp, $sp, -0x1c
  sw $s5, 0x18($sp)                    
  sw $s4, 0x14($sp)                    
  sw $s3, 0x10($sp)                    
  sw $s2, 0x0c($sp)                    
  sw $s1, 0x08($sp)                    
  sw $s0, 0x04($sp)                    
  sw $ra, 0x00($sp)                    

  move $s0, $a0                            # size
  move $s3, $a1                            # number of runs

  # report loop start
  li $v0, 4
  la $a0, loopBinarySearchStartText
  syscall

  li $v0, 4
  la $a0, newline
  syscall

  li $v0, 4
  la $a0, loopBinarySearchSizeText
  syscall

  li $v0, 1
  move $a0, $s0
  syscall

  li $v0, 4
  la $a0, newline
  syscall

  li $v0, 4
  la $a0, loopBinarySearchRunsText
  syscall

  li $v0, 1
  move $a0, $s3
  syscall

  li $v0, 4
  la $a0, newline
  syscall

  # allocate heap memory
  li $v0, 9
  li $t0, 4
  mul $a0, $s3, $t0                       # operation counts array (number of runs * 4 bytes)
  syscall
  move $s4, $v0                           # operation count array

  # prepare sorted array
  move $a0, $s0
  lw $a1, debug
  jal SortRandomArray
  move $s1, $v0                         # array pointer

  li $s5, 0                               # i = 0
  loopNumberOfRuns:
    beq $s5, $s3, exitLoopNumberOfRuns      # i < n      

    # choose a random index in array
    li $v0, 42
    li $a0, 0
    addi $a1, $s0, -1                     # random 0:n-1
    syscall

    # retrieve value from a random index
    move $t0, $a0
    sll $t0, $t0, 2
    add $t0, $s1, $t0
    lw $s2, 0($t0)                        # value to search

    # binary search for value
    move $a0, $s1                         # array pointer                        
    move $a1, $s0                         # size 
    move $a2, $s2                         # value to search
    jal BinarySearch

    # verify that value searched is correct
    move $t0, $v0                          
    sll $t0, $t0, 2
    add $t0, $s1, $t0
    lw $t0, 0($t0)                         
    bne $t0, $s2, assertFailed            # assert(returnedResult,searchValue)
    
    # store operation count
    sll $t0, $s5, 2
    add $t0, $s4, $t0                     # offset + base operation array pointer
    sw $v1, 0($t0)

    addi $s5, $s5, 1                      # i++
    b loopNumberOfRuns

  exitLoopNumberOfRuns:
    # average operation counts
    li $t0, 0                                       # sum
    li $t1, 0                                       # i
    loopOperationCountArray:
      beq $t1, $s3, exitLoopOperationCountArray     # i < n
    
      # load operation count
      sll $t2, $t1, 2
      add $t2, $s4, $t2                     
      lw $t2, 0($t2)

      add $t0, $t0, $t2                             # sum = sum + operation count

      addi $t1, $t1, 1                              # i++

      b loopOperationCountArray

    exitLoopOperationCountArray:

    # average operation count
    mtc1 $t0, $f0
    cvt.d.w $f0, $f0
    mtc1 $t1, $f2
    cvt.d.w $f2, $f2
    div.d $f12, $f0, $f2

    # report average operation count
    li $v0, 4
    la $a0, operationsCountText
    syscall

    li $v0, 3
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, newline
    syscall

  # restore context
  sw $s5, 0x18($sp)                    
  lw $s4, 0x14($sp)                    
  lw $s3, 0x10($sp)                    
  lw $s2, 0x0c($sp)                    
  lw $s1, 0x08($sp)                    
  lw $s0, 0x04($sp)                    
  lw $ra, 0x00($sp)                    
  addi $sp, $sp, 0x1c

  jr $ra

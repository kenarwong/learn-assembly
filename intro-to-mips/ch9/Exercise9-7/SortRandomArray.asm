# File:     SortRandomArray.asm
# Author:   Ken Hwang
# Purpose:  Sort Random Array of size n
# Input:    $a0 - array size
#           $a1 - debug, 1 to print ints
# Output:   $v0 - pointer to sorted array

.data
  maxRange:         .word   65536

.text
.globl SortRandomArray

SortRandomArray:
  # save context
  addi $sp, $sp, -0x14
  sw $s1, 0x10($sp)                    
  sw $s0, 0x0c($sp)                    
  sw $a1, 0x08($sp)                    
  sw $a0, 0x04($sp)                    
  sw $ra, 0x00($sp)                    

  move $s0, $a0                           # size

  # int array[size]
  sll $a0, $s0, 2
  li $v0, 9
  syscall
  move $s1, $v0                           # base

  # fill array with random numbers
  # li $v0, 40
  # li $a0, 1
  # li $a1, 1
  # syscall

  li $t0, 0
  lw $a1, maxRange                        # maximize random integer value
  randomFill:
    beq $t0, $s0, exitRandomFill

    li $v0, 42
    li $a0, 0
    syscall

    sll $t1, $t0, 2
    add $t1, $s1, $t1
    sw $a0, 0($t1)

    addi $t0, $t0, 1

    b randomFill

  exitRandomFill:

  # debug
  lw $a1, 0x08($sp)                    
  beq $a1, 0, skipDebug1
  move $a0, $s1
  move $a1, $s0
  jal PrintIntArray

  skipDebug1:
    move $a0, $s1
    li $a1, 0
    addi $a2, $s0, -1                       # n - 1
    jal QuickSort

  lw $a1, 0x08($sp)                    
  beq $a1, 0, skipDebug2
  jal PrintNewLine
  move $a0, $s1
  move $a1, $s0
  jal PrintIntArray

  skipDebug2:

  move $v0, $s1                             # output array pointer

  # restore context
  lw $s1, 0x10($sp)                    
  lw $s0, 0x0c($sp)                    
  lw $a1, 0x08($sp)                    
  lw $a0, 0x04($sp)                    
  lw $ra, 0x00($sp)                    
  addi $sp, $sp, 0x14


  jr $ra

.text
# Subprogram:                 QuickSort
# Purpose:                    Sort an array of integers
# Input parameters:           $a0 - array base pointer
#                             $a1 - start index 
#                             $a2 - end index
# Side Effects:               Array is sorted
QuickSort:
  # save context
  addi $sp, $sp, -0x14
  sw $s0, 0x10($sp)                    
  sw $a2, 0x0c($sp)                    
  sw $a1, 0x08($sp)                    
  sw $a0, 0x04($sp)                    
  sw $ra, 0x00($sp)                    

  # allocate heap variables
  li $v0, 9
  li $a0, 4                               # 1 int, 4 bytes
  syscall
  move $s0, $v0

  # restore arguments
  lw $a0, 0x04($sp)                    
  lw $a1, 0x08($sp)                    
  lw $a2, 0x0c($sp)                    

  # p = partition
  jal partition
  move $t0, $v0
  sw $t0, 0($s0)                          # store p

  # check if (p - 1) > start
  lw $a1, 0x08($sp)                    
  addi $t1, $t0, -1                       # p - 1
  ble $t1, $a1, continueQuickSort

  # quick sort left 
  move $a2, $t1                           # end = p - 1
  # $a1 is already start index
  lw $a0, 0x04($sp)                    
  jal QuickSort
  
  lw $t0, 0($s0)                          # load p

  continueQuickSort:

  # check if(p + 1) < end
  lw $a2, 0x0c($sp)                    
  addi $t1, $t0, 1                        # p + 1
  bge $t1, $a2, endQuickSort

  # quick sort right 
  # $a2 is already end index
  move $a1, $t1                           # start = p + 1
  lw $a0, 0x04($sp)                    
  jal QuickSort

  endQuickSort:

  # restore context
  lw $s0, 0x10($sp)                    
  lw $a2, 0x0c($sp)                    
  lw $a1, 0x08($sp)                    
  lw $a0, 0x04($sp)                    
  lw $ra, 0x00($sp)
  addi $sp, $sp, 0x14

  jr $ra                                                # return

# Subprogram:                 partition
# Purpose:                    partition array into items around a pivot
#                             pivot selection: median-of-three
# Input parameters:           $a0 - base pointer to array containing elements to swap
#                             $a1 - start index 
#                             $a2 - end index
# Output:                     $v0 - pivot index
# Side Effects:               items smaller are left of pivot, items bigger are right of pivot
partition:
  addi $sp, $sp, -0x14
  sw $s0, 0x10($sp)
  sw $a2, 0x0c($sp)
  sw $a1, 0x08($sp)
  sw $a0, 0x04($sp)
  sw $ra, 0x00($sp)

  # median of 3
  # arr[start]
  move $t1, $a1
  sll $t1, $t1, 2
  add $t1, $a0, $t1
  lw $t4, 0($t1)

  # arr[end]
  move $t3, $a2
  sll $t3, $t3, 2
  add $t3, $a0, $t3
  lw $t6, 0($t3)

  # calculate n-1 
  sub $t0, $a2, $a1               # n - 1 = h - l

  # calculate mid
  srl $t2, $t0, 1                 # mid = (h - l)/2 
  add $t2, $a1, $t2               # mid = mid + start

  # check if (n == 2)
  move $s0, $t2                   # pivot index = mid
  beq $t0, 1, sortTwo             # (h - l) == 1, n = 2

  # else 
  # arr[mid] (pivot)
  sll $t2, $t2, 2
  add $t2, $a0, $t2
  lw $t5, 0($t2)

  # begin median-of-three sort (sort arr[start], arr[mid], arr[end])
  sgt $t7, $t4, $t5                       # 0: arr[start] <= arr[mid]
                                          # 1: arr[start] > arr[mid]
  sgt $t8, $t5, $t6                       # 0: arr[mid]   <= arr[end]
                                          # 1: arr[mid]   > arr[end]
  sgt $t9, $t4, $t6                       # 0: arr[start] <= arr[end]
                                          # 1: arr[start] >  arr[end]

  # t7 t8 t9 | 
  #  0  0  0 | t1 <= t2 <= t3           
  #  0  0  1 | t1 <= t2 <= t3 < t1 XXX
  #  0  1  0 | t1 <= t3 < t2
  #  0  1  1 | t3 < t1 <= t2 
  #  1  0  0 | t2 < t1 <= t3
  #  1  0  1 | t2 <= t3 < t1 
  #  1  1  0 | t1 <= t3 < t2 < t1 XXX
  #  1  1  1 | t3 < t2 < t1 

  # t7 t8 t9 | order
  #  0  0  x | t1,t2,t3
  #  0  1  0 | t1,t3,t2
  #  0  1  1 | t3,t1,t2
  #  1  0  0 | t2,t1,t3
  #  1  0  1 | t2,t3,t1
  #  1  1  x | t3,t2,t1
  
  and $t0, $t7, $t8                      
  beq $t0, 1, medianSort11x
  nor $t0, $t7, $t8                      
  and $t0, $t0, 0x1
  beq $t0, 1, medianSort00x
  and $t0, $t7, $t9                      
  beq $t0, 1, medianSort101
  nor $t0, $t7, $t9                      
  and $t0, $t0, 0x1
  beq $t0, 1, medianSort010
  and $t0, $t8, $t9                      
  beq $t0, 1, medianSort011
  nor $t0, $t8, $t9                      
  and $t0, $t0, 0x1
  beq $t0, 1, medianSort100

  medianSort00x:
    sw $t4, 0($t1)
    sw $t5, 0($t2)
    sw $t6, 0($t3)
    b endMedianOfThreeSort
  medianSort010:
    sw $t4, 0($t1)
    sw $t6, 0($t2)
    sw $t5, 0($t3)
    b endMedianOfThreeSort
  medianSort011:
    sw $t6, 0($t1)
    sw $t4, 0($t2)
    sw $t5, 0($t3)
    b endMedianOfThreeSort
  medianSort100:
    sw $t5, 0($t1)
    sw $t4, 0($t2)
    sw $t6, 0($t3)
    b endMedianOfThreeSort
  medianSort101:
    sw $t5, 0($t1)
    sw $t6, 0($t2)
    sw $t4, 0($t3)
    b endMedianOfThreeSort
  medianSort11x:
    sw $t6, 0($t1)
    sw $t5, 0($t2)
    sw $t4, 0($t3)
    b endMedianOfThreeSort

  endMedianOfThreeSort:
    # update median-of-three sorted values
    lw $t4, 0($t1)
    lw $t5, 0($t2)
    lw $t6, 0($t3)

    # check if (n == 3)
    beq $t0, 2, exitPartition                   # (h - l) == 2, n = 3
                                                # $s0 already set to pivot index (mid)

    # else, n > 3
    # median = pivot
    # set pivot to end - 1 (end is already >= pivot from median-of-three sort)

    # arr[end-1]
    addi $t1, $a2, -1                               # pivotIndex = end - 1
    sll $t8, $t1, 2
    add $t8, $a0, $t8
    lw $t9, 0($t8)

    # swap(arr[mid],arr[end-1])
    sw $t9, 0($t2)
    sw $t5, 0($t8)
    move $t9, $t5                                   # update pivot

    # begin partition loop
    addi $t0, $a1, 1                                # i = start + 1 (arr[start] is already <= pivot from median-of-three sort)
    addi $t3, $t1, -1                               # j = pivotIndex - 1 
    partitionLoop:
      # bge $t0, $t3, exitPartitionLoop               # while i < j

      partitionLoopIncrementi:

        # arr[i]
        sll $t4, $t0, 2
        add $t4, $a0, $t4
        lw $t5, 0($t4)

        bge $t5, $t9, partitionLoopIncrementj     # while (arr[i] < pivot)
        addi $t0, $t0, 1                          # i++
        b partitionLoopIncrementi

      partitionLoopIncrementj:

        # arr[j]
        sll $t6, $t3, 2
        add $t6, $a0, $t6
        lw $t7, 0($t6)

        ble $t7, $t9, partitionLoopSwapij         # while (arr[j] > pivot)
        addi $t3, $t3, -1                         # j--
        b partitionLoopIncrementj

      partitionLoopSwapij:
        bge $t0, $t3, exitPartitionLoop           # if (i < j)

        # swap(arr[i],arr[j])
        sw $t7, 0($t4)                    
        sw $t5, 0($t6)                    

        addi $t0, $t0, 1                          # i++
        addi $t3, $t3, -1                         # j--

        b partitionLoop
    
    exitPartitionLoop:
      # swap(arr[i], arr[pivotIndex])
      sw $t9, 0($t4)                    
      sw $t5, 0($t8)                    

      # pivotIndex = i
      move $s0, $t0

      b exitPartition

  sortTwo:
    blt $t4, $t6, exitPartition       

    # arr[start] > arr[end]
    # swap(arr[start], arr[end])  
    sw $t6, 0($t1)
    sw $t4, 0($t3)

  exitPartition:
  move $v0, $s0             # return pivot index

  lw $s0, 0x10($sp)
  lw $a2, 0x0c($sp)
  lw $a1, 0x08($sp)
  lw $a0, 0x04($sp)
  lw $ra, 0x00($sp)
  addi $sp, $sp, 0x14

  jr $ra

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
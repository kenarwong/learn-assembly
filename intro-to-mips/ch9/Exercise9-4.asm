# File:     Exercise9-4.asm
# Author:   Ken Hwang
# Purpose:  Store Fibonacci numbers in an array and print

.text
.globl main

main:
  # Prompt user for input
  li $v0, 4
  la $a0, prompt
  syscall

  li $v0, 5
  syscall
  move $s0, $v0                           # size

  # int Fibonacci[size]
  sll $a0, $s0, 2
  li $v0, 9
  syscall
  move $s1, $v0                           # base

  # Fibonacci[0] = 0
  li $t0, 0
  sw $t0, 0($s1)

  # Fibonacci[1] = 1
  li $t0, 1
  sll $t1, $t0, 2                         # offset byte address
  add $t1, $s1, $t1                       # base + offset
  sw $t0, 0($t1)

  # Loop 
  li $s2, 2                               # i = 2
  fibonacciLoop:
    bge $s2, $s0, exitFibonacciLoop       # i < size

    # Fibonacci[i-1]
    addi $t0, $s2, -1                     # i-1
    sll $t0, $t0, 2                       # offset byte address
    add $t0, $s1, $t0                     # base + offset
    lw $t1, 0($t0)                        # load from heap
    
    # Fibonacci[i-2]
    addi $t0, $s2, -2                     # i-2                   
    sll $t0, $t0, 2                       # offset byte address
    add $t0, $s1, $t0                     # base + offset
    lw $t2, 0($t0)                        # load from heap

    # Fibonacci[i] = Fibonacci[i-1] + Fibonacci[i-2]
    sll $t0, $s2, 2                       # offset byte address
    add $t0, $s1, $t0                     # base + offset
    add $t2, $t2, $t1                     
    sw $t2, 0($t0)                        # store to heap

    addi $s2, $s2, 1                      # i++

    b fibonacciLoop
  
  exitFibonacciLoop:

  # PrintIntArray
  move $a0, $s1
  move $a1, $s0
  jal PrintIntArray

  li $v0, 10
  syscall

.data
  prompt:           .asciiz "Enter a max Fibonacci number to calc: "

.text
# Subprogram:               PrintIntArray
# Purpose:                  print an array of ints
# inputs:                   $a0 - the base address of the array
#                           $a1 - the size of the array
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
                              # Next array element
    lw $a1, 0($t0)
    la $a0, comma
    jal PrintInt              # print the integer from array

    addi $s2, $s2, 1          # increment $s0
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
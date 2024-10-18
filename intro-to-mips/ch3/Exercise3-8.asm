# File:     Exercise3-7.asm
# Author:   Ken Hwang
# Purpose:  Divide by 15 with shift 

.text
.globl main

main:
  # Prompt user for input
  addi $v0, $zero, 4
  la $a0, prompt
  syscall

  addi $v0, $zero, 5
  syscall
  andi $s0, $v0, 0xffff # zero extend (truncate left 16 bits) 

  # Divide by 15 using shift 
  move $a0, $s0
  addi $a1, $zero, 15
  jal divide
  move $s1, $v0
  move $s2, $v1

  # Display the result
  addi $v0, $zero, 4
  la $a0, result1
  syscall

  addi $v0, $zero, 1
  move $a0, $s1
  syscall

  addi $v0, $zero, 4
  la $a0, result2
  syscall

  addi $v0, $zero, 1
  move $a0, $s2
  syscall

  # Divide by 15 using div 
  addi $t0, $zero, 15
  div $s0, $t0
  mflo $s3
  mfhi $s4

  bne $s1, $s3, Exit
  bne $s2, $s4, Exit

  # Display validation check 
  addi $v0, $zero, 4
  la $a0, valid
  syscall

  j Exit

divide:
  add $t0, $zero, $a0         # dividend

  add $t1, $zero, $a1         # divisor
  xori $t1, $t1, -1           
  addi $t1, $t1, 1            # 2's complement of divisor
  sll $t1, $t1, 0x10

  addi $t2, $zero, 16         # n (16 bit)

  add $t3, $zero, $a0         # initialize AQ

  addi $t4, $zero, 0xffff     # A mask
  lui $t5, 0xffff             # Q mask

divideloop:
  beq $t2, $zero, exitloop          # if n == 0, exit 

  sll $t3, $t3, 1                   # shift AQ
  add $t6, $t3, $t1                 # subtract divisor, $t6 is remainder
                                    # allow overflow so we can detect

  # overflow detection (same sign operands)
  xor $t7, $t6, $t1                 # determine bit changes
  andi $t7, $t7, 0x80000000         # look at last bit for change

  addi $t2, $t2, -1                 # n--

  bne $t7, 0x80000000, divideloop   # no overflow if no change in last bit 

  # if overflow
  ori $t3, $t3, 1                   # if overflow detected, set Q0 = 1

  # add remainder to A
  and $t8, $t3, $t4                 # mask A from AQ (keep Q)
  or $t3, $t6, $t8                  # add remainder to A

  j divideloop

exitloop:
  and $v0, $t3, $t4                 # quotient from Q
  and $v1, $t3, $t5                 # remainder from A
  srl $v1, $v1, 0x10

  jr $ra

Exit:
  addi $v0, $zero, 10
  syscall

.data
  prompt:   .asciiz "Enter a value (0-65535): "
  result1:   .asciiz "\nThe quotient of your value divided by 15 (using shift) is: "
  result2:   .asciiz "\nThe remainder of your value divided by 15 (using shift) is: "
  valid:   .asciiz "\nThis value is equal to the quotient and remainder of the div operation"
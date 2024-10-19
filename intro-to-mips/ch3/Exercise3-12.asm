# File:     Exercise3-12.asm
# Author:   Ken Hwang
# Purpose:  Factor prime numbers
.text
.globl main

main:
  # Prompt user for input1
  addi $v0, $zero, 4
  la $a0, prompt1
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0

  # Prompt user for input2
  addi $v0, $zero, 4
  la $a0, prompt2
  syscall

  addi $v0, $zero, 5
  syscall
  move $s1, $v0

  # Do not divide by 0
  beq $s1, $zero, Exit              # Abort if 0 is divisor

  div $s0, $s1                      # Check if divisible
  mflo $s2
  mfhi $t0

  beq $t0, $zero, checkprime        # Check if prime if hi is 0

  # Display not a factor
  addi $v0, $zero, 1
  move $a0, $s1
  syscall

  addi $v0, $zero, 4
  la $a0, displayNotFactor
  syscall

  addi $v0, $zero, 1
  move $a0, $s0
  syscall

  addi $v0, $zero, 4
  la $a0, displayNewLine
  syscall

  addi $v0, $zero, 1                # Display -1
  addi $a0, $zero, -1
  syscall

  j Exit

checkprime:

  # Verify prime number
  add $t1, $zero, $zero
  addi $t2, $zero, 2
  div $s1, $t2

  mflo $t3                          # initialize n, n = s1 / 2

  loop:
      blt $t3, $t2, endloop         # end loop when n < 2

      div $s1, $t3                  # s1 / n
      mfhi $t4

      seq $t1, $t4, $zero           # if s1 is divisible, set not prime flag
      bne $t1, $zero, endloop       # then not prime, end loop

      addi $t3, $t3, -1             # n--
      j loop

  endloop:
    # Display 
    addi $v0, $zero, 1
    move $a0, $s1
    syscall

    bne $t1, $zero, notprime        # if not prime flag was set

    prime:
      addi $v0, $zero, 4
      la $a0, displayIsPrime
      syscall

      j endcheck

    notprime:
      addi $v0, $zero, 4
      la $a0, displayIsNotPrime
      syscall

      j endcheck

  endcheck:
    addi $v0, $zero, 4
    la $a0, displayNewLine
    syscall

    addi $v0, $zero, 1              #  Display 0
    add $a0, $zero, $zero
    syscall

    j Exit

Exit:
  # Exit
  addi $v0, $zero, 10
  syscall

.data
  prompt1:            .asciiz "Enter first value: "
  prompt2:            .asciiz "\nEnter second value: "
  displayNewLine:     .asciiz "\n"
  displayNotFactor:   .asciiz " is not a factor of "
  displayIsPrime:     .asciiz " is a prime number\n"
  displayIsNotPrime:  .asciiz " is not a prime number\n"
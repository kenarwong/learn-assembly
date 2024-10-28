# File:     Exercise7-4.asm
# Author:   Ken Hwang
# Purpose:  Determine prime numbers, guard against numbers

.text
.globl main

main:
  # Prompt user for input
  addi $v0, $zero, 4
  la $a0, prompt
  syscall

  addi $v0, $zero, 5
  syscall
  move $s0, $v0                         # $s0 is n

  beq $s0, -1, exit                     # allow -1, but negative numbers can't be prime, so just exit
  ble $s0, 2, invalidInput              # if n <=2, display error

  # check prime number
  addi $t1, $zero, 2                # start from j = 2
  div $s0, $t1
  mflo $t2                          # initialize sentinel, i/2

  innerLoop:
    bgt $t1, $t2, endInnerLoop    # end loop when j > n/2

    rem $t3, $s0, $t1             # i % j

    seq $t3, $t3, $zero           # if n is divisible, set not prime flag
    bne $t3, $zero, endInnerLoop  # then not prime, end loop

    addi $t1, $t1, 1              # j++
    j innerLoop

  endInnerLoop:
    # display start of message
    addi $v0, $zero, 4
    la $a0, displayPrimeStart
    syscall

    addi $v0, $zero, 1
    move $a0, $s0
    syscall

    bne $t3, $zero, notPrime          # if not prime flag was set

      prime:
        addi $v0, $zero, 4
        la $a0, displayIsPrime
        syscall

        j exit

      notPrime:
        addi $v0, $zero, 4
        la $a0, displayIsNotPrime
        syscall

        j exit

invalidInput:
  addi $v0, $zero, 4
  la $a0, displayInvalidInput
  syscall

exit:
  # exit
  addi $v0, $zero, 10
  syscall

.data
  prompt:               .asciiz "Enter value: "
  displayPrimeStart:    .asciiz "Number "
  displayIsPrime:       .asciiz " is a prime\n"
  displayIsNotPrime:    .asciiz " is not prime\n"
  displayInvalidInput:  .asciiz "Error"
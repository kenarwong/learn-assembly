# File:     Exercise7-3.asm
# Author:   Ken Hwang
# Purpose:  Determine prime numbers
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

  # outer loop from 3 to n
  add $t0, $zero, 3                     # start from i = 3
  add $t3, $t3, 0                       # first check for prime will be true (not prime flag = 0)
  addi $t4, $t4, 0                      # count prime numbers
  outerLoop:
    bgt $t0, $s0, exit                  # end when i > n

    jal checkPrime                      # check if i is prime
    addi $t0, $t0, 1                    # increment i
    j outerLoop

    # check prime number
    checkPrime:
      addi $t1, $zero, 2                # start from j = 2
      div $t0, $t1
      mflo $t2                          # initialize sentinel, i/2

      innerLoop:
          bgt $t1, $t2, endInnerLoop    # end loop when j > n/2

          rem $t3, $t0, $t1             # i % j

          seq $t3, $t3, $zero           # if n is divisible, set not prime flag
          bne $t3, $zero, endInnerLoop  # then not prime, end loop

          addi $t1, $t1, 1              # j++
          j innerLoop

      endInnerLoop:
        bne $t3, $zero, endCheck        # if not prime flag was set

        Prime:
          beq $t4, $zero, displayPrime      # don't prepend separator if first prime found

          addi $v0, $zero, 4
          la $a0, displaySeparator
          syscall
          
          displayPrime:
            addi $v0, $zero, 1            # display prime
            move $a0, $t0
            syscall

          addi $t4, $t4, 1              # count++

    endCheck:
      jr $ra

exit:
  # exit
  addi $v0, $zero, 10
  syscall

.data
  prompt:               .asciiz "Enter value: "
  displaySeparator:     .asciiz ", "
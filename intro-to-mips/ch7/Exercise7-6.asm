# File:     Exercise7-5.asm
# Author:   Ken Hwang
# Purpose:  Random number guessing game

.text
.globl main

main:
  # Prompt user for input
  addi $v0, $zero, 4
  li $v0, 4
  la $a0, prompt
  syscall

  li $v0, 5
  syscall
  move $t1, $v0                         # max value is end range

  addi $t0, $zero, 0                    # start range
  addi $s0, $zero, 0                    # guess value
  addi $s1, $zero, 0                    # guess count 
  addi $t2, $zero, 2                    # dividend
  la $s3, chars                         # chars used for feedback validation

  # start guessing loop
  guessLoop:
    # todo end loop condition
    
    sub $t3, $t1, $t0
    div $t3, $t2                        
    mflo $t3                            # always truncate (lower value if even number of values)
    add $t3, $t3, $t0                   # start + [(end-start)/2]

    feedbackCheck1:
      # Ask if correct
      li $v0, 4
      la $a0, displayFeedback1
      syscall

      li $v0, 1
      move $a0, $t3
      syscall

      li $v0, 4
      la $a0, 0x10($s3)
      syscall

      addi $s1, $s1, 1                  # guess count++

      la $a0, input                     # address of input buffer in data
      lw $a1, length                    # number of characters
      li $v0, 8                         # code for read string
      syscall
      lw $t4, input                     # user feedback y or n

      li $v0, 4
      la $a0, 0x10($s3)
      syscall

      lw $t5, 0x00($s3)                 # y
      lw $t6, 0x04($s3)                 # n
      seq $t5, $t5, $t4
      seq $t6, $t6, $t4
      or $t7, $t5, $t6                  # if y or n
      beq $t7, 1, endFeedbackCheck1     # exit loop

      # invalid feedback
      li $v0, 4
      la $a0, displayInvalid1
      syscall

      j feedbackCheck1                  # loop back to user request

    endFeedbackCheck1:

    beq $t5, 1, correct                 # exit loop on correct guess

    feedbackCheck2:
      # Ask if high or low
      li $v0, 4
      la $a0, displayFeedback2
      syscall

      li $v0, 4
      la $a0, 0x10($s3)
      syscall

      la $a0, input                     # address of input buffer in data
      lw $a1, length                    # number of characters
      li $v0, 8                         # code for read string
      syscall
      lw $t4, input                     # user feedback h or l

      li $v0, 4
      la $a0, 0x10($s3)
      syscall

      lw $t5, 0x08($s3)                 # h
      lw $t6, 0x0c($s3)                 # l
      seq $t5, $t5, $t4
      seq $t6, $t6, $t4
      or $t7, $t5, $t6                  # if h or l
      beq $t7, 1, endFeedbackCheck2     # exit loop

      # invalid feedback
      li $v0, 4
      la $a0, displayInvalid2
      syscall

      j feedbackCheck2                  # loop back to user request

    endFeedbackCheck2:

    sub $t7, $t1, $t0                   # check range 
    seq $t7, $t7, 1                     # if only two options (range of 1)
    beq $t5, 1, tooHigh
    
    tooLow:
      beq $t7, 1, twoFinalLow           # end if only one other option 

      move $t0, $t3                   
      addi $t0, $t0, 1                  # n/2 is now start range + 1
      j continue

    tooHigh:
      beq $t7, 1, twoFinalHigh          # end if only one other option 

      move $t1, $t3                     # n/2 is now end range, start remains
      subi $t1, $t1, 1                  # n/2 is now end range - 1

    continue:
      sub $t7, $t1, $t0                 # check range 
      beq $t7, 0, oneFinal              # if only one option left (range of 0)

      j guessLoop

oneFinal:
  move $t3, $t1                         # set remaining option as final answer
  addi $s1, $s1, 1                      # guess count++
  j correct

twoFinalLow:
  move $t3, $t1                         # set remaining option as final answer
  addi $s1, $s1, 1                      # guess count++
  j correct

twoFinalHigh:
  # we always present lowest value when two options left
  # so this is not possible
  li $v0, 4
  la $a0, displayFinalLie               
  syscall

  move $t3, $t0                         # set remaining option as final answer

correct:
  # display final guess
  li $v0, 4
  la $a0, displayFinalGuess
  syscall

  li $v0, 1
  move $a0, $t3                       
  syscall

  li $v0, 4
  la $a0, 0x10($s3)
  syscall

  # display number of guesses
  li $v0, 4
  la $a0, displayGuessCount
  syscall

  li $v0, 1
  move $a0, $s1                       
  syscall

  li $v0, 4
  la $a0, 0x10($s3)
  syscall

exit:
  # exit
  li $v0, 10
  syscall

.data
                                .word   chars
  prompt:                       .asciiz "Enter a maximum value to guess from: "
  displayFeedback1:             .asciiz "Is this your number? (y/n) "
  displayFeedback2:             .asciiz "Is it high? (h) or low? (l) "
  displayFinalGuess:            .asciiz "Your number is: "
  displayFinalLie:              .asciiz "Liar.\n"
  displayGuessCount:            .asciiz "Number of guesses: "
  displayInvalid1:              .asciiz "You entered an incorrect input. Please confirm with y or n\n"
  displayInvalid2:              .asciiz "You entered an incorrect input. Please confirm with h or l\n"
                                .align  2
  input:                        .space  4 
                                .align  2
  length:                       .word   3
  chars:
    .asciiz   "y\n"
    .align  2
    .asciiz   "n\n"
    .align  2
    .asciiz   "h\n"
    .align  2
    .asciiz   "l\n"
    .align  2
    .asciiz   "\n"
    .align  2
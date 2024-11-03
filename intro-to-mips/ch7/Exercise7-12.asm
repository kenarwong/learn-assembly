# File:     Exercise7-12.asm
# Author:   Ken Hwang
# Purpose:  Determine smallest number of coins

.text
.globl main

main:
  # Load constants
  la $s0, constants
  lw $t0, 0($s0)
  lw $t1, 4($s0) 

  # Address for retrieving coin amounts
  la $s1, coins

  # Address for storing quantities
  la $s2, quantities

  # Unique coin count
  li $s4, 0

inputValidation:
  # Prompt user for input
  addi $v0, $zero, 4
  li $v0, 4
  la $a0, prompt
  syscall

  li $v0, 5
  syscall
  move $s3, $v0                         

  slt $t2, $s3, $t0
  sgt $t3, $s3, $t1
  or $t0, $t2, $t3
  beqz $t0, exitValidation

  # invalid 
  li $v0, 4
  la $a0, displayInvalid
  syscall
  
  j inputValidation

exitValidation:

  move $t1, $s1                                 # coin address
  move $t2, $s2                                 # coin quantities address

  # outer loop for each coin 
  coinLoop:
    beq $s3, 0, displayReport                   # once amount is 0, end all coin occurrence checking 

    lw $t3, 0($t1)                              # get coin 

    div $s3, $t3                                # amount divided by coin 
    mflo $t4                                    # quotient
    mfhi $s3                                    # update dividend (remainder)

    sw $t4, 0($t2)                              # store coin occurrences (quotient)

    addi $t1, $t1, 4                            # increment coin address 
    addi $t2, $t2, 4                            # increment coin quantity address 

    beq $t4, 0, coinLoop                        # if no occurrences, don't increment unique coin count

    addi $s4, $s4, 1                            # increment unique coin count 
    j coinLoop

displayReport:
  # report coin quantities 
  li $v0, 4
  la $a0, displayQuantities
  syscall

  move $t0, $s2                                 # address for quantities
  lw $t4, 8($s0)                                # address for quantity label ASCII size
  li $t1, 0                                     # i = 0
  li $t2, 4                                     # i < 4
  li $t5, 1                                     # count for coins displayed (at least 1)

  displayReportLoop:
    beq $t1, $t2, exit                          # exit i == 4

    lw $t3, 0($t0)                              # retrieve coin quantity
    beq $t3, $zero, continueDisplayReportLoop   # if quantity is 0, skip to next coin

    beq $t5, 1, continueReport                  # first display, skip prepending spacer
                                                # 1 item will never need spacer
    prependSpacer: 
      # determine spacer type
      bgt $s4, 2, checkOxfordCommaDisplay       # check for oxford comma 

      # 2 items, and without oxford comma
      checkAndDisplay:
        li $v0, 4
        la $a0, displayAndSpacer
        syscall
        j continueReport

      # >2 items, comma or oxford comma
      checkOxfordCommaDisplay:
        beq $t5, $s4, finalOxfordItem    # prepend final oxford comma if last item

        li $v0, 4
        la $a0, displayCommaSpacer
        syscall
        j continueReport

        finalOxfordItem:
          li $v0, 4
          la $a0, displayOxfordCommaSpacer
          syscall
          j continueReport

    continueReport:
      # display quantity
      li $v0, 1
      move $a0, $t3
      syscall

      li $v0, 4
      la $a0, displaySpace
      syscall

      # determine coin text
      beq $t1, 0, displayQuarterLabel
      beq $t1, 1, displayDimeLabel
      beq $t1, 2, displayNickelLabel
      beq $t1, 3, displayPennyLabel

      displayQuarterLabel:
        la $a0, displayQuarter
        j calculateLabelPlurality

      displayDimeLabel:
        la $a0, displayDime
        j calculateLabelPlurality

      displayNickelLabel:
        la $a0, displayNickel
        j calculateLabelPlurality

      displayPennyLabel:
        la $a0, displayPenny
        j calculateLabelPlurality

      # determine plurality
      calculateLabelPlurality:
        beq $t3, 1, displayQuantityLabel
        add $a0, $a0, $t4                       # increment by ASCII label size for next plural label
      
      displayQuantityLabel:
        li $v0, 4
        syscall
        
      addi $t5, $t5, 1                          # increment displayed coin iterator

    continueDisplayReportLoop:
      addi $t0, $t0, 4                          # increment quantity address 
      addi $t1, $t1, 1                          # increment iterator 

    j displayReportLoop

exit:
  li $v0, 10
  syscall

.data
  prompt:                       .asciiz "Enter a value between 0 and 100: "
  displayInvalid:               .asciiz "You entered an incorrect input.\n"
  displayQuantities:            .asciiz "The number of coins to produce your amount are: "
  displaySpace:                 .asciiz " "
  displayCommaSpacer:           .asciiz ", "
  displayAndSpacer:             .asciiz " and "
  displayOxfordCommaSpacer:     .asciiz ", and "
  constants:
    .word   0
    .word   100
    .word   8
  coins:
    .word   25
    .word   10
    .word   5
    .word   1
  quantities:
    .word   0
    .word   0
    .word   0
    .word   0
  displayQuarter:
    .align  3
    .asciiz "quarter"
    .align  3
    .asciiz "quarters"
  displayDime:
    .align  3
    .asciiz "dime"
    .align  3
    .asciiz "dimes"
  displayNickel:
    .align  3
    .asciiz "nickel"
    .align  3
    .asciiz "nickels"
  displayPenny:
    .align  3
    .asciiz "penny"
    .align  3
    .asciiz "pennies"
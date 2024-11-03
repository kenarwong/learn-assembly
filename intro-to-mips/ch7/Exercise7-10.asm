# File:     Exercise7-10.asm
# Author:   Ken Hwang
# Purpose:  Determine prime factors, with uniqueness check

.text
.globl main

main:

  # Load constants
  la $s0, constants
  lw $t0, 0($s0)
  lw $t1, 4($s0) 

  # Address for storing factors
  la $s1, factors

  # Count of prime factors    
  li $s2, 0                             # initiate prime factor count 

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
  # first check if is prime number
  move $a0, $s3
  jal checkPrime
  move $t0, $v0

  beq $t0, 1, isPrime                             # if prime, go directly to displayReport

  notPrime:
    # outer loop from 
    addi $s4, $zero, 2                            # divisor starts from i = 2

    move $s5, $s3                                 # initialize dividend (user value)
    addi $s6, $s1, 0                              # initialize address index

    notPrimeOuterLoop:
      # check if divisor is prime, if it is then check occurrences, reduce problem set
      move $a0, $s4
      jal checkPrime
      move $t0, $v0

      beq $t0, $zero, continueNotPrimeOuterLoop   # not prime, look for next prime factor

      # continue to divide dividend by prime factor to count number of occurrences
      notPrimeInnerLoop:
        beq $s5, 1, exitNotPrimeOuterLoop         # once dividend is 1, end all prime factor occurrence checking 

        div $s5, $s4                              # dividend divided by prime factor
        mflo $t0                                  # quotient
        mfhi $t1                                  # remainder

        # while user value is divisible, divide user value by prime factor
        bgtz $t1, continueNotPrimeOuterLoop       # if dividend is no longer divisible by prime factor, continue to next prime factor

        move $s5, $t0                             # update dividend (quotient)
        addi $s2, $s2, 1                          # increment prime factor count (occurrence)
        sw $s4, 0($s6)                            # store prime factor 
        addi $s6, $s6, 4                          # increment address index

        # continue until user value is equal to 1 or no longer divisible
        j notPrimeInnerLoop

      continueNotPrimeOuterLoop:
        addi $s4, $s4, 1                          # increment divisor
        j notPrimeOuterLoop

    exitNotPrimeOuterLoop:
      j displayReport

  isPrime:
    addi $s2, $s2, 1                          # only 1 prime factor, itself
    sw $s3, 0($s1)                            # load user's prime number

    j displayReport

displayReport:
  # report prime factors 
  li $v0, 4
  la $a0, displayFactors
  syscall

  move $t0, $s1                                 # address for factors
  li $t1, 0                                     # loop iterator

  li $t2, 0                                     # temporary variable for factor uniqueness check

  displayReportLoop:
    beq $t1, $s2, exit                          # exit when no more prime factors

    lw $t3, 0($t0)
    beq $t3, $t2, continueDisplayReportLoop     # if this factor is the same as the last, skip display
    move $t2, $t3                               # update temp variable for uniqueness check
                                                # comment out if do not want uniqueness check

    beq $t1, $zero, continueReport              # first loop, skip prepending spacer
    prependSpacer: 
      li $v0, 4
      la $a0, displaySpacer
      syscall
  
    continueReport:
      # display factor
      li $v0, 1
      move $a0, $t3
      syscall

    continueDisplayReportLoop:
      addi $t0, $t0, 4                          # increment address 
      addi $t1, $t1, 1                          # increment iterator 

    j displayReportLoop

exit:
  li $v0, 10
  syscall

.data
  prompt:                       .asciiz "Enter a value between 3 and 100: "
  displayInvalid:               .asciiz "You entered an incorrect input.\n"
  displayFactors:               .asciiz "The prime factors for your number are: "
  displaySpacer:                .asciiz ", "
  constants:
    .word   3
    .word   100
  factors:

# Author:   Ken Hwang
# Purpose:  Determine if prime number
# Output: 
.text
checkPrime:
  move $t0, $a0

  addi $t1, $zero, 2                    # start from i = 2
  div $t0, $t1
  mflo $t2                              # initialize sentinel, n/2

  li $t3, 1                             # default to 1 (prime)

  checkPrimeLoop:
    bgt $t1, $t2, endCheckPrimeLoop     # end loop when i > n/2

    rem $t3, $t0, $t1                   # n % i
    beq $t3, $zero, endCheckPrimeLoop   # if n is divisible, then not prime

    addi $t1, $t1, 1                    # i++
    j checkPrimeLoop

endCheckPrimeLoop:
  sgt $v0, $t3, $zero                   # 0 = not prime, 1 = prime

  jr $ra                                # return
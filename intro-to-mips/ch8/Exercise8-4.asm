# File:     Exercise8-4.asm
# Author:   Ken Hwang
# Purpose:  Return average of prompted numbers

.text
.globl main

main:
  jal AverageNumbers
  j exit

.text
AverageNumbers:
  addi $sp, $sp, -0x10
  swc1 $f12, 0x0c($sp)
  swc1 $f0, 0x08($sp)
  swc1 $f1, 0x04($sp)
  sw $ra, 0x00($sp)

  li $t0, 0
  li $t1, 0
  li $t2, 0

  inputLoop:

    # Prompt user for input
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t2, $v0

    li $v0, 4
    la $a0, newline
    syscall

    beq $t2, -1, exitInputLoop        # exit on -1

    add $t0, $t0, $t2                 # sum
    addi $t1, $t1, 1                  # count

    j inputLoop

  exitInputLoop:

    beqz $t1, exit            # handle zero inputs

    # calculate average
    mtc1 $t0, $f0
    cvt.s.w $f0, $f0
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    div.s $f12, $f0, $f1

    # report average
    li $v0, 4
    la $a0, average
    syscall

    li $v0, 2
    syscall

    # restore stack
    lwc1 $f12, 0x0c($sp)
    lwc1 $f0, 0x08($sp)
    lwc1 $f1, 0x04($sp)
    lw $ra, 0x00($sp)
    addi $sp, $sp, 0x10

    jr $ra

exit:
  li $v0, 10
  syscall

.data
  prompt:     .asciiz "Enter a number (-1 to stop): "
  average:    .asciiz "The average is: "
  newline:    .asciiz "\n"
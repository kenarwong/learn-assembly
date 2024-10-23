# File:     utils.asm
# Purpose:  Extract from utils.asm, to demonstrate infinite loop
# Author:   Ken Hwang

# subprogram:     PrintNewLine
# author:         Charles Kann
# purpose:        to output a new line to the user console
# input:          None
# output:         None
# side effects:   A new line character is printed to the
#                 user's console
.text
PrintNewLine:
  li $v0, 4
  la $a0, __PNL_newline
  syscall
  jr $ra
.data
  __PNL_newline: .asciiz "\n"

# subprogram:     PrintInt
# author:         Charles W. Kann
# purpose:        To print a string to the console
# input:          $a0 - The value of the int to print
#                 $a1 - The value of the int to print
#                 $a2 - The number of iterations to stop infinite loop
# returns:        None
# side effects:   The String is printed followed by the integer value.
.text
PrintInt:
  addi $sp, $sp, -4             # need to store $ra on stack 
  sw $ra, 0($sp)

  move $t0, $a2                 # Start counter  

  # Print string. The string address is already in $a0
  li $v0, 4
  syscall

  # Print integer.  The integer value is in $a1, and must
  # be first moved to $a0.
  move $a0, $a1
  li $v0, 1
  syscall

  # Print a new line character
  jal PrintNewLine              # Cannot jal within a subprogram without dealing with re-entrance
                                # jal will set $ra to next instruction
                                # After PrintNewLine finishes, it will jump to that instruction
                                # Then after this subpogram finishes, it will also jump back to same instruction
                                # Therefore, stuck in this subprogram
  
  # Condition to demonstrate infinite loop
  beq $t0, $zero, exitInfiniteLoop      # exit infinite loop
  addi $t0, $t0, -1

  # Print iterations until count reaches 0
  la $a0, loopCountDisplay
  li $v0, 4
  syscall
  move $a0, $t0
  li $v0, 1
  syscall
  la $a0, __loopCountDisplay_newline
  li $v0, 4
  syscall

  # Original return statement
  #return
  jr $ra

exitInfiniteLoop:
  lw $ra, 0($sp)                # load original $ra
  addi $sp, $sp, 4              

  jr $ra                        # return to caller

.data
  loopCountDisplay:             .asciiz "Loop count: "
  __loopCountDisplay_newline:   .asciiz "\n"
# Program File: strcpy.asm
# Author: Ken Hwang
# Helper function to copy strings

#.data
#  x: .asciiz "Hello, World!"    # x
#    .align 2                    # align to word
#  y: .asciiz "Goodbye, World!"  # y
#    .align 2                    # align to word

.data
  newline: .byte 0x0a         # ASCII for newline

.text
.globl strcpy

strcpy:
  #la $a0, x                   # Load address of x into $a0
  #la $a1, y                   # Load address of y into $a1

  # Store registers 
  addi $sp, $sp, -4           # need 1 word
  sw $s0, 0($sp)              # store saved register

  add $s0, $zero, $zero 		  # set i to 0
  lbu $t0, newline            # newline character

strcpyloop:
  add $t1, $s0, $a1		      	# get address of y + offset
                              # do not need to multiply
                              # working with byte characters
  lbu $t2, 0($t1)			        # load unsigned byte at y[i]
  					                  # always using 0, already offsetted					

  beq $t2, $zero, exitloop	  # check if y[i] == 0 (null), exit loop
  beq $t2, $t0, exitloop	    # check if y[i] == 0x0a (newline), exit loop

  add $t3, $s0, $a0		      	# get address of x + offset
  sb $t2, 0($t3)			        # store at x[i]

  addi $s0, $s0, 1			      # increment i
  j strcpyloop				        # loop

exitloop:
  move $v0, $t3               # address of last byte in x (end)

  # Restore register
  lw $s0, 0($sp)			        # restore saved register
  addi $sp, $sp, 4			      # restore 1 word
  jr $ra				              # return
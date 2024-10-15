.data
  x: .asciiz "Hello, World!"    # x
    .align 4                    # align to word
  y: .asciiz "Goodbye, World!"  # y
    .align 4                    # align to word

.text
.globl main

main:
  la $a0, x                   # Load address of x into $a0
  la $a1, y                   # Load address of y into $a1

  jal strcpy

  j Exit

strcpy:
	# Store registers immediately
	addi $sp, $sp, -4           # need 1 word
	sw $s0, 0($sp)              # store saved register

  add $s0, $zero, $zero 		  # set i to 0

	                            # $a0 is memory address of x
	                            # $a1 is memory address of y
	                            # $zero is null terminator

strcpyloop:
  add $t1, $s0, $a1		      	# get address of y + offset
                              # do not need to multiply
                              # working with byte characters
  lbu $t2, 0($t1)			        # load unsigned byte at y[i]
  					                  # always using 0, already offsetted					
  add $t3, $s0, $a0		      	# get address of x + offset
  sb $t2, 0($t3)			        # store at x[i]

  beq $t2, $zero, exitloop	  # check if y[i] == 0 (null), exit loop

  addi $s0, $s0, 1			      # increment i
  j strcpyloop				          # loop

exitloop:
	# Restore register
	lw $s0, 0($sp)			        # restore saved register
	addi $sp, $sp, 4			      # restore 1 word
	jr $ra				              # return

Exit:
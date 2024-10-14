.data
  n: .word 0x0a   # n

.text
.globl main

main:
  la $gp, n
  lw $a0, 0($gp)

  jal fact
  j Exit

fact:
  # Save context immediately
  # Store registers
  addi $sp, $sp, -8           # Adjust stack pointer
  sw $ra, 4($sp) 
  sw $a0, 0($sp) 

  # Check for base case 
  slti $t0, $a0, 1            # Set 1 if n < 1
  beq $t0, $zero, recurse     # Check if n >=1, jump to recursive step

  # Base case: n < 1
  addi $v0, $zero, 1          # Set return value as 1
  addi $sp, $sp, 8            # Readjust stack pointer, no more recursion, do not need to load stored registers
  jr $ra                      # Return 

recurse:
  addi $a0, $a0, -1           # new argument is n - 1
  jal fact                    # recursive call

  # $ra linked here           # $ra = PC + 4

  # Restore context immediately
  # Perform everything in reverse
  # Now need to restore registers
  # because they have been altered
  lw $a0, 0($sp)              # load register
  lw $ra, 4($sp)              # load register
  addi $sp, $sp, 8            # Adjust stack pointer

  mul $v0, $v0, $a0           # n * fact(n - 1)

  jr $ra                      # Return 

Exit:
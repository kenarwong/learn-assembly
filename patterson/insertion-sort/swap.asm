# C program to swap two numbers
# void swap(int v[], int k)
# {
#   int temp;
#   temp = v[k];
#   v[k] = v[k+1];
#   v[k+1] = temp;
# }

# example data
#.data
#  v:        .word 1, 2, 4, 8, 16
#  length:   .word 5
#  k:        .word 3 

.text
.globl swap
  
swap:
  # example data
  #la $a0, v
  #la $gp, k
  #lw $a1, 0($gp)
  #la $gp, length
  #lw $a2, 0($gp)

  # $a0: v[0]
  # $a1: k
  # $a2: length

  # save context
  addi $sp, $sp, -4                 # reserve 1 word on stack
  sw $s0, 0($sp)                    # store $s0

  # check if in bounds
  slt $t0, $a1, $zero              # if k < 0
  bne $t0, $zero, IndexOutOfBounds  # then go to IndexOutOfBounds

  addi $t1, $a1, 1                  # $t1 = k + 1
  sltu $t2, $t1, $a2                # if k+1 < length 
  beq $t2, $zero, IndexOutOfBounds  # else go to IndexOutOfBounds

  # word -> byte address
  sll $t3, $a1, 2                   # $t3 = k * 4

  # relative -> absolute address
  add $s0, $a0, $t3                 # $s0 = v + k

  # swap
  lw $t4, 0($s0)                    # temp = v[k]
  lw $t5, 4($s0)                    # $t5 = v + k + 1
  sw $t5, 0($s0)                    # v[k] = $t5
  sw $t4, 4($s0)                    # v[k+1] = temp

  # restore context
  lw $s0, 0($sp)
  addi $sp, $sp, 4

  jr $ra                            # return

IndexOutOfBounds:
  # restore context
  lw $s0, 0($sp)
  addi $sp, $sp, 4

  j Exit
  
Exit:
  li	$v0, 10		# system call code for exit = 10
	syscall				# call operating sys
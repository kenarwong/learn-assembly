#void sort(int v[], int n)
#{
#  int i, j;
#  for (i = 0; i < n; i += 1) {
#    for (j = i - 1; j >= 0 && v[j] > v[j + 1]; j -= 1) {
#      swap(v,j);
#    }
#  }
#}

.data
  v:   .word 8, 3, 7, 1, 5
  n:   .word 5

.text
.globl main
  
main:
  la $a0, v
  la $gp, n
  lw $a1, 0($gp)

  jal sort
  j Exit

sort:
  # $a0: v[0]
  # $a1: n

  # save context
  addi $sp, $sp, -0x14              # reserve 5 words on stack
  sw $s0, 0x00($sp)                 # store $s0, v
  sw $s1, 0x04($sp)                 # store $s1, n
  sw $s2, 0x08($sp)                 # store $s2, i
  sw $s3, 0x0c($sp)                 # store $s3, j
  sw $ra, 0x10($sp)                 # store $ra

  add $s0, $a0, $zero               # $s0 = v[0]
  add $s1, $a1, $zero               # $s1 = n
  add $s2, $zero, $zero             # i = 0
  add $s3, $zero, $zero             # j = 0
  
  # begin i loop
iloop:
  # i loop condition
  sltu $t0, $s2, $s1                # if(i < n)
  beq $t0, $zero, exitiloop         # else exit

  # initialize j
  addi $s3, $s2, -1                 # j = i - 1

  # begin j loop
jloop:
  # j loop condition 1
  slt $t0, $s3, $zero               # if(j >= 0)
  bne $t0, $zero, exitjloop         # else exit

  # array index
  sll $t0, $s3, 2                   # j * 4
  add $t1, $s0, $t0                 # v + j

  # load values
  lw $t2, 0($t1)                    # v[j]
  lw $t3, 4($t1)                    # v[j+1]

  # j loop condition 2
  slt $t0, $t2, $t3                 # if v[j] < v[j+1]
  bne $t0, $zero, exitjloop         # else exit

  # swap values
  # prepare argument registers
  add $a0, $s0, $zero               # $a0: v[0] 
  add $a1, $s3, $zero               # $a1: j 
  add $a2, $s1, $zero               # $a2: length 
  jal swap                          # call leaf procedure

  # decrement j
  addi $s3, $s3, -1                 # j = i - 1

  j jloop                           # j loop

  # end j loop
exitjloop:

  # increment i
  addi $s2, $s2, 1                  # i++

  j iloop                           # i loop

  # end i loop
exitiloop:

  # restore context
  lw $ra, 0x10($sp)
  lw $s3, 0x0c($sp)
  lw $s2, 0x08($sp)
  lw $s1, 0x04($sp)
  lw $s0, 0x00($sp)
  addi $sp, $sp, 0x14

  jr $ra                            # return

Exit:
  li	$v0, 10		# system call code for exit = 10
	syscall				# call operating sys
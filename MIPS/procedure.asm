.data
  g: .word 0x03      # g
  h: .word 0x02      # h
  i: .word 0x01      # i
  j: .word 0x01      # j

.text
.globl main
main:
  la $gp, g        # Load address of g into $gp
  lw $a0, 0($gp)   # Load g into $s1
  la $gp, h        # Load address of h into $gp
  lw $a1, 0($gp)   # Load h into $s2
  la $gp, i        # Load address of i into $gp
  lw $a2, 0($gp)   # Load i into $s3
  la $gp, j        # Load address of j into $gp
  lw $a3, 0($gp)   # Load j into $s4

  jal leaf_example  # Jump-and-Link to procedure
  j Exit

leaf_example:
  # Save old values on stack before executing procedure
  addi $sp, $sp, -12  # adjust stack to make room for 3 items
  sw $t1, 8($sp)      # save register 
  sw $t0, 4($sp)      # save register 
  sw $s0, 0($sp)      # save register 

  # Body of procedure
  add $t0, $a0, $a1   # g + h
  add $t1, $a2, $a3   # i + j
  sub $s0, $t0, $t1   # f = (g + h) - (i + j)

  # Save results to value register
  add $v0, $s0, $zero # Storing f to value register

  # Pop old values off stack (opposite order)
  lw $s0, 0($sp)      # restore register
  lw $t0, 4($sp)      # restore register
  lw $t1, 8($sp)      # restore register
  addi $sp, $sp, 12   # restore $sp position

  jr $ra              # jump back to calling routine

Exit:
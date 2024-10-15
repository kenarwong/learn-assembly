  # Conditional branch
.data
  g: .word 0x03      # g
  h: .word 0x02      # h
  i: .word 0x01      # i
  j: .word 0x01      # j

.text
.globl main
main:
  la $gp, g        # Load address of g into $gp
  lw $s1, 0($gp)   # Load g into $s1
  la $gp, h        # Load address of h into $gp
  lw $s2, 0($gp)   # Load h into $s2
  la $gp, i        # Load address of i into $gp
  lw $s3, 0($gp)   # Load i into $s3
  la $gp, j        # Load address of j into $gp
  lw $s4, 0($gp)   # Load j into $s4

  bne $s3, $s4, Else  # Branch to Else if i != j
  add $s0, $s1, $s2   # f = g + h (executed if i == j)
  j Exit              # Jump to Exit

Else:
  sub $s0, $s1, $s2   # f = g - h (executed if i != j)
  j Exit              # Jump to Exit

Exit:
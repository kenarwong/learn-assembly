.data
  a: .word 0xffffffff           # a
  b: .word 0x00000001           # b

.text
.globl main

main:
  la $gp, a                     # Load a
  lw $s0, 0($gp)
  la $gp, b                     # Load b
  lw $s1, 0($gp)

  # Set on less than
  slt $t0, $s0, $s1             # $t0 = 1, because a is negative and b is positive, so a is less

  # Set on less than unsigned
  sltu $t1, $s0, $s1            # $t1 = 0, because a is the largest unsigned number, so a is greater
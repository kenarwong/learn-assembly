.data
  a:      .word 0x00000005           # a
  b:      .word -0x00000005          # b
  #b:      .word -0x00000055          # b
  length: .word 0x0000000a           # length

.text
.globl main

main:
  la $gp, a                         # Load a
  lw $s0, 0($gp)
  la $gp, b                         # Load b
  lw $s1, 0($gp)
  la $gp, length                    # Load length
  lw $s2, 0($gp)

  # Comparison against an unsigned value serves 2 purposes
  # It can check both the lower and upper bounds of an array
  # 1) If it is negative, then it is in 2's complement form
  # 2) If it is larger than length of the array, the 2's complement form also begins with large values.
  #     This makes it most likely larger than the array length

  # Check when in bounds
  sltu $t0, $s0, $s2                # $t0 = 1, because a is within bounds of length, it is
  beq $t0, $zero, IndexOutOfBounds  # If equal to 0, then go to IndexOutOfBounds

  # Check when out of bounds
  sltu $t1, $s1, $s2                # $t1 = 0, because b is a large unsigned number, so it will likely be greater
  beq $t1, $zero, IndexOutOfBounds  # If equal to 0, then go to IndexOutOfBounds
  j Exit

  IndexOutOfBounds:
    nor $t2, $t2, $zero             # Set all values in $t2 to 1
    j Exit
  
Exit:
  # R-Type
  #add $t0,$s1,$s2

  # I-Type
  #lw $t0,32($s3)

  # Add to value in memory
  #lw $t0,1200($t1) # Load A[300] into $t0
  #add $t0,$s2,$t0 # Add constant in $s2 to $t0
  #sw $t0,1200($t1) # Store $t0 back to A[300]

  # Shift left 4 bits  
#  lw $s0,0x8000($gp)
#  sll $t2,$s0,4 # reg $t2 = reg $s0 << 4 bits
#  
#.data
#  d1: 0x00000009

#  # AND 
#  lw $t1,0x8000($gp)
#  lw $t2,0x8004($gp)
#  and $t0,$t1,$t2 # reg $t0 = reg $t1 & reg $t2
  
#.data
#  d1: 0x00003c00
#  d2: 0x00000dc0

#  # OR 
#  lw $t1,0x8000($gp)
#  lw $t2,0x8004($gp)
#  or $t0,$t1,$t2 # reg $t0 = reg $t1 | reg $t2
#  
#.data
#  d1: 0x00003c00
#  d2: 0x00000dc0

#  # NOT (aka NOR with 0) 
#  lw $t1,0x8000($gp)
#  nor $t0,$t1,$zero # reg $t0 = !(reg $t1)
#  
#.data
#  d1: 0x00003c00

  # ANDI/ORI vs ADDI
  lw $t1,0x8000($gp)
  andi $s0,$t1,0x8001 # Actually 0x00008001 (zero-extended)
  ori $s1,$t1,0x8001 # Actually 0x00008001 (zero-extended)
  addi $s2,$t1,0x8001 # Should be 0xFFFF8001 (sign-extended), doesn't seem to work
  
.data
  d1: 0x00000001

## Dynamic data
#.text
#  
#  # Global pointer points to 0x10008000
#  # Add 0x8000 to base to read dynamic data into s1
#  lw $s1, 0x8000($gp)
#
#.data
#  # Dynamic data starts at 0x10010000
#  d1: 0x0000000f

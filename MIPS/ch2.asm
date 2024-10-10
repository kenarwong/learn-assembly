# R-Type
#add $t0,$s1,$s2

# I-Type
#lw $t0,32($s3)

# Dynamic data
.text
  
  # Global pointer points to 0x10008000
  # Add 0x8000 to base to read dynamic data into s1
  lw $s1, 0x8000($gp)

.data
  # Dynamic data starts at 0x10010000
  d1: 0x0000000f
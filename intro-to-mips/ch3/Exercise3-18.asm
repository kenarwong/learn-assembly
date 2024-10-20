# File:     Exercise3-18.asm
# Author:   Ken Hwang
# Purpose:  Constant vs immediate value

.text
.globl main

main:
  ori $t0, $zero, 0xffff  # immediate (from instruction)
                          # I-type instruction code
                          # Hex:        0x3408ffff
                          # Binary:     0011 0100 0000 1000 ffff ffff ffff ffff
                          # Decimal:    |13   ||0   ||8   | |65535            |
                          # Format:     |op   ||rs  ||rt  | |immediate        |
                          # Decode:     |ori  ||zero||$t0 | |0xffff           |

  or $t1, $zero, $t0      # constant (from register)
                          # R-type instruction code 
                          # Hex:        0x00084825
                          # Binary:     0000 0000 0000 1000 0100 1000 0010 0101
                          # Decimal:    |0    ||0   ||8   | |9   ||0    |37   |
                          # Format:     |op   ||rs  ||rt  | |rd  ||shamt|funct|
                          # Decode:     |or   ||zero||$t0 | |$t1 ||n/a  |or   |
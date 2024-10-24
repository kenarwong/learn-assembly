# File:     Exercise6-4.asm
# Author:   Ken Hwang
# Purpose:  

.text
main:
  lui $t0, 0x1001

  la $a0, MilesDisplay
  jal PromptInt
  move $s0, $v0
  sw $s0, 0($t0)

  la $a0, GallonsDisplay
  jal PromptInt
  move $s1, $v0
  sw $s1, 4($t0)

  # Convert to float
  mtc1.d $s0, $f0
  cvt.d.w $f0, $f0

  mtc1.d $s1, $f2
  cvt.d.w $f2, $f2

  # Miles / gallons
  div.d $f4, $f0, $f2 
  sdc1 $f4, 8($t0)

  # Print output 
  la $a0, MpgDisplay
  jal PrintString

  li $v0, 3
  mov.d $f12, $f4
  syscall

  jal Exit

.data
  .word parameters

  MilesDisplay:     .asciiz   "Enter the number of miles driven: "
  GallonsDisplay:   .asciiz   "Enter the gallons used: "
  MpgDisplay:       .asciiz   "Your mpg = "

  parameters:
                    .word     0
                    .word     0
                    .double   0

.include "utils.asm"
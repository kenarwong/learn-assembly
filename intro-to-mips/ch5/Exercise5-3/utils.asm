# File:     utils.asm
# Purpose:  Extract from utils.asm, to demonstrate infinite loop
# Author:   Ken Hwang

# subprogram:     PrintNewLine
# author:         Charles Kann
# purpose:        to output a new line to the user console
# input:          None
# output:         None
# side effects:   A new line character is printed to the
#                 user's console
.text
PrintNewLine:
  li $v0, 4
  la $a0, __PNL_newline
  syscall
  jr $ra
.data
  __PNL_newline: .asciiz "\n"

.text                       # missing .text directive
PrintTab:
  li $v0, 4
  # la $a0, tab
  la $a0, __PT_tab          # use unique naming scheme
  syscall
  jr $ra
.data
  # tab: .asciiz "\t"
  __PT_tab: .asciiz "\t"
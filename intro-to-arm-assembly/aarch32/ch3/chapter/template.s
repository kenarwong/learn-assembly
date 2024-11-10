#
# Program Name: template.s
# Author: Charles Kann
# Date: 9/19/2020
# Purpose: This program is template that can be used to start ARM assembly
# program using gcc
#

.text
.global main

main:
  # Save return to OS on stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

  # Enter your program here.

  # Return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
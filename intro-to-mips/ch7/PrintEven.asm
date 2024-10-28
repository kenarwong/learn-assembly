# Filename: PrintEven.asm
# Author: Charles Kann
# Date: 12/29/2013
# Purpose: Print even numbers from 1 to 10
# Modification Log:
# 12/29/2013 - Initial release
#
# Pseudo Code
# global main()
# {
#   // The following variable can be kept in a save register.
#   register int i
#
#   // Counter loop from 1 to 10
#   for (i = 1; i < 11; i++)
#   {
#     if ((i %2) == 0)
#     {
#       print("Even number: " + i)
#     }
#   }
# }

.text
.globl main
main:
  # Register Conventions:
  # $s0 - i
  addi $s0, $zero, 1

  BeginForLoop:
  addi $t0, $zero, 11
  slt $t0, $s0, $t0
  beqz $t0, EndForLoop
    addi $t0, $zero, 2
    div $s0,$t0
    mfhi $t0
    seq $t0, $t0, 0
    beqz $t0, Odd

      la $a0, result
      move $a1, $s0
      jal PrintInt
      jal NewLine

    Odd:
    addi $s0, $s0, 1
    b BeginForLoop
  EndForLoop:

  jal Exit
.data
  result: .asciiz "Even number: "
.include "utils.asm"
# File:     Program5-9.asm
# Author:   Charles Kann
# Purpose:  To illustrate implementing and calling a
#           subprogram named PrintNewLine.
.text
main:
  # read an input value from the user
  la $a0, prompt
  jal PromptInt
  move $s0, $v0

  # print the value back to the user
  jal PrintNewLine
  la $a0, result
  move $a1, $s0
  jal PrintInt

  # call the Exit subprogram to exit
  jal Exit
.data
  prompt: .asciiz "Please enter an integer: "
  result: .asciiz "You entered: "
.include "utils.asm"
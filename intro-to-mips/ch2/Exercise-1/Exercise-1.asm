# Program File: Exercise-1.asm
# Author: Ken Hwang
# Ask user favorite type of pie

.text
main:
  la $a0, msg
  li $v0, 4             # code for print string
  syscall

  la $a0, input         # address of input buffer in data
  lw $a1, length        # number of characters
  li $v0, 8             # code for read string
  syscall

  # need to concatenate strings
  la $a0, out           # allocated output space
  la $a1, out1          # source
  jal strcpy

  addi $a0, $v0, 1      # next start is 1 byte from current ending 
  la $a1, input         # source
  jal strcpy

  addi $a0, $v0, 1      # next start is 1 byte from current ending 
  la $a1, out2          # source
  jal strcpy

  la $a0, out
  li $v0, 4             # code for print string
  syscall

  li $v0, 10            # code for exit
  syscall

.data
  input:  .space    14                   
          .align 2
  length: .word     13
  msg:    .asciiz   "What kind of pie do you like?"
          .align 2
  out1:   .asciiz   "So you like "
          .align 2
  out2:   .asciiz   " pie\n"
          .align 2
  out:    .space    30
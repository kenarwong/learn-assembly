# Program File: Program2-1.asm
# Author: Ken Hwang
# Purpose: First program, Hello World

.data
  helloWorld: .asciiz "Hello world!"

.text
.globl main

main:
  la $a0, helloWorld    # load string
  li $v0, 4             # load return code to print $a0
  syscall

  li $v0, 10            # load return code to halt/exit
  syscall
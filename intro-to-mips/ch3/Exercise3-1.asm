# File:     Exercise3-1.asm
# Author:   Ken Hwang
# Purpose:  Execute real instructions versus pseudocodes

# a) add $t0, $t1, $t2
# b) add $t0, $t1, 100
# c) addi $t0, $t1, 100
# d) subi $t0, $t1, 100
# e) mult $t0, $t1
# f) mult $t0, $t1, $t2
# g) rol $t0, $t1, 3

# b, d, g

.text
.globl main

main:
  add $t0, $zero, $zero
  addi $t1, $zero, 2
  addi $t2, $zero, 4

  # Execute instruction a
  addi $v0, $zero, 4
  la $a0, a
  syscall
  
  add $t0, $t1, $t2

  addi $v0, $zero, 1
  move $a0, $t0
  syscall

  # Execute instruction b
  addi $v0, $zero, 4
  la $a0, b
  syscall

  add $t0, $t1, 100         # addi $t0, $t1, 100

  addi $v0, $zero, 1
  move $a0, $t0
  syscall

  # Execute instruction c
  addi $v0, $zero, 4
  la $a0, c
  syscall

  addi $t0, $t1, 100

  addi $v0, $zero, 1
  move $a0, $t0
  syscall

  # Execute instruction d
  addi $v0, $zero, 4
  la $a0, d
  syscall

  subi $t0, $t1, 100        # addi $at, $t1, 100
                            # sub $t0, $t1, $at

  addi $v0, $zero, 1
  move $a0, $t0
  syscall

  # Execute instruction e
  addi $v0, $zero, 4
  la $a0, e
  syscall

  mult $t0, $t1
  mflo $t0

  addi $v0, $zero, 1
  move $a0, $t0
  syscall

  # Execute instruction f
  addi $v0, $zero, 4
  la $a0, f
  syscall

  mul $t0, $t1, $t2
  mflo $t0

  addi $v0, $zero, 1
  move $a0, $t0
  syscall

  # Execute instruction g
  addi $v0, $zero, 4
  la $a0, g
  syscall

  rol $t0, $t1, 3           # srl $at, $t1, 32-3
                            # sll $t0, $t1, 3
                            # or $t0, $t0, $at

  addi $v0, $zero, 1
  move $a0, $t0
  syscall

  # Exit
  addi $v0, $zero, 10
  syscall

.data
  a: .asciiz "\na) add $t0, $t1, $t2\n"
  b: .asciiz "\nb) add $t0, $t1, 100\n"
  c: .asciiz "\nc) addi $t0, $t1, 100\n"
  d: .asciiz "\nd) subi $t0, $t1, 100\n"
  e: .asciiz "\ne) mult $t0, $t1\n"
  f: .asciiz "\nf) mul $t0, $t1, $t2\n"
  g: .asciiz "\ng) rol $t0, $t1, 3\n"
# File:     Exercise3-14.asm
# Author:   Ken Hwang
# Purpose:  addiu vs ori

.text
.globl main

main:
  addiu $t0, $zero, 60000           # lui $at, 0
                                    # ori $at, $at, 60000
                                    # addu $t0, $zero, $at
  ori $t0, $zero, 60000             

  # MIPS uses $at to create large constants
  # this is because the I-type instruction format
  # only leaves 16 bits for a constant or an address
  addiu $t0, $zero, 0x1ffff         # lui $at, 1
                                    # ori $at, $at, 0xffff

  # once the large constant is ready,
  # then addiu performs a proper addition with addu
  # this must propagate carry bit
  ori $t1, $zero, 1
  addiu $t0, $t1, 0xffff            # 0x01 + 0xffff = 0x10000

  # ori is faster, but
  # ori only flips bits 1/0 based on OR operation

  # to properly add, need to use chained full adder logic 
  ori $s0, $zero, 0xffff            # operand A
  ori $s1, $zero, 0x01              # operand B
  ori $s2, $zero, 0                 # result
  ori $s3, $zero, -1                # count
  ori $s4, $zero, 0                 # carry bit = 0

loop:
  andi $t0, $s3, 1                  # once LSB of count reaches 0
  beq $t0, $zero, exitloop          # exit loop

  andi $a0, $s0, 1                  # LSB of A
  andi $a1, $s1, 1                  # LSB of B
  or $a2, $zero, $s4                # carried bit
  jal binaryadd

  or $s2, $s2, $v0                  # place result
  ror $s2, $s2, 1                   # rotate digits
  or $s4, $zero, $v1                # retrieve carry bit

  srl $s0, $s0, 1                   # shift A to next digit
  srl $s1, $s1, 1                   # shift B to next digit

  srl $s3, $s3, 1                   # shift counter

  j loop

binaryadd:
  or $t0, $zero, $a0               # bit A
  or $t1, $zero, $a1               # bit B 
  or $t2, $zero, $a2               # carry

  # Ci: odd function
  xor $t3, $t0, $t1                 # first digit
  xor $t3, $t3, $t2                 # first digit XOR carry

  # Ci+1: generate (G) or propagate (P)
  and $t4, $t0, $t1                 # G = A * B 
  or  $t5, $t0, $t1                 # A + B
  and $t5, $t2, $t5                 # P = Ci * (A + B)
  or $t6, $t5, $t4                  # Ci+1 = G + P

  move $v0, $t3
  move $v1, $t6

  jr $ra

exitloop:

  # $s2 = 0x10000

  # Exit
  addi $v0, $zero, 10
  syscall

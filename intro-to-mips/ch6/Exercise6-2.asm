# File:     Exercise6-2.asm
# Author:   Ken Hwang
# Purpose:  Demonstrating MIPS boundary types

.text
main:
  la $s0, 0x10010000            # Base

  li $t0, -1
  l.d $f0, fp

  # 0x10010011
  sb $t0, 0x0011($s0)           # Byte: yes
  # sh $t0, 0x0011($s0)           # Half: no
  # sw $t0, 0x0011($s0)           # Word: no
  # s.d $t0, 0x0011($s0)          # Double: no

  # 0x10010100
  sb $t0, 0x0100($s0)           # Byte: yes
  sh $t0, 0x0100($s0)           # Half: yes
  sw $t0, 0x0100($s0)           # Word: yes
  sdc1 $f0, 0x0100($s0)         # Double: yes

  la $s1, 0x10050100            # Base

  # 0x10050108
  sb $t0, 0x0008($s1)           # Byte: yes
  sh $t0, 0x0008($s1)           # Half: yes
  sw $t0, 0x0008($s1)           # Word: yes
  sdc1 $f0, 0x0008($s1)         # Double: yes

  # 0x1005010c
  sb $t0, 0x000c($s1)           # Byte: yes
  sh $t0, 0x000c($s1)           # Half: yes
  sw $t0, 0x000c($s1)           # Word: yes
  # sdc1 $f0, 0x000c($s1)         # Double: no

  # 0x1005010d
  sb $t0, 0x000d($s1)           # Byte: yes
  # sh $t0, 0x000d($s1)           # Half: no
  # sw $t0, 0x000d($s1)           # Word: no
  # sdc1 $f0, 0x000d($s1)         # Double: no

  # 0x1005010e
  sb $t0, 0x000e($s1)           # Byte: yes
  sh $t0, 0x000e($s1)           # Half: yes
  # sw $t0, 0x000e($s1)           # Word: no
  # sdc1 $f0, 0x000e($s1)         # Double: no

  # 0x1005010f
  sb $t0, 0x000f($s1)           # Byte: yes
  # sh $t0, 0x000f($s1)           # Half: no
  # sw $t0, 0x000f($s1)           # Word: no
  # sdc1 $f0, 0x000f($s1)         # Double: no

  la $s1, 0x10070100            # Base

  # 0x10070104
  sb $t0, 4($s1)                # Byte: yes
  sh $t0, 4($s1)                  # Half: yes
  sw $t0, 4($s1)                  # Word: yes
  # sdc1 $f0, 4($s1)              # Double: no

  li $v0, 10
  syscall

.data
  fp:   .double 1.1

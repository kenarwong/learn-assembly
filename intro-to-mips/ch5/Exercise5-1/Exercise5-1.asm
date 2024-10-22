# File:     Exercise5-1.asm
# Author:   Ken Hwang
# Purpose:  Program to test Exercise5-1-utils.asm

.text
.globl main

main:
  # Test ToUpperUtil
  lw $a0, ToUpperUtilTest1String
  jal ToUpperUtil
  sw $a0, ToUpperUtilTest1String
  la $a0, ToUpperUtilTest1String
  jal PrintString
  jal PrintNewLine

  lw $a0, ToUpperUtilTest2String
  jal ToUpperUtil
  sw $a0, ToUpperUtilTest2String
  la $a0, ToUpperUtilTest2String
  jal PrintString
  jal PrintNewLine

  lw $a0, ToUpperUtilTest3String
  jal ToUpperUtil
  sw $a0, ToUpperUtilTest3String
  la $a0, ToUpperUtilTest3String
  jal PrintString
  jal PrintNewLine

  # Test ToLowerUtil
  la $a0, ToLowerUtilTest1String
  jal ToLowerUtil
  sw $a0, ToLowerUtilTest1String
  la $a0, ToLowerUtilTest1String
  jal PrintString
  jal PrintNewLine

  la $a0, ToLowerUtilTest2String
  jal ToLowerUtil
  sw $a0, ToLowerUtilTest2String
  la $a0, ToLowerUtilTest2String
  jal PrintString
  jal PrintNewLine

  la $a0, ToLowerUtilTest3String
  jal ToLowerUtil
  sw $a0, ToLowerUtilTest3String
  la $a0, ToLowerUtilTest3String
  jal PrintString
  jal PrintNewLine

  j Exit

PrintString:
  li $v0, 4
  syscall
  jr $ra

PrintNewLine:
  li $v0, 4
  la $a0, __PNL_newline
  syscall
  jr $ra

Exit:
  li $v0, 10
  syscall

.data
  ToUpperUtilTest1String:   .asciiz "AAA"
  ToUpperUtilTest2String:   .asciiz "aaa"
  ToUpperUtilTest3String:   .asciiz "aAa"
  ToLowerUtilTest1String:   .asciiz "AAA"
  ToLowerUtilTest2String:   .asciiz "aaa"
  ToLowerUtilTest3String:   .asciiz "aAa"
  __PNL_newline:            .asciiz "\n"
.include "Exercise5-1-utils.asm"
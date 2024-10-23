# File:     Exercise5-1.asm
# Author:   Ken Hwang
# Purpose:  Program to test Exercise5-1-utils.asm

.text
.globl main

main:
  # Test NorUtil
  la $a0, NorUtilTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, 0
  li $a1, 0
  jal NorUtil
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine

  # Test NandUtil
  la $a0, NandUtilTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, -1
  li $a1, -1
  jal NandUtil
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine

  # Test NotUtil
  la $a0, NotUtilTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, -1
  jal NotUtil
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine

  li $a0, 0
  jal NotUtil
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine
  
  # Test Mult4Util
  la $a0, Mult4UtilTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, 5
  jal Mult4Util
  move $a0, $v0
  jal PrintInt
  jal PrintNewLine

  # Test Mult10Util
  la $a0, Mult10UtilTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, 7
  jal Mult10Util
  move $a0, $v0
  jal PrintInt
  jal PrintNewLine

  # Test SwapUtil
  la $a0, SwapUtilTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, 10
  li $a1, 5
  jal SwapUtil
  move $a0, $v0
  jal PrintInt
  jal PrintNewLine
  move $a0, $v1
  jal PrintInt
  jal PrintNewLine

  # Test RightCircularShift
  la $a0, RightCircularShiftTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, 1
  jal RightCircularShift
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine
  move $a0, $v1
  jal PrintInt
  jal PrintNewLine

  li $a0, 0xfffffffe
  jal RightCircularShift
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine
  move $a0, $v1
  jal PrintInt
  jal PrintNewLine

  # Test LeftCircularShift
  la $a0, LeftCircularShiftTestTitle
  jal PrintString
  jal PrintNewLine

  li $a0, 0x80000000
  jal LeftCircularShift
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine
  move $a0, $v1
  srl $a0, $v1, 0x1f        # Formatting for PrintInt, moving left-most bit to right-most digit
  jal PrintInt
  jal PrintNewLine

  li $a0, 0x7fffffff
  jal LeftCircularShift
  move $a0, $v0
  jal PrintBinary
  jal PrintNewLine
  move $a0, $v1
  jal PrintInt
  jal PrintNewLine

  # Test ToUpperUtil
  la $a0, ToUpperUtilUtilTestTitle
  jal PrintString
  jal PrintNewLine

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
  la $a0, ToLowerUtilTestTitle
  jal PrintString
  jal PrintNewLine

  lw $a0, ToLowerUtilTest1String
  jal ToLowerUtil
  sw $a0, ToLowerUtilTest1String
  la $a0, ToLowerUtilTest1String
  jal PrintString
  jal PrintNewLine

  lw $a0, ToLowerUtilTest2String
  jal ToLowerUtil
  sw $a0, ToLowerUtilTest2String
  la $a0, ToLowerUtilTest2String
  jal PrintString
  jal PrintNewLine

  lw $a0, ToLowerUtilTest3String
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

PrintInt:
  li $v0, 1
  syscall
  jr $ra

PrintBinary:
  li $v0, 35
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
  ToUpperUtilTest1String:       .asciiz "AAA"
  ToUpperUtilTest2String:       .asciiz "aaa"
  ToUpperUtilTest3String:       .asciiz "aAa"
  ToLowerUtilTest1String:       .asciiz "BBB"
  ToLowerUtilTest2String:       .asciiz "bbb"
  ToLowerUtilTest3String:       .asciiz "bBb"
  __PNL_newline:                .asciiz "\n"
  NorUtilTestTitle:             .asciiz "Testing NorUtil"
  NandUtilTestTitle:            .asciiz "Testing NandUtil"
  NotUtilTestTitle:             .asciiz "Testing NotUtil"
  Mult4UtilTestTitle:           .asciiz "Testing Mult4Util"
  Mult10UtilTestTitle:          .asciiz "Testing Mult10Util"
  SwapUtilTestTitle:            .asciiz "Testing SwapUtil"
  RightCircularShiftTestTitle:  .asciiz "Testing RightCircularShift"
  LeftCircularShiftTestTitle:   .asciiz "Testing LeftCircularShift"
  ToUpperUtilUtilTestTitle:     .asciiz "Testing ToUpperUtil"
  ToLowerUtilTestTitle:         .asciiz "Testing ToLowerUtil"

.include "Exercise5-1-utils.asm"
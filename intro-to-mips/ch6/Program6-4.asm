# Register indirect access
# No labels

.text
.globl main
main:
  # Get input value and store it in $s0
  la $a0, prompt
  jal PromptInt
  move $s0, $v0

  # Load constants a, b, and c into registers
  lui $t0, 0x1001       # Starts from know static memory address
  lw $t5, 0($t0)
  addi $t0, $t0, 4
  lw $t6, 0($t0)
  addi $t0, $t0, 4
  lw $t7, 0($t0)

  # Calculate the result of y=a*x*x + b * x + c and store it.
  mul $t0, $s0, $s0
  mul $t0, $t0, $t5
  mul $t1, $s0, $t6
  add $t0, $t0, $t1
  add $s1, $t0, $t7

  # Print output from memory y
  la $a0, result
  move $a1, $s1
  jal PrintInt
  jal PrintNewLine

  #Exit program
  jal Exit

.data
  .word 5               # 0x1001
  .word 2               # 0x1001 + 4
  .word 3               # 0x1001 + 8
  y: .word 0
  prompt: .asciiz "Enter a value for x: "
  result: .asciiz "The result is: "
.include "utils.asm"
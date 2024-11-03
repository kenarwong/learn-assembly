.text
.globl main
main:
  jal BadSubprogram

  la $a0, string3
  jal PrintString

  jal Exit

BadSubprogram:
  la $a0, string1
  jal PrintString

  li $v0, 4
  la $a0, string2
  syscall
  jr $ra

.data
string1: .asciiz "\nIn subprogram BadSubprogram\n"
string2: .asciiz "After call to PrintString\n"
string3: .asciiz "After call to BadSubprogram\n"
.include "utils.asm"
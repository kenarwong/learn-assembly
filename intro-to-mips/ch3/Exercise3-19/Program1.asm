.text
main:
  li $v0, 4
  la $a0, result1
  syscall
  li $v0, 1
  li $a0, 4
  syscall

  li $v0, 4
  la $a0, result2
  syscall
  li $v0, 1
  li $a0, 8
  syscall

  addi $v0, $zero, 10 #Exit program
  syscall

.data
  # result1: .ascii "\nfirst value = "
  result1: .asciiz "\nfirst value = "
  # result2: .ascii "\nsecond value = "
  result2: .asciiz "\nsecond value = "
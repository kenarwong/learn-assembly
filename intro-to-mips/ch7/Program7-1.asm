# if (num > 0)
# {
#   print("Number is positive")
# }

.text
main:
  lw $t0 num
  bgtz $t0, printPositive

  j Exit

printPositive:
  li $v0, 4
  la $a0, printText
  syscall

Exit:
  li $v0, 10
  syscall

.data
  num:          .word   -1
  printText:    .asciiz "Number is positive"
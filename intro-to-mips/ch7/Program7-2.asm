# if ((x > 0 && ((x%2) == 0)) # is x > 0 and even?

.text
main:
  lw $t0, x
  sgt $t1, $t0, $zero
  rem $t2, $t0, 2
  seq $t2, $t2, $zero   # missing check if equal to 0 (which is true condition), otherwise a remainder of 0 would be false
  and $t1, $t1, $t2
  beqz $t1, Exit

  jal printEven
  j Exit

printEven:
  li $v0, 4
  la $a0, printText
  syscall

Exit:
  li $v0, 10
  syscall

.data
  x:          .word   6
  printText:    .asciiz "Number is even"
# if ((x > 0) && ((x%2) == 0) && (x < 10)) # is 0 < x < 10 and even?

.text
main:
  lw $t0, x
  sgt $t1, $t0, $zero
  li $t5, 10
  slt $t2, $t0, $t5
  rem $t3, $t0, 2
  seq $t3, $t3, $zero   # missing check if remainder is equal to 0 (which is true condition), otherwise a remainder of 0 would be false
  and $t1, $t1, $t2
  and $t1, $t1, $t3
  beqz $t1, end_if

  jal conditionTrue
  j Exit

conditionTrue:
  li $v0, 4
  la $a0, printText
  syscall

end_if:
  jal Exit

Exit:
  li $v0, 10
  syscall

.data
  x:            .word   6
  printText:    .asciiz "Condition is true"
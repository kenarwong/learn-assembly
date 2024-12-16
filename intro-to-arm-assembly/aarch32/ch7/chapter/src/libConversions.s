.global inches2Ft
.text
inches2Ft:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  MOV r3, #10
  MUL r0, r0,r3
  MOV r1, #12
  bl __aeabi_idiv
  #answer is returned in r0

  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
#END inches2Ft


.text
.global main

main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  MOV r1, r2
  MOV r1, #3, 4
  MOV r1, r2, lsl #3
  MOV r1, r2, asr r3

  MUL r1, r2, r3

  ldr r1, [r2, #12]
  str r1, [r2, r3, lsl #2]

  ADD r1, r2, r3
  MOV r1, r2, lsl #3

  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
.data

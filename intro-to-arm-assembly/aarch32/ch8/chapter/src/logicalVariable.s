  .text
  .global main

main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  MOV r0, #0x32
  BL convertToInt

  LDR lr, [sp, #0]
  ADD sp, sp, #4
  mov r0, #0
  MOV pc, lr
# End main

convertToInt:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  MOV r4, #0
  MOV r1, #0x30
  CMP r0, r1
  MOVGT r4, #1

  MOV r5, #0
  MOV r1, #0x39
  CMP r0, r1
  MOVLT r5, #1

  AND r4, r4, r5

  MOV r1, #0
  CMP r4, r1
  BEQ Else
    SUB r0, r0, #0x30
    B EndIf

  Else:
    ldr r0, =output
    BL printf

  EndIf:
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    mov r0, #0
    MOV pc, lr
.data
  output: .asciz "NAN\n"

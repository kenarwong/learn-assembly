.text
.global main
main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  MOV r2, #92
  MOV r1, #0
  CMP r2, r1
  BLE EndIf
    LDR r0, =IsPositive
    BL printf
  EndIf:

  LDR lr, [sp, #0]
  ADD sp, sp, #4
  mov r0, #0
  MOV pc, lr

.data
  IsPositive: .asciz "Number is Positive\n"

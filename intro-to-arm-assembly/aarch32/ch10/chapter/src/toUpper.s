  .global toUpper
  .global main
  .text
toUpper:
  #push stack
  SUB sp, sp, #12
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]

  # Save Base Array and Size to preserved registers
  MOV r4, r0

  # initialize loop for entering data
  # r4 - element address
  # r5 - constant null
  MOV r5, #0

  startLoop:
    LDRB r1, [r4, #0]
    CMP r1, r5
    BEQ endLoop

    AND r1, r1, #0xdf
    STRB r1, [r4], #1
    B startLoop
  endLoop:

  #pop stack
  LDR lr, [sp, #0]
  LDR r4, [sp, #4]
  LDR r5, [sp, #8]
  ADD sp, sp, #12
  MOV pc, lr
  
.data

#end printArrayByIndex

# Main procedure to test printArrayByIndex
  .text
main:
  #push stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

  # load string
  LDR r0, =prompt
  BL printf
  MOV r0, #40
  BL malloc
  MOV r5, r0
  MOV r1, r0
  LDR r0, =format
  BL scanf

  MOV r0, r5
  BL toUpper

  # reload base and call function
  LDR r0, =output
  MOV r1, r5
  BL printf

  #pop stack
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  mov r0, #0
  MOV pc, lr

.data
  prompt: .asciz "Enter input string: "
  output: .asciz "\nYour string is %s\n"
  format: .asciz "%s"

  .section  .note.GNU-stack,"",%progbits

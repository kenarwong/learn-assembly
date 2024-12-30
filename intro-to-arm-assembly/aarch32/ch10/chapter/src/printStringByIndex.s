  .global printStringByIndex
  .global main

  .text
printStringByIndex:
  #push stack
  SUB sp, sp, #12
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]

  # Save Base Array to preserved register
  MOV r4, r0

  # initialize loop for entering data
  # r4 - array base
  # r5 - loop index

  MOV r5, #0
  startPrintLoop:
    MOV r0, #0
    LDRB r1, [r4, r5]
    CMP r0, r1
    BEQ endPrintLoop

    LDR r0, =output
    MOV r1, r5
    ADD r2, r4, r5 // Calculate the array address
    LDRB r2, [r2, #0]
    BL printf

    ADD r5,r5, #1
    B startPrintLoop
  endPrintLoop:

  #pop stack
  LDR lr, [sp, #0]
  LDR r4, [sp, #4]
  LDR r5, [sp, #8]
  ADD sp, sp, #12
  MOV pc, lr

.data
  output: .asciz "The value for element [%d] is %c\n"

#end printStringByIndex

# Main procedure to test printArrayByIndex
  .text
main:
  #push stack
  SUB sp, sp, #44
  STR lr, [sp, #0]
  # string is at sp+4 ... s+43

  # load string
  LDR r0, =prompt
  BL printf
  LDR r0, =format
  ADD r1, sp, #4
  BL scanf

  # reload base and call function
  ADD r0, sp, #4
  BL printStringByIndex

  #pop stack
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  mov r0, #0
  MOV pc, lr

.data
  prompt: .asciz "Enter input string: "
  format: .asciz "%s"

  .section  .note.GNU-stack,"",%progbits

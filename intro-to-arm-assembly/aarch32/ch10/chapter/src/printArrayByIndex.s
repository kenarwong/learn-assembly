  .global printArrayByIndex
  .global main

  .text
printArrayByIndex:

  #push stack
  SUB sp, sp, #16
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
  STR r6, [sp, #12]

  # Save Base Array and Size to preserved registers
  MOV r4, r0
  MOV r5, r1

  # initialize loop for entering data
  # r4 - array base
  # r5 - end loop index
  # r6 - loop index

  MOV r6, #0
  startPrintLoop:
    CMP r6, r5
    BGE endPrintLoop

    LDR r0, =output
    MOV r1, r6
    ADD r2, r4, r6, lsl #2
    LDR r2, [r2, #0]
    BL printf

    ADD r6,r6, #1
    B startPrintLoop
  endPrintLoop:

  #pop stack
  LDR lr, [sp, #0]
  LDR r4, [sp, #4]
  LDR r5, [sp, #8]
  LDR r6, [sp, #12]
  ADD sp, sp, #16
  MOV pc, lr

.data
  output: .asciz "The value for element [%d] is %d\n"

#end printArrayByIndex

# Main procedure to test printArrayByIndex
  .text
main:
  #push stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

  LDR r0, =myArray
  LDR r1, =arrSize
  LDR r1, [r1]
  BL printArrayByIndex

  #pop stack
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  mov r0, #0
  MOV pc, lr

.data
  myArray:  .word 55
            .word 21
            .word 78
            .word 19
  arrSize:  .word 4

  .section  .note.GNU-stack,"",%progbits

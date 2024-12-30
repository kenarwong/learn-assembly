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

    LDR r0, =printOutput
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
  printOutput: .asciz "The value for element [%d] is %d\n"

#end printArrayByIndex

  .text

# This is Call by Reference Variable (aka Call by Reference Type)
# Parameters are base array, and index offsets. 
SwapByRefType:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  ADD r1, r0, r1, lsl #2
  ADD r2, r0, r2, lsl #2

  LDR r0, [r1, #0]
  LDR r3, [r2, #0]
  STR r0, [r2, #0]
  STR r3, [r1, #0]

  # pop stack and return
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data

#END SwapByRefType

  .text
  .global main

main:
  # Save return to os on stack
  SUB sp, sp, #16
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
  STR r6, [sp, #12]

  # Call PrintArray with the ar
  LDR r0, =output
  BL printf
  LDR r0, =ar
  LDR r1, =size
  LDR r1, [r1, #0]
  BL printArrayByIndex
  LDR r0, =newline
  BL printf

  # Reverse Array using SwapByRef
  #initialize loop
  LDR r4, =ar     @ r4 is the base of the array
  LDR r7, =size
  LDR r7, [r7, #0]
  SUB r7, r7, #1  @ -1 for array index
  ASR r5, r7, #1  @ r5 is the loop limit, or or size by 2
  MOV r6, #0      @ r6 is counter

  startMoveLoop:
  # Check end condition
  CMP r6, r5
  # BGE endMoveLoop               @ logic doesn't work with even numbers
  BGT endMoveLoop               @ Fixed logic

    MOV r0, r4
    MOV r1, r6
    SUB r2, r7, r6
    BL SwapByRefType

  # next iteration
  ADD r6, r6, #1
  b startMoveLoop
  endMoveLoop:

  # Call PrintArray with the ar
  LDR r0, =output
  BL printf
  LDR r0, =ar
  MOV r1, #5                    @ hard-coded size?
  BL printArrayByIndex
  LDR r0, =newline
  BL printf

  # Return to the OS
  LDR lr, [sp, #0]
  LDR r4, [sp, #4]
  LDR r5, [sp, #8]
  LDR r6, [sp, #12]
  ADD sp, sp, #16
  mov r0, #0
  MOV pc, lr

.data
  output: .asciz "The array is : \n"
  newline: .asciz "\n"
  # the variable ar id an array of 5 elments
  size: .word 5
  # size: .word 4
  ar:   .word 15
        .word 1
        .word 27
        .word 9
        .word 16

#END main

  .section  .note.GNU-stack,"",%progbits

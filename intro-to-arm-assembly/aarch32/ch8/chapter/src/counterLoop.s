  .text
  .global main
main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  # Prompt for loop limit, store in r4
  LDR r0, =prompt
  BL printf
  LDR r0, =input
  LDR r1, =num
  BL scanf
  LDR r1, =num
  LDR r4, [r1, #0]

  # initialize the loop,
  # r0 - counter
  # r4 - loop limit
  # r5 - sum

  MOV r0, #0
  MOV r5, #0

  StartCountingLoop:
  CMP r4, r0
  BLE EndCountingLoop

    # Loop Block
    ADD r5, r5, r0

    # Get next value
    ADD r0, r0, #1

    B StartCountingLoop

  EndCountingLoop:

  LDR r0, =output
  MOV r1, r5
  BL printf

  MOV r0, #0
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
# End main

.data
  prompt: .asciz "Please enter the loop limit to sum \n"
  output: .asciz "The summation from 1 to n is %d\n"
  input: .asciz "%d"
  num: .word 0
  .text
  .global main
main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  MOV r0, #-0x32

  # initialize by prompting user, answer in r4
  LDR r0, =prompt
  BL printf
  LDR r0, =input
  LDR r1, =num1
  BL scanf
  LDR r1, =num1
  LDR r4, [r1, #0]

StartSentinelLoop:
  MOV r0, #-1
  CMP r4, r0
  BEQ EndSentinelLoop

    # Loop Block
    LDR r0, =output
    MOV r1, r4
    BL printf

    # Get next value
    LDR r0, =prompt
    BL printf
    LDR r0, =input
    LDR r1, =num1
    BL scanf
    LDR r1, =num1
    LDR r4, [r1, #0]

    B StartSentinelLoop

EndSentinelLoop:

  LDR lr, [sp, #0]
  ADD sp, sp, #4
  mov r0, #0
  MOV pc, lr
# End main

.data
  prompt: .asciz "Please enter a number (-1 to end) \n"
  output: .asciz "You entered %d\n"
  input: .asciz "%d"
  num1: .word 0

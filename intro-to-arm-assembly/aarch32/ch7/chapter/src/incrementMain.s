.global main
main:
  # Save return to os on stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

  # Prompt for and read input
  LDR r0, =promptForNumber
  BL printf
  LDR r0, =inputNumber
  LDR r1, =numToInc
  BL scanf

  # Increment numToInc by calling increment
  LDR r0, =numToInc
  LDR r0, [r0, #0]
  Bl increment

  # Printing the answer
  MOV r1, r0
  LDR r0, =formatOutput
  BL printf

  # Return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV r0, #0          @ Return 0
  MOV pc, lr

.data
  promptForNumber: .asciz "Enter the number you want to increment: \n"
  formatOutput: .asciz "\nThe input + 1 is %d\n"
  inputNumber: .asciz "%d"
  numToInc: .word 0
#end main
.text
#function increment
increment:
  ADD r0, r0, #1
  MOV pc, lr
#end increment

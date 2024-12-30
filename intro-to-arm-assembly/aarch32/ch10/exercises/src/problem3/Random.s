# Calculate a random number
# arguments:  r0 - seed (if seed is 0, get next random value)
#             r1 - range (from 1 to r1). If r1 is 0 or negative,
#             range is all ints)
#
Random:
  SUB sp, sp, #8
  # Save return to os on stack
  STR lr, [sp, #0] @ Prompt For An Input
  STR r4, [sp, #4]

#
  MOV r3, #0
  CMP r0, r3
  BNE Reset
    LDR r0, =seed @ get the seed
    LDR r0, [r0, #0]
  Reset:
  
  ADD r0, r0, #137  @ get the next seed
  EOR r0, r0, r0, ror #13
  LSR r0, r0, #1    @ make sure it is positive
  MOV r4, r0        @ save the value to r4

  # Get the remainder
  MOV r3, #0
  CMP r1, r3
  BLE NoRange
    BL __aeabi_idiv
    MUL r1, r0, r1
    SUB r4, r4, r1
  NoRange:

  # Save the seed to memory
    LDR r0,=seed
    STR r4,[r0, #0]

  # Return to the OS
    MOV r0, r4
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    ADD sp, sp, #8
    MOV pc, lr

.data
  seed: .word 25

#end Random

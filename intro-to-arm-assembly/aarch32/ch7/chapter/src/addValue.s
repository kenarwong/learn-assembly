.global main
main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  MOV r0, #5
  BL addValue

  MOV r1, r0
  LDR r0, =output
  BL printf

  MOV r0, #0
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
.data
  output: .asciz "Your answer is %d\n"

.text
# function addValue
addValue:
  SUB sp, sp, #8
  STR lr, [sp,#0]
  STR r4, [sp, #4]      // r4 will be used to save r0, so store the
                        // original value to stack
  MOV r4, r0            // Save r0 in r4

  LDR r0, =prompt
  BL printf
  LDR r0, =inputFormat
  LDR r1, =inputNum
  BL scanf
  LDR r1, =inputNum
  LDR r0, [r1, #0]
  ADD r0, r4

  LDR r4, [sp, #4]
  LDR lr, [sp, #0]
  ADD sp, sp, #8
  MOV pc, lr
.data
  inputNum: .word 0
  prompt: .asciz "Enter input number: "
  inputFormat: .asciz "%d"

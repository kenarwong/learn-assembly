.text
  .global main
main:
  # Save return to os on stack
  sub sp, sp, #4
  str lr, [sp, #0]

  mov r0, #10
  bl Summation
  mov r1, r0
  ldr r0, =output
  bl printf

  # Return to the OS
  ldr lr, [sp, #0]
  add sp, sp, #4
  mov pc, lr
.data
  output: .asciz "Summation is %d\n"

.text
# Note: Summation is NOT a global symbol!
# It is a static function
Summation:
  #push stack. Save r0 (summation) in r10,
  # so r10 has to be saved by callee convention
  sub sp, sp, #8
  str lr, [sp, #0]
  str r4, [sp, #4]
  mov r4, r0

  # if r0 is 0, return 0
  mov r1, #0
  cmp r1, r4
  moveq pc, lr @ return 0 in r0
               @ for base case, r4 is not loaded back (r4 = 0)

  add r0, r4, #-1
  bl Summation @ return value in r0
  add r0, r4, r0 @ return summation in r0
                 @ for the caller of the base case (depth n-1)
                 @  (i.e. first execution after base case)
                 @  r4 is not loaded back so,
                 @  not doing correct summation, (base case + base case, e.g. 0+0)
                 @ correct summary is [base case + recursive caller]
  b return @ not really needed

  # pop stack and return
  return:       @ this is not run at base case (depth n), and sp was not restored
                @ the caller of the base case execution (depth n-1)
                @   will erroneously pop the execution context of the base case
                @ the bottom-most execution context will (depth 1)
                @   pop execution context for (depth 2)
                @ an additional context will be run that will 
                @   pop execution context of depth 1
                @   which will then return to the main function
  ldr lr, [sp, #0]
  ldr r4, [sp, #4]
  add sp, sp, #8
  mov pc, lr
#END Summation

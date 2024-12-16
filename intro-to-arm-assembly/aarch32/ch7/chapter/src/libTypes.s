# FileName: libTypes.s
# Author: Chuck Kann
# Date: 1/14/2021
# Purpose: Function for use on types
#
# Types defined and functions:
# printScaledInt
#
# Changes: 1/14/2021 - Initial release
.global printScaledInt

# Function: printScaledInt
# Purpose:  to print a scaled integer value
#           with the decimal point in the
#           correct place
#
# Input:    r0 - value to print
#           r1 - scale in
#
# Output:   r0 - pointer to string that contains
#             the converted value
.text
printScaledInt:
  # push
  SUB sp, #12
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
  MOV r4, r0
  MOV r5, r1

  # get whole part and save in r7
  bl __aeabi_idiv // r0/r1, result in r0
  MOV r6, r0

  #get decimal part and save in r7
  MUL r7, r5, r6
  SUB r7, r4, r7

  # print the whole part
  LDR r0, = __PSI_format
  MOV r1, r6
  bl printf

  # print the dot
  LDR r0, = __PSI_dot
  bl printf

  # print the decimal part
  LDR r0, = __PSI_format
  MOV r1, r7
  bl printf

  # pop and return
  LDR r5, [sp, #8]
  LDR r4, [sp, #4]
  LDR lr, [sp, #0]
  ADD sp, #12
  MOV pc, lr

.data
  __PSI_format: .asciz "%d"
  __PSI_dot: .asciz "."
#end printScaledInt

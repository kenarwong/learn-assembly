# File:     Exercise5-1-utils.asm
# Purpose:  To define utilities which will be used in MIPS programs.
# Author:   Ken Hwang
#
# Subprograms Index:
#   NorUtil -                 Return NOR operation on two parameters
#   NandUtil -                Return NAND operation on two parameters
#   NotUtil -                 Return NOT operation on one parameter
#   Mult4Util -               Multiply a parameter by 4
#   Mult10Util -              Multiply a parameter by 10
#   SwapUtil -                Swap two input parameters
#   RightCircularShiftUtil -  Rotate a parameter right by 1 bit
#                             Returns 1) value that has been shifted
#                             Retursn 2) value of bit that has been shifted
#   LeftCircularShiftUtil -   Rotate a parameter left by 1 bit
#                             Returns 1) value that has been shifted
#                             Returns 2) value of bit that has been shifted
#   ToUpperUtil -             Convert a 3 character, null terminated ASCII string to upper case
#   ToLowerUtil -             Convert a 3 character, null terminated ASCII string to lower case

# subprogram:     NorUtil
# author:         Ken Hwang
# purpose:        Take two input parameters, and 
#                 return the NOR operation on those two parameters.
# input:          $a0 - First value
#                 $a1 - Second value
# returns:        $v0 - The result of the operation
# side effects:   None
.text
NorUtil:
  nor $v0, $a0, $a1

  jr $ra

# subprogram:     NandUtil
# author:         Ken Hwang
# purpose:        Take two input parameters, and 
#                 return the NAND operation on those two parameters.
# input:          $a0 - First value
#                 $a1 - Second value
# returns:        $v0 - The result of the operation
# side effects:   None
.text
NandUtil:
  and $v0, $a0, $a1
  nor $v0, $v0, $zero

  jr $ra

# subprogram:     NotUtil
# author:         Ken Hwang
# purpose:        Take one input parameter, and 
#                 return the NOT operation on that parameter.
# input:          $a0 - First value
# returns:        $v0 - The result of the operation
# side effects:   None
.text
NotUtil:
  nor $v0, $a0, $zero

  jr $ra

# subprogram:     Mult4Util
# author:         Ken Hwang
# purpose:        Take an input parameter, and 
#                 return that parameter multiplied by 4
#                 using only shift and add operations.
# input:          $a0 - First value
# returns:        $v0 - The result of the operation
# side effects:   None
.text
Mult4Util:
  sll $v0, $a0, 2

  jr $ra

# subprogram:     Mult10Util
# author:         Ken Hwang
# purpose:        Take an input parameter, and 
#                 return that parameter multiplied by 10
#                 using only shift and add operations.
# input:          $a0 - First value
# returns:        $v0 - The result of the operation
# side effects:   None
.text
Mult10Util:
  sll $t0, $a0, 1
  sll $v0, $a0, 3
  add $v0, $v0, $t0

  jr $ra

# subprogram:     SwapUtil
# author:         Ken Hwang
# purpose:        take two input parameters, 
#                 swap them using only the XOR operation
# input:          $a0 - First value
#                 $a1 - First value
# returns:        $v0 - The result of the operation
# side effects:   None
.text
SwapUtil:
  xor $t0, $a0, $a1
  xor $v0, $a0, $t0
  xor $v1, $a1, $t0

  jr $ra

# subprogram:     RightCircularShift
# author:         Ken Hwang
# purpose:        take an input parameter, and return two values. 
#                 The first is the value that has been shifted 
#                 1 bit using a right circular shift, and
#                 the second is the value of the bit which has been shifted.
# input:          $a0 - First value
# returns:        $v0 - The result of the operation
# returns:        $v1 - The value of the LSB before rotated right
# side effects:   None
.text
RightCircularShift:
  andi $v1, $a0, 1
  ror $v0, $a0, 1

  jr $ra

# subprogram:     LeftCircularShift
# author:         Ken Hwang
# purpose:        take an input parameter, and return two values. 
#                 The first is the value that has been shifted 
#                 1 bit using a left circular shift, and
#                 the second is the value of the bit which has been shifted.
# input:          $a0 - First value
# returns:        $v0 - The result of the operation
# returns:        $v1 - The value of the MSB before rotated left
# side effects:   None
.text
LeftCircularShift:
  andi $v1, $a0, 0x8000
  rol $v0, $a0, 1

  jr $ra

# subprogram:     ToUpperUtil
# author:         Ken Hwang
# purpose:        take a 32 bit input which is 3 characters and a null, 
#                 or a 3 character string. 
#                 Convert the 3 characters to upper case if they are lower case, 
#                 or do nothing if they are already upper case.
# input:          $a0 - ASCII, null-terminated word 
# returns:        None
# side effects:   String converted to upper case
.text
ToUpperUtil:
  andi $a0, $a0, 0x00dfdfdf

  jr $ra

# subprogram:     ToLowerUtil
# author:         Ken Hwang
# purpose:        take a 32 bit input which is 3 characters and a null, 
#                 or a 3 character string. 
#                 Convert the 3 characters to lower case if they are upper case, 
#                 or do nothing if they are already lower case.
# input:          $a0 - ASCII, null-terminated word 
# returns:        None
# side effects:   String converted to lower case
.text
ToLowerUtil:
  ori $a0, $a0, 0x00202020

  jr $ra


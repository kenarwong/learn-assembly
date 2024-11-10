#
# Program name: helloWorldMain.s
# Author: Charles Kann
# Date:9/19/2020
# Purpose: This program shows how to print a string using the C function printf
#
.text
.global main

main:
  # Save return to os on stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

  # Printing The Message
  LDR r0, =helloWorld         // = means load address
  BL printf                   // printf is an external reference, must be resolved by linker
                              // printf expects address in register r0 
                              // BL stores return address to next instruction

  # Return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  # BX lr
  # MOV pc, lr                // Error code 12 (014 octal)

  MOV r7, #1                  // syscall exit code
  MOV r0, #0                  // no error
  SWI 0                       // exit

.data
  # Stores the string to be printed
  helloWorld: .asciz "Hello World\n"

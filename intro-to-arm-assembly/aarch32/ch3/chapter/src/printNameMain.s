#
# Program Name: printNameMain
# Author: Charles Kann
# Date: 9/19/2020
# Purpose: To read a string using scanf
# Input:
# - input: Username
# Output:
# - format: Prints the greeting string

.text
.global main

main:
  # Save return to os on stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

  # Prompt for an input
  LDR r0, =prompt
  BL printf

  # Scanf
  LDR r0, =input              // format specification for scanf
  LDR r1, =name
  BL scanf

  # Printing the message
  ldr r0, =format             // variadic parameter, changes how printf treats other arguments
  ldr r1, =name
  BL printf

  # Return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  # MOV pc, lr                // Error code 12 (014 octal)

  MOV r7, #1                  // syscall exit code
  MOV r0, #0                  // no error
  SVC 0                       // exit

.data
  # Prompt the user to enter their name
  prompt: .asciz "Enter your name: "
  # Format for input (read a string)
  input: .asciz "%s"
  # Format of the program output
  format: .asciz "Hello %s, how are you today? \n"
  # Reserves space in the memory for name
  name: .space 40

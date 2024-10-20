.text

//.global _start
.global main

//_start:
main:
  # Save return address to stack
  SUB sp, sp, #16
  STR x30, [sp, #8]
  
  # Printing The Message
  ADRP x0, helloWorld
  ADD x0, x0, :lo12:helloWorld
  BL printf
  
  # # Return to the OS
  # LDR x30, [sp, #8]
  # ADD sp, sp, #16
  # RET
  
  # Exit the program
  MOV w0, #0          # Exit code 0
  BL exit             # Call exit

.data
  # Stores the string to be printed
  helloWorld: .asciz "Hello World\n"
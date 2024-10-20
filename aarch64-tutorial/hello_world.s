.section .text
  .globl _start 

_start:
  mov x0, #1
  adr x1, msg
  mov x2, len
  mov w8, #64         /* write code */
  svc #0
  
  # Exit the program
  mov x0, #0          
  mov w8, #93         /* exit code */
  svc #0                        

msg:
  .asciz "Hello World!\n"
  len = . - msg

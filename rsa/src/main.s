@ Program name:       main.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Demonstrate RSA algorithm

@ Constant program data
        .section  .rodata
        .align  2
# __main_separator:
#   .asciz ", "
# __main_newline:
#   .aciz "\n"
__main_promptMessage:
  .asciz "Type a message: "
__main_messageFormat:
  .asciz  "%49[^\n]"
__main_outputP:
  .asciz "p: %d\n"
__main_outputQ:
  .asciz "q: %d\n"
__main_displayPublicKey:
  .asciz "Public Key: %d\n"
__main_displayPrivateKey:
  .asciz "Private Key: %d\n"
__main_displayModulus:
  .asciz "Modulus: %d\n"
__main_displayDecryptedMessage:
  .asciz "Message (decrypted): %s\n"
filename:
  .asciz "encrypted.txt"
writemode:
  .asciz "w"
readmode:
  .asciz "r"
bitLength:
  .word  0x10                                                       @ 16-bit length (k)
stringCharLength:
  .word  50                                                        

@ Program code
        .equ    temp1,                  -8
        .equ    temp2,                  -12
        .equ    temp3,                  -16
        .equ    temp4,                  -20
        .equ    temp5,                  -24
        .equ    temp6,                  -28
        .equ    temp7,                  -32
        .equ    locals,                  28
        .equ    seed,                   0x00
        .equ    size_char,              1                           @ size of char in bytes
        .equ    size_t,                 4                           @ size of modulo in bytes
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub                 sp, sp, #8
  str                 fp, [sp, #0]
  str                 lr, [sp, #4]
  add                 fp, sp, #4
  sub                 sp, sp, #locals
  str                 r4, [fp, #temp1]
  str                 r5, [fp, #temp2]
  str                 r6, [fp, #temp3]
  str                 r7, [fp, #temp4]
  str                 r8, [fp, #temp5]
  str                 r9, [fp, #temp6]
  str                 r10, [fp, #temp7]

  # get public exponent
  bl                  cpubexp
  mov                 r4, r0                                        @ r4 = e 
 
  # display public key
  ldr                 r0, =__main_displayPublicKey
  mov                 r1, r4
  bl                  printf
 
  # set seed
  mov                 r0, #seed                                
  bl                  srand                                  

  # generate p and q
  ldr                 r0, =bitLength                                
  ldr                 r5, [r0, #0]                                  @ r5 = modulus bit length (k)            
  lsr                 r6, r5, #1                                    @ r6 = p and q bit length (k/2)

  generateP:
    # generate prime number p
    mov               r0, r6
    bl                genprime
    mov               r7, r0                                        @ r7 = p

    # validate p is coprime, gcd(e, p-1) == 1
    mov               r0, r4
    sub               r1, r7, #1
    bl                gcd

    cmp               r0, #1
    bne               generateP                                     @ not coprime, try again

    # display P
    ldr               r0, =__main_outputP
    mov               r1, r7
    bl                printf

  generateQ:
    # generate prime number q
    sub               r0, r5, r6                                    @ k - k/2         
    bl                genprime
    mov               r8, r0                                        @ r8 = q

    # validate p != q
    cmp               r7, r8                                                        
    beq               generateQ                                     @ p == q, try again

    # validate q is coprime, gcd(e, q-1) == 1
    mov               r0, r4
    sub               r1, r8, #1
    bl                gcd

    cmp               r0, #1
    bne               generateQ                                     @ not coprime, try again

    # display Q
    ldr               r0, =__main_outputQ
    mov               r1, r8
    bl                printf

  # calculate n
  mul                 r5, r7, r8                                    @ r5 = n = p * q

  # display modulus
  ldr                 r0, =__main_displayModulus
  mov                 r1, r5
  bl                  printf

  # calculate private key
  mov                 r0, r4
  mov                 r1, r7
  mov                 r2, r8
  bl                  cprivexp                                      @ cprivexp(e, p, q)
  mov                 r6, r0                                        @ r6 = d

  # display private key 
  ldr                 r0, =__main_displayPrivateKey
  mov                 r1, r6
  bl                  printf

  # allocate memory
  ldr                 r10, =stringCharLength
  ldr                 r10, [r10, #0]                                @ r10 = length of string

  mov                 r0, r10
  mov                 r1, #size_char           
  bl                  calloc
  mov                 r7, r0                                        @ r7 = string pointer

  mov                 r0, r10
  mov                 r1, #size_t           
  bl                  calloc
  mov                 r9, r0                                        @ r9 = encrypted string pointer

  # message prompt     
  ldr                 r0, =__main_promptMessage
  bl                  printf

  ldr                 r0, =__main_messageFormat
  mov                 r1, r7                                        @ string address
  bl                  scanf 
  bl                  getchar 

  # encrypt message
  mov                 r0, r7                                        @ string address 
  mov                 r1, r9                                        @ encrypted message address
  mov                 r2, r4                                        @ public key (e)
  mov                 r3, r5                                        @ modulus
  bl                  encrypt

  # open file for writing
  ldr                 r0, =filename
  ldr                 r1, =writemode
  bl                  fopen  
  mov                 r8, r0                                        @ r8 = file pointer

  # write to file
  mov                 r0, r9                                        @ encrypted message address                
  mov                 r1, #size_t
  mov                 r2, r10
  mov                 r3, r8                                        @ file pointer      
  bl                  fwrite        

  # close file
  mov                 r0, r8
  bl                  fclose 
  
  # TEMP
  # free memory
  mov                 r0, r7
  bl                  free

  mov                 r0, r9
  bl                  free

  mov                 r0, r10
  mov                 r1, #size_t           
  bl                  calloc
  mov                 r9, r0                                        @ r9 = encrypted string pointer
  # TEMP

  # open file for reading
  ldr                 r0, =filename
  ldr                 r1, =readmode
  bl                  fopen  
  mov                 r8, r0                                        @ r8 = file pointer

  # read from file
  mov                 r0, r9                                        @ encrypted message address
  mov                 r1, #size_t
  mov                 r2, r10
  mov                 r3, r8                                        @ file pointer
  bl                  fread

  # close file
  mov                 r0, r8
  bl                  fclose 

  # TEMP
  mov                 r0, r10
  mov                 r1, #size_char           
  bl                  calloc
  mov                 r7, r0                                        @ r7 = display messsage string pointer
  # TEMP

  # decrypt message
  mov                 r0, r7                                        @ string address 
  mov                 r1, r9                                        @ encrypted message address
  mov                 r2, r6                                        @ private key (d)
  mov                 r3, r5                                        @ modulus
  bl                  decrypt

  # display decrypted message
  ldr                 r0, =__main_displayDecryptedMessage   
  mov                 r1, r7                                        @ string address
  bl                  printf

  b                   cleanUp
 
  cleanUp:
    # free memory
    mov               r0, r7
    bl                free

    mov               r0, r9
    bl                free

    b                 exit
  
  exit:
    ldr               r10, [fp, #temp7]
    ldr               r9, [fp, #temp6]
    ldr               r8, [fp, #temp5]
    ldr               r7, [fp, #temp4]
    ldr               r6, [fp, #temp3]
    ldr               r5, [fp, #temp2]
    ldr               r4, [fp, #temp1]
    add               sp, sp, #locals
    mov               r0, #0
    ldr               fp, [sp, #0]
    ldr               lr, [sp, #4]
    add               sp, sp, #8
    bx                lr 

  .section  .note.GNU-stack,"",%progbits

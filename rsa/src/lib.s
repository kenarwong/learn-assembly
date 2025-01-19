@ Program name:       lib.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Library of helper functions

@ Program name:       cpubexp
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Get public key exponent
@ Output:             r0 - public exponent (e)

@ Constant program data
        .section  .rodata
        .align  2
__cpubexp_prompt:
  .asciz "Enter a value for e, please choose between the following Fermat numbers (3, 5, 17, 257, 65537): "
__cpubexp_input:
  .asciz "%d"
__cpubexp_error:
  .asciz "You entered invalid input.\n"
fermatNumbers:
  .word   0b11, 0b101, 0x11, 0x101, 0x10001                          @ First five Fermat numbers (e)

@ Program code
        .equ    userValueE,             -8
        .equ    locals,                  4
        .equ    numberOfFermatNumbers,   5
        .text
        .align  2
        .global cpubexp
        .syntax unified
        .type   cpubexp, %function

cpubexp:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals

  # prompt for selection
  promptForPublicExponent:
    ldr             r0, =__cpubexp_prompt
    bl              printf
    
    ldr             r0, =__cpubexp_input
    add             r1, fp, #userValueE
    bl              scanf
    bl              getchar 
    ldr             r0, [fp, #userValueE]                         @ user input
    
    # validate e
    ldr             r1, =fermatNumbers
    mov             r2, #0                                        @ index

    loopFermatNumbers:
      cmp           r2, #numberOfFermatNumbers
      beq           cpubexpInvalidInput                           @ available value not found    

      ldr           r3, [r1, r2, lsl #2]                          @ r3 = e
      cmp           r0, r3
      beq           exitCpubExp                                   @ value confirmed, exit 

      add           r2, r2, #1                                    @ index++
      b             loopFermatNumbers   

  cpubexpInvalidInput:
    ldr             r0, =__cpubexp_error
    bl              printf
    b               promptForPublicExponent
  
  exitCpubExp:
    ldr             r0, [fp, userValueE]                          @ output public exponent

    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

@ Program name:       cprivexp
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Calculate private key exponent
@ Input:              r0 - e
@                     r1 - p
@                     r2 - q
@ Output:             r0 - private key exponent (d)

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    locals,  12
        .text
        .align  2
        .global cprivexp
        .syntax unified
        .type   cprivexp, %function

cprivexp:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]

  mov               r4, r0                                          @ r4 = e
  mov               r5, r1                                          @ r5 = p
  mov               r6, r2                                          @ r6 = q

  # calculate euler's totient
  # phi(n) = (p-1)(q-1)
  sub               r0, r5, #1
  sub               r1, r6, #1
  mul               r2, r0, r1                                      @ phi(n) = (p-1) * (q-1)

  # choose d such that d is coprime to phi(n)
  # e*d = 1 (mod phi(n))
  # calculate multiplicative inverse of e modulo phi(n)
  mov               r0, r4
  mov               r1, r2
  bl                modinv                                          @ r0 = modinv(e, phi(n))
  
  ldr               r6, [fp, #temp3]
  ldr               r5, [fp, #temp2]
  ldr               r4, [fp, #temp1]
  add               sp, sp, #locals
  ldr               fp, [sp, #0]
  ldr               lr, [sp, #4]
  add               sp, sp, #8
  bx                lr 

@ Program name:       encrypt
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Encrypt message 
@ Input:              r0 - string pointer
@                     r1 - encrypted string pointer
@                     r2 - public key (e)
@                     r3 - modulus (n)

@ Constant program data
        .section  .rodata
        .align  2
__encrypt_MulOverflow:
  .asciz "Error (encrypt): Multiplication overflow detected.\n"

@ Program code
        .equ    temp1,                  -8
        .equ    temp2,                  -12
        .equ    temp3,                  -16
        .equ    temp4,                  -20
        .equ    temp5,                  -24
        .equ    temp6,                  -28
        .equ    temp7,                  -32
        .equ    locals,                  28
        .equ    size_char,              1                           @ size of char in bytes
        .equ    size_t,                 2                           @ size of modulo in bytes
        .text
        .align  2
        .global encrypt
        .syntax unified
        .type   encrypt, %function

encrypt:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]
  str               r7, [fp, #temp4]
  str               r8, [fp, #temp5]
  str               r9, [fp, #temp6]
  str               r10, [fp, #temp7]

  mov               r6, r2                                          @ r6 = e
  mov               r7, r3                                          @ r7 = n
  mov               r8, r0                                          @ r8 = string pointer
  mov               r9, r1                                          @ r9 = encrypted string pointer 

  loopEncrypt:
    ldrb            r4, [r8], #size_char

    # check if end of string
    cmp             r4, #0
    beq             exitEncrypt                                     @ reached null terminator, exit

    # initialize
    mov             r5, #1                                          @ c = 1
    mov             r10, r6                                         @ r10 = e

    # c = (m^e) mod n
    # only perform one exponentiation operation at a time followed by modulus to avoid overflow
    computeModExpLoop:
      cmp             r10, #0                                       @ check if e == 0
      beq             storeEncryptedChar                            @ if e == 0, store result

      umull           r5, r0, r5, r4                                @ c = c * m
                                                                    @ maximum byte size of intermediate multiplication is size_t + 1
      cmp             r0, #0          
      bne             encryptMulOverflow                            @ upper byte != 0, overflow detected (1) 

      mov             r0, r5                    
      mov             r1, r7                    
      bl              modulo                                        @ r1 = c % n
      mov             r5, r1                                        @ c = r1

      sub             r10, r10, #1                                  @ e--
      b               computeModExpLoop

    storeEncryptedChar:
      str           r5, [r9], #size_t       @ store encrypted char and increment pointer

    # loop back to load next char
    b               loopEncrypt

    encryptMulOverflow:
      ldr             r0, =__encrypt_MulOverflow
      bl              printf
      b               exitEncrypt

  exitEncrypt:
    ldr             r10, [fp, #temp7]
    ldr             r9, [fp, #temp6]
    ldr             r8, [fp, #temp5]
    ldr             r7, [fp, #temp4]
    ldr             r6, [fp, #temp3]
    ldr             r5, [fp, #temp2]
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

@ Program name:       decrypt
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Decrypt message 
@ Input:              r0 - string pointer
@                     r1 - encrypted string pointer
@                     r2 - private key (d)
@                     r3 - modulus (n)

@ Constant program data
        .section  .rodata
        .align  2
__decrypt_MulOverflow:
  .asciz "Error (decrypt): Multiplication overflow detected.\n"

@ Program code
        .equ    temp1,                  -8
        .equ    temp2,                  -12
        .equ    temp3,                  -16
        .equ    temp4,                  -20
        .equ    temp5,                  -24
        .equ    temp6,                  -28
        .equ    temp7,                  -32
        .equ    locals,                  28
        .equ    size_char,              1                             @ size of char in bytes
        .equ    size_t,                 2                             @ size of modulo in bytes
        .text
        .align  2
        .global decrypt
        .syntax unified
        .type   decrypt, %function

decrypt:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]
  str               r7, [fp, #temp4]
  str               r8, [fp, #temp5]
  str               r9, [fp, #temp6]
  str               r10, [fp, #temp7]

  mov               r6, r2                                            @ r6 = d
  mov               r7, r3                                            @ r7 = n
  mov               r8, r0                                            @ r8 = string pointer
  mov               r9, r1                                            @ r9 = encrypted string pointer 

  loopDecrypt:
    # loop load encrypted char of size_t into register
    mov             r0, #0                                            @ i = 0
    mov             r2, #size_char    
    lsl             r2, r2, #3                                        @ shamt = size_char * 8 (bits)
    eor             r4, r4, r4                                        @ r4 = encrypted char (c), bit length = size_t

    loopEncryptedCharLoad:
      cmp           r0, #size_t
      beq           exitEncryptedCharLoadLoop                         @ reached size_t, begin decryption             

      # calculate shift amount
      mul             r3, r2, r0                                      @ r3 = shamt * i 

      # load in byte, shift, and or into encrypted char 
      ldrb            r1, [r9], #size_char
      orr             r4, r4, r1, lsl r3                              @ r4 = r4 | (r1 << r3)

      add             r0, r0, #1
      b               loopEncryptedCharLoad

    exitEncryptedCharLoadLoop:

    # check if end of encrypted string
    cmp             r4, #0
    beq             exitDecrypt                                       @ reached null terminator, exit

    # initialize
    mov             r5, #1                                            @ m = 1
    mov             r10, r6                                           @ r10 = d

    # m = (c^d) mod n
    # only perform one exponentiation operation at a time followed by modulus to avoid overflow
    computeDecryptModExpLoop:
      cmp             r10, #0                                         @ check if d == 0
      beq             storeDecryptedChar                              @ if d == 0, store result

      umull           r5, r0, r5, r4                                  @ m = m * c
                                                                      @ maximum byte size of intermediate multiplication is 2*size_t
      cmp             r0, #0          
      bne             decryptMulOverflow                              @ upper byte != 0, overflow detected (1) 

      mov             r0, r5                    
      mov             r1, r7                    
      bl              modulo                                          @ r1 = m % n
      mov             r5, r1                                          @ m = r1

      sub             r10, r10, #1                                    @ d--
      b               computeDecryptModExpLoop

    storeDecryptedChar:
      strb          r5, [r8], #size_char                              @ store decrypted char and increment pointer

    # loop back to load next encrypted char
    b               loopDecrypt

  decryptMulOverflow:
    ldr             r0, =__decrypt_MulOverflow
    bl              printf
    b               exitDecrypt

  exitDecrypt:
    ldr             r10, [fp, #temp7]
    ldr             r9, [fp, #temp6]
    ldr             r8, [fp, #temp5]
    ldr             r7, [fp, #temp4]
    ldr             r6, [fp, #temp3]
    ldr             r5, [fp, #temp2]
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

@ Program name:       genprime
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Generate a prime number of a given bit length
@ Input:              r0 - bit length (n)
@ Output:             r0 - prime number

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    locals,  12
        .text
        .align  2
        .global genprime
        .syntax unified
        .type   genprime, %function

genprime:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]

  mov               r4, r0                                          @ r4 = bit length (n)
  mov               r5, #3                                          @ r5 = min (3)

  genPrimeLoop:
    # generate random number
    # min + rand() % (max - min)
    bl                rand                                          @ r0 = random number          

    # (2^n - 1) - min
    mov               r1, #1
    lsl               r1, r1, r4
    sub               r1, r1, #1                
    sub               r1, r1, r5                

    bl                modulo                                        @ r1 = r0 % r1
    add               r6, r1, r5                                    @ r6 = r1 + min

    # set msb and lsb 
    mov               r0, #1
    sub               r1, r4, #1                                    @ r1 = n-1
    lsl               r0, r0, r1                                    @ r0 = 2(n-1) 
    orr               r6, r6, r0                                    @ set bit n-1
    orr               r6, r6, #1                                    @ set bit 0

    # check if prime
    mov               r0, r6
    bl                checkprime                                    @ prime == 1

    cmp               r0, #1                                        @ r0 == 1, prime
    bne               genPrimeLoop                                  @ r0 != 1, not prime, try again 

  exitGenPrimeLoop:
    mov               r0, r6                                        @ output prime number
  
    ldr               r6, [fp, #temp3]
    ldr               r5, [fp, #temp2]
    ldr               r4, [fp, #temp1]
    add               sp, sp, #locals
    ldr               fp, [sp, #0]
    ldr               lr, [sp, #4]
    add               sp, sp, #8
    bx                lr 

@ Program name:       readfile
@ Author:             Ken Hwang
@ Date:               1/18/2024
@ Purpose:            Read file by line and store at memory location
@ Input:              r0 - file pointer
@                     r1 - memory save location
@ Output:             r0 - number of characters read

@ Constant program data
        .section  .rodata
        .align  2
bufferSize:
  .word  0x10                                                       @ 16 bytes

@ Program code
        .equ    temp1,                  -8
        .equ    temp2,                  -12
        .equ    temp3,                  -16
        .equ    temp4,                  -20
        .equ    temp5,                  -24
        .equ    temp6,                  -28
        .equ    locals,                  24
        .text
        .align  2
        .global readfile
        .syntax unified
        .type   readfile, %function

readfile:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]
  str               r6, [fp, #temp3]
  str               r7, [fp, #temp4]
  str               r8, [fp, #temp5]
  str               r9, [fp, #temp6]

  mov               r4, r0                                          @ r4 = file pointer
  mov               r5, r1                                          @ r5 = memory location
  mov               r6, #0                                          @ r6 = characters read

  # allocate buffer
  ldr                 r7, =bufferSize                              
  ldr                 r7, [r7, #0]                                  @ r7 = buffer size

  mov                 r0, r7
  bl                  malloc
  mov                 r8, r0                                        @ r8 = buffer pointer

  # read from file until null terminator
  readFromFileLoop:

    # read from file
    mov               r0, r8                                        @ buffer address
    mov               r1, r7                                        @ buffer size
    mov               r2, r4                                        @ file pointer
    bl                fgets

    # calculate number of characters read in buffer
    mov               r0, r8                                        @ buffer address
    bl                strlen        
    mov               r9, r0                                        @ r9 = number of characters read
    add               r6, r6, r9                                    @ increment total characters 

    # copy buffer to allocated memory block
    mov               r0, r5                                        @ message address
    mov               r1, r8                                        @ buffer pointer
    mov               r2, r9                                        @ number of characters 
    bl                memcpy

    # advance by number of characters read in buffer
    add               r5, r5, r9                                    @ increment message pointer

    # clear buffer
    mov               r0, r8                                        @ buffer address
    mov               r1, #0                                        @ clear buffer
    mov               r2, r7                                        @ buffer size
    bl                memset

    # check if at end of file
    mov               r0, r4                                        @ file pointer
    bl                feof                                           
    cmp               r0, #0                                        @ EOF will return non-zero
    beq               readFromFileLoop                              @ if zero, continue loop

  # free buffer
  mov                 r0, r8
  bl                  free

  # output total characters 
  mov                 r0, r6                                    
  
  ldr                 r9, [fp, #temp6]
  ldr                 r8, [fp, #temp5]
  ldr                 r7, [fp, #temp4]
  ldr                 r6, [fp, #temp3]
  ldr                 r5, [fp, #temp2]
  ldr                 r4, [fp, #temp1]
  add                 sp, sp, #locals
  ldr                 fp, [sp, #0]
  ldr                 lr, [sp, #4]
  add                 sp, sp, #8
  bx                  lr 

@ Program name:       fsize
@ Author:             Ken Hwang
@ Date:               1/18/2024
@ Purpose:            Get file size
@ Input:              r0 - file pointer
@ Output:             r0 - file size in bytes

@ Program code
        .equ    temp1,                  -8
        .equ    temp2,                  -12
        .equ    locals,                  8
        .equ    SEEK_SET,                0                          @ set file pointer to beginning
        .equ    SEEK_END,                2                          @ set file pointer to end
        .text
        .align  2
        .global fsize
        .syntax unified
        .type   fsize, %function

fsize:
  sub                 sp, sp, #8
  str                 fp, [sp, #0]
  str                 lr, [sp, #4]
  add                 fp, sp, #4
  sub                 sp, sp, #locals
  str                 r4, [fp, #temp1]
  str                 r5, [fp, #temp2]

  mov                 r4, r0                                        @ r4 = file pointer
  mov                 r5, r1                                        @ r5 = file size

  # set file pointer to end
  mov                 r0, r4
  mov                 r1, #0
  mov                 r2, #SEEK_END
  bl                  fseek

  # get file size
  mov                 r0, r4
  bl                  ftell
  mov                 r5, r0                                       @ file size

  # set file pointer to beginning
  mov                 r0, r4
  mov                 r1, #0
  mov                 r2, #SEEK_SET
  bl                  fseek

  # output file size
  mov                 r0, r5                                    
  
  ldr                 r5, [fp, #temp2]
  ldr                 r4, [fp, #temp1]
  add                 sp, sp, #locals
  ldr                 fp, [sp, #0]
  ldr                 lr, [sp, #4]
  add                 sp, sp, #8
  bx                  lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       math.s
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Library of helper math functions

@ Program name:       gcd
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Find greatest common divisor of two numbers using euclidean algorithm
@ Input:              r0 - first value (a)
@                     r1 - second value (b)
@ Output:             r0 - greatest common divisor

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global gcd
        .syntax unified
        .type   gcd, %function

gcd:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]

  loopGCD:
    cmp             r1, #0
    beq             exitGCD                 @ if b == 0, then exit

    # modulo and swap
    mov             r4, r1                  @ temp = b
    bl              modulo                  @ r1 = a % b        
    mov             r0, r4                  @ a = temp    

    b               loopGCD
  
  exitGCD:
    ldr             r5, [fp, #temp2]
    ldr             r4, [fp, #temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

@ Program name:       pow
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Performs exponentiation by squaring
@ Input:              r0 - base (b)
@                     r1 - exponent (e)
@ Output:             r0 - result (b^e)

@ Program code
        .text
        .align  2
        .global pow
        .syntax unified
        .type   pow, %function

pow:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals

  # initialize
  mov		            r2, #1		              @ result
   
  loopExponent:	
    cmp             r1, #0		               
    ble             exitLoopExponent		    @ if e <= 0, then exit 

    tst             r1, #1                  @ if e is odd (bitwise AND), z = 0 (zero flag cleared)
    mulne           r2, r2, r0              @ result *= b (ne: z = 0)

    mul             r0, r0, r0              @ b = b^2 
    lsr             r1, r1, #1              @ e >> 1
    b               loopExponent            @ if n != 0, repeat 
  
  exitLoopExponent:

  mov             r0, r2                    @ r0 = result
  
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

@ Program name:       modulo
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Perform modulo operation
@ Input:              r0 - dividend
@                     r1 - divisor
@ Output:             r0 - quotient
@                     r1 - remainder

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    locals,  8
        .text
        .align  2
        .global modulo
        .syntax unified
        .type   modulo, %function

modulo:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]

  bl                 __aeabi_idivmod
  
  ldr               r5, [fp, #temp2]
  ldr               r4, [fp, #temp1]
  add               sp, sp, #locals
  ldr               fp, [sp, #0]
  ldr               lr, [sp, #4]
  add               sp, sp, #8
  bx                lr 

@ Program name:       divide
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Perform 32-bit division
@ Input:              r0 - dividend
@                     r1 - divisor
@ Output:             r0 - quotient
@                     r1 - remainder

@ Program code
        .equ    temp1,      -8
        .equ    temp2,      -12
        .equ    temp3,      -16
        .equ    temp4,      -20
        .equ    temp5,      -24
        .equ    locals,      20
        # .equ    bitLength,   0x10
        .text
        .align  2
        .global divide
        .syntax unified
        .type   divide, %function

divide:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, #temp1]
  str               r5, [fp, #temp2]

  bl                __aeabi_idivmod

#   # 2's complement of divisor
#   mvn               r1, r1              
#   add               r1, r1, #1
#   lsl               r1, r1, #bitLength            @ shift divisor
# 
#   mov               r2, #bitLength                @ n bits
#   mov               r3, r0                        @ initialize AQ
# 
#   mov               r4, 0xffff                    @ A mask
#   mov               r5, 0xffff0000                @ Q mask
# 
#   divideLoop:
#     cmp             r2, #0
#     beq             exitloop                      @ if n == 0, exit
# 
#     lsl             r3, r3, #1                    @ shift AQ
#     add             r6, r3, r1                    @ subtract divisor, r6 is remainder
#                                                   @ allow overflow so we can detect
# 
#     # overflow detection (same sign operands)
#     eor             r7, r6, r1                    @ determine bit changes
#     tst             r7, #0x80000000               @ look at last bit for change
# 
#     subs            r2, r2, #1                    @ n--
# 
#     bne             divideLoop                    @ no overflow if no change in last bit
# 
#     @ if overflow
#     orr             r3, r3, #1                    @ if overflow detected, set Q0 = 1
# 
#     @ add remainder to A
#     and             r8, r3, r4                    @ mask A from AQ (keep Q)
#     orr             r3, r6, r8                    @ add remainder to A
# 
#     b               divideLoop
# 
#   exitloop:
#   
  ldr             r5, [fp, #temp2]
  ldr             r4, [fp, #temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

@ Program name:       checkprime
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Check if number is prime 
@ Input:              r0 - number
@ Output:             r0 - 1 is prime, 0 is not prime

@ Program code
        .equ    temp1, -8
        .equ    temp2, -12
        .equ    temp3, -16
        .equ    temp4, -20
        .equ    temp5, -24
        .equ    locals, 20
        .text
        .align  2
        .global checkprime
        .syntax unified
        .type   checkprime, %function

checkprime:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, temp1]
  str               r5, [fp, temp2]
  str               r6, [fp, temp3]
  str               r7, [fp, temp4]

  mov               r4, r0                                  @ n
  mov               r5, #0                                  @ return value (initialize as 0)

  # initialize loop
  mov               r6, #2                                  @ i
  lsr               r7, r4, #1                              @ n/2

  # loop check 2 -> n/2
  checkPrimeLoop:
    cmp             r6, r7              
    bgt             primeFound                              @ i > n/2

    mov             r0, r4
    mov             r1, r6
    bl              modulo                                  @ n % i

    cmp             r1, #0
    beq             exitCheckPrime                          @ n % i == 0 (i.e. divisible)

    add             r6, r6, #1                              @ i++
    b               checkPrimeLoop

  primeFound:
    mov             r5, #1

  exitCheckPrime:
    mov             r0, r5
  
  ldr             r7, [fp, temp4]
  ldr             r6, [fp, temp3]
  ldr             r5, [fp, temp2]
  ldr             r4, [fp, temp1]
  add             sp, sp, #locals
  ldr             fp, [sp, #0]
  ldr             lr, [sp, #4]
  add             sp, sp, #8
  bx              lr 

@ Program name:       modinv
@ Author:             Ken Hwang
@ Date:               1/17/2024
@ Purpose:            Calculate modular multiplicative inverse of a, where a*x = 1 (mod m)
@                     Using euclidean algorithm, assumes positive integers
@ Input:              r0 - value (a)
@                     r1 - value (m)
@ Output:             r0 - modular inverse (x)

@ Program code
        .equ    temp1,  -8
        .equ    temp2,  -12
        .equ    temp3,  -16
        .equ    temp4,  -20
        .equ    temp5,  -24
        .equ    temp6,  -28
        .equ    locals,  24
        .text
        .align  2
        .global modinv
        .syntax unified
        .type   modinv, %function

modinv:
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

  mov               r4, r0                                  @ a
  mov               r5, r1                                  @ m

  # check that inverse exists, gcd(a, m) == 1
  bl                gcd
  cmp               r0, #1
  bne               noModinv

  # initialize
  mov               r6, #0                                  @ t
  mov               r7, #1                                  @ newt
  mov               r8, r5                                  @ r = m
  mov               r9, r4                                  @ newr = a

  modinvLoop:
    cmp             r9, #0
    beq             modinvEndLoop

    # quotient = r / newr
    mov             r0, r8
    mov             r1, r9
    bl              divide
    mov             r2, r0                                  

    # tmp = t - quotient * newt
    mul             r0, r2, r7                                     
    sub             r0, r6, r0                              

    # t = newt, newt = tmp
    mov             r6, r7
    mov             r7, r0

    # tmp = r - quotient * newr
    mul             r0, r2, r9
    sub             r0, r8, r0

    # r = newr, newr = tmp
    mov             r8, r9
    mov             r9, r0

    b               modinvLoop

  modinvEndLoop:
    cmp             r8, #1
    bgt             noModinv                                 @ r > 1         

    cmp             r6, #0
    bge             modinvDone                               @ t >= 0   

    add             r6, r6, r5                               @ t += m

  modinvDone:
    mov             r0, r6
    b               exitModinv

  noModinv:
    mov             r0, #0                                   @ no inverse          
    b               exitModinv

  exitModinv:

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

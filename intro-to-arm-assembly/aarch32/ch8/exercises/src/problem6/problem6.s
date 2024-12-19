@ Program name:       problem6.s
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Random number guessing game (computer's turn)

@ Maximum amount of guesses = ceil(log2(n))
@ 100 = 7
@ 1000 = 10
@ 10000 = 14

@ Constant program data
        .section  .rodata
        .align    2
initialPrompt:
  .asciz "Enter a maximum value to guess from (greater than 0): "
initialInput:
  .asciz "%d"
displayFinalGuess:
  .asciz "Your number is: %d\n"
displayGuessCount:
  .asciz "Number of guesses: %d\n"
error:
  .asciz "You entered invalid input.\n"

@ Program code
        .equ    value, -8
        .equ    temp1, -12
        .equ    temp2, -16
        .equ    locals, 12
        .text
        .align  2
        .global main
        .syntax unified
        .type   main, %function

main:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, temp1]
  str               r5, [fp, temp2]

  # initial prompt   
  ldr               r0, =initialPrompt
  bl                printf
  ldr               r0, =initialInput
  add               r1, fp, value
  bl                scanf

  # validate input
  ldr               r0, [fp, value]                         @ max value
  mov               r1, #1
  cmp               r0, r1
  blt               invalidInput                            @ le 1, failed validation

  # initialize
  eor               r0, r0, r1                              @ swap r0 and r1 
  eor               r1, r1, r0                              @ end
  eor               r0, r0, r1                              @ start 
  mov               r2, #0                                  @ guess count

  # binary search
  bl                binarySearch
  mov               r4, r0                                  @ final guess
  mov               r5, r1                                  @ guess count

  ldr               r0, =displayFinalGuess
  mov               r1, r4
  bl                printf

  ldr               r0, =displayGuessCount
  mov               r1, r5
  bl                printf

  b                 exit

  invalidInput:
    # print error
    ldr             r0, =error
    bl              printf

  exit:
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    mov             r0, #0
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

@ Program name:       binarySearch
@ Author:             Ken Hwang
@ Date:               12/18/2024
@ Purpose:            Recursive binary search
@ Input:              r0 - start of range
@                     r1 - end of range
@                     r2 - guess count
@ Output:             r0 - final guess 
@                     r1 - guess count

@ Constant program data
        .section  .rodata
        .align    2
displayFeedback1:
  .asciz "Is %d your number? (y/n) "
displayFeedback2:
  .asciz "Is it too high (h) or too low (l) "
feedbackInput:
  .asciz "%1s"
displayInvalid:
  .asciz "You entered an incorrect input. Please confirm with %c or %c.\n"
chars:
  # .align 2
  .ascii "ynhl"                                 

@ Program code
        .equ    response, -8
        .equ    temp1, -12
        .equ    temp2, -16
        .equ    temp3, -20
        .equ    temp4, -24
        .equ    temp5, -28
        .equ    locals, 24
        .equ    yCharBitIndex, 0
        .equ    nCharBitIndex, 8
        .equ    hCharBitIndex, 16
        .equ    lCharBitIndex, 24
        .equ    charBitMask, 0xffffff00
        .text
        .align  2
        .syntax unified
        .type   binarySearch, %function
        
@ Macro to get char and apply bit mask
  .macro GET_CHAR reg, charReg, charIndex 
    ldr             \charReg, =chars                               
    ldr             \charReg, [\charReg, #0]                       @ load chars
    lsr             \reg, \charReg, #\charIndex                    @ shift desired char to LSB in word
    bic             \reg, \reg, #charBitMask                       @ apply mask
  .endm

  # pseudo-code
  # args: start, end, count, char byte
  # return: count, guess

  # 1 left
  #   return
  # calculate mid
  # ask if mid
  # y
  #   return
  # n
  #   2 left
  #     return other
  #   ask h/l
  #     h
  #       recurse l, mid-1
  #     l
  #       recurse mid+1,h

binarySearch:
  sub               sp, sp, #8
  str               fp, [sp, #0]
  str               lr, [sp, #4]
  add               fp, sp, #4
  sub               sp, sp, #locals
  str               r4, [fp, temp1]
  str               r5, [fp, temp2]
  str               r6, [fp, temp3]
  str               r7, [fp, temp4]
  str               r8, [fp, temp5]

  # initialize
  mov               r4, r0
  mov               r5, r1
  mov               r6, r2
  mov               r0, #0                                 
  str               r0, [fp, response]                    @ clear memory at response

  # base case - 1 value left
  cmp               r4, r5
  beq               oneFinal

  # mid = start + (end-start)/2
  sub               r0, r5, r4 
  lsr               r0, r0, 1
  add               r8, r4, r0

  # check if correct
  feedbackCheck1:
    ldr             r0, =displayFeedback1
    mov             r1, r8
    bl              printf
    ldr             r0, =feedbackInput
    add             r1, fp, response
    bl              scanf
    ldr             r0, [fp, response]                    @ user feedback y/n

    mov             r3, #0                                @ flag

    # if correct
    GET_CHAR        r1, r7, yCharBitIndex                 @ char y
    eor             r1, r1, r0                            @ feedback xor "y", 0 = y
    cmp             r1, #0
    moveq           r3, #1
    beq             endFeedBackCheck1

    # if not correct
    GET_CHAR        r2, r7, nCharBitIndex                 @ char n
    eor             r2, r2, r0                            @ feedback xor "n", 0 = n
    cmp             r2, #0
    beq             endFeedBackCheck1

    # print invalid
    ldr             r0, =displayInvalid
    GET_CHAR        r1, r7, yCharBitIndex                 @ char y
    GET_CHAR        r2, r7, nCharBitIndex                 @ char n
    bl              printf

    b feedbackCheck1

  endFeedBackCheck1:

  add               r6, r6, #1                            @ increment guess count
  
  # check if correct
  cmp               r3, #1
  beq               correct                               

  # if 2 values remain, other value is correct
  mov               r0, #1
  sub               r1, r5, r4
  cmp               r1, r0
  beq               twoLeft

  # check high or low
  feedbackCheck2:
    ldr             r0, =displayFeedback2
    bl              printf
    ldr             r0, =feedbackInput
    add             r1, fp, response
    bl              scanf
    ldr             r0, [fp, response]                    @ user feedback h/l

    # check if high
    GET_CHAR        r1, r7, hCharBitIndex                 @ char h
    eor             r1, r1, r0                            @ feedback xor "h", 0 = detected
    cmp             r1, #0
    beq             tooHigh

    # check if low
    GET_CHAR        r2, r7, lCharBitIndex                 @ char l
    eor             r2, r2, r0                            @ feedback xor "l", 0 = detected
    cmp             r2, #0
    beq             tooLow

    # print invalid
    ldr             r0, =displayInvalid
    GET_CHAR        r1, r7, hCharBitIndex                 @ char h
    GET_CHAR        r2, r7, lCharBitIndex                 @ char l
    bl              printf

    b feedbackCheck2

  tooHigh:
    mov             r0, r4                                @ start
    sub             r1, r8, #1                            @ mid - 1
    mov             r2, r6                                @ guess count
    bl              binarySearch

    b               exitBinarySearch

  tooLow:
    add             r0, r8, #1                            @ mid + 1
    mov             r1, r5                                @ end
    mov             r2, r6                                @ guess count
    bl              binarySearch

    b               exitBinarySearch

  # deduce final (still counts as a guess)
  oneFinal:
    mov             r0, r4                                @ final guess
    add             r1, r6, #1                            @ increment guess count
    b               exitBinarySearch

  # deduce final (still counts as a guess)
  twoLeft:
    mov             r0, r5                                @ mid guess is always lower value, return larger value
    add             r1, r6, #1                            @ increment guess count
    b               exitBinarySearch

  correct:
    mov             r0, r8                                @ final guess
    mov             r1, r6                                @ guess count

  exitBinarySearch:
    ldr             r8, [fp, temp5]
    ldr             r7, [fp, temp4]
    ldr             r6, [fp, temp3]
    ldr             r5, [fp, temp2]
    ldr             r4, [fp, temp1]
    add             sp, sp, #locals
    ldr             fp, [sp, #0]
    ldr             lr, [sp, #4]
    add             sp, sp, #8
    bx              lr 

  .section  .note.GNU-stack,"",%progbits

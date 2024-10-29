.text                                                      
.global main                                              
main:                                                     
  la $a0, prompt                                          # 1
                                                          # 2
  jal PromptInt                                           # 3
  move $s0, $v0                                           # 4
                                                          # ---
  BeginLoop:                                              # ---
    seq $t0, $s0, -1                                      # 5
                                                          # 6
                                                          # 7
                                                          # 8
    bnez $t0, EndLoop  # 0x15000015 (+21 dec)             # 9
                                                          # ---
    la $a0, result                                        # 10
                                                          # 11
    move $a1, $s0                                         # 12
    jal PrintInt                                          # 13
                                                          # ---
    slti $t0, $s0, 100                                    # 14
    beqz $t0, BigNumber # 0x11000004 (+4 dec)             # 15
      la $a0, little                                      # 16
                                                          # 17
      jal PrintString                                     # 18
      b EndIf           # 0x04010003 (+3 dec)             # 19
                                                          # ---
    BigNumber:                                            # ---
      la $a0, big                                         # 20
                                                          # 21
      jal PrintString                                     # 22
    EndIf:                                                # ---
                                                          # ---
    la $a0, tryAgain                                      # 23
                                                          # 24
    jal PrintString                                       # 25
    la $a0 prompt                                         # 26
                                                          # 27
    jal PromptInt                                         # 28
    move $s0, $v0                                         # 29
    b BeginLoop        # 0x0401ffe6 (-26 dec)             # 30
                                                          # ---
  EndLoop:                                                # ---
    jal Exit                                              # 31
                                                                                                             
.data                                                     # 0x10010000
  prompt:   .asciiz "\nEneter a number (-1 to end)"       #                                           
  result:   .asciiz "\nYou entered "                      #                             
  big:      .asciiz "\nThat is a big number"              #                                     
  little:   .asciiz "\nThat is a little number"           #                                       
  tryAgain: .asciiz "\nTry again"                         #                         
.include "utils.asm"                                      #             
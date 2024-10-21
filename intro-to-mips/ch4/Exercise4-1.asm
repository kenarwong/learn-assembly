.text                               # | 0x00400000 |
.globl main

main:
  ori $t0, $zero, 15                # I format
                                    # |op 6||rs5||rt5||immediate  16 |
                                    #   0x0d 0x00 0x08          0x000f
                                    # 00110100000010000000000000001111
                                    #    3   4   0   8   0   0   0   f
  ori $t1, $zero, 3                 # I format
                                    # |op 6||rs5||rt5||immediate  16 |
                                    #   0x0d 0x00 0x09          0x0003
                                    # 00110100000010010000000000000011
                                    #    3   4   0   9   0   0   0   3
  add $t1, $zero, $t1               # R format
                                    # |op 6||rs5||rt5||rd5||sh5||fun6|
                                    #   0x00 0x00 0x09 0x09 0x00  0x00
                                    # 00000000000010010100100000100000
                                    #    0   0   0   9   4   8   2   0
  sub $t2, $t0, $t1                 # R format
                                    # |op 6||rs5||rt5||rd5||sh5||fun6|
                                    #   0x00 0x08 0x09 0x0a 0x00  0x22
                                    # 00000001000010010101000000100010
                                    #    0   1   0   9   5   0   2   2
  sra $t2, $t2, 2                   # R format
                                    # |op 6||rs5||rt5||rd5||sh5||fun6|
                                    #   0x00 0x00 0x0a 0x0a 0x02  0x03
                                    # 00000000000010100101000010000011
                                    #    0   0   0   a   5   0   8   3
  mult $t0, $t1                     # R format
                                    # |op 6||rs5||rt5||rd5||sh5||fun6|
                                    #   0x00 0x08 0x09 0x00 0x00  0x18
                                    # 00000001000010010000000000011000
                                    #    0   1   0   9   0   0   1   8
  mflo $a0                          # R format
                                    # |op 6||rs5||rt5||rd5||sh5||fun6|
                                    #   0x00 0x00 0x00 0x04 0x00  0x12
                                    # 00000000000000000010000000010010
                                    #    0   0   0   0   2   0   1   2
  ori $v0, $zero, 1                 # I format
                                    # |op 6||rs5||rt5||immediate  16 |
                                    #   0x0d 0x00 0x02          0x0001
                                    # 00110100000000100000000000000001
                                    #    3   4   0   2   0   0   0   1
  syscall                           # R format
                                    # |op 6||rs5||rt5||rd5||sh5||fun6|
                                    #   0x00 0x00 0x00 0x00 0x00  0x0c
                                    # 00000000000000000000000000001100
                                    #    0   0   0   0   0   0   0   c
  addi $v0, $zero, 10               # I format
                                    # |op 6||rs5||rt5||signextimm 16 |
                                    #   0x08 0x00 0x02          0x000a
                                    # 00100000000000100000000000001010
                                    #    2   0   0   2   0   0   0   a
  syscall                           # R format
                                    # |op 6||rs5||rt5||rd5||sh5||fun6|
                                    #   0x00 0x00 0x00 0x00 0x00  0x0c
                                    # 00000000000000000000000000001100
                                    #    0   0   0   0   0   0   0   c

.data                               # | 0x10010000 |
  result: .asciiz "15 * 3 is "      # | 0x2a 0x20 0x35 0x31 0x69 0x20 0x33 0x20 0x00 0x00 0x20 0x73 |
  
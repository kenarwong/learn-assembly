addi $s0, $zero, 10               #    2   0   1   0   0   0   0   a
                                  # 00100000000100000000000000001010
                                  #   0x08 0x00 0x10          0x000a
                                  # |op 6||rs5||rt5||signextimm 16 |
                                  # R[rt] = R[rs] + SignExtImm
ori  $s1, $zero, 5                #    3   4   1   1   0   0   0   5
                                  # 00110100000100010000000000000101
                                  #   0x0d 0x00 0x11          0x0005
                                  # |op 6||rs5||rt5||immediate  16 |
                                  # R[rt] = R[rs] | ZeroExtImm
sub  $t8, $t1, $t2                #    0   1   2   a   c   0   2   2
                                  # 00000001001010101100000000100010
                                  #   0x00 0x09 0x0a 0x18 0x00  0x22
                                  # |op 6||rs5||rt5||rd5||sh5||fun6|
                                  # R[rd] = R[rs] - R[rt]
srl  $t0, $t8, 2                  #    0   0   1   8   4   0   8   2
                                  # 00000000000110000100000010000010
                                  #   0x00 0x00 0x18 0x08 0x02  0x02
                                  # |op 6||rs5||rt5||rd5||sh5||fun6|
                                  # R[rd] = R[rt] >>> shamt
and  $s2, $t8, $t7                #    0   3   0   f   9   0   2   4
                                  # 00000011000011111001000000100100
                                  #   0x00 0x18 0x0f 0x12 0x00  0x24
                                  # |op 6||rs5||rt5||rd5||sh5||fun6|
                                  # R[rd] = R[rs] & R[rt]
.data
  i:      .word 0x00      # i
  k:      .word 0xff      # k
  save0:  .word 0xff      # save
  save1:  .word 0xff      # save
  save2:  .word 0xff      # save
  save3:  .word 0x00      # save

.text
.globl main
main:
  la $gp, i               # Load i
  lw $s3, 0($gp)
  la $gp, k               # Load k
  lw $s5, 0($gp)
  la $s6, save0           # Load base address of save into s6

Loop: 
  sll $t1, $s3, 2         # shift left by 2^i = multiply iterator by 4 (due to byte addressing) 
  add $t1, $t1, $s6       # absolute address from save0
  lw  $t0, 0($t1)         # load value at indexed address
  bne $t0, $s5, Exit      # if(save[i] != k), then exit

  # Else
  addi $s3, $s3, 1        # iterate i by 1
  j Loop                  # loop

Exit:
# Program File: Exercise-2.asm
# Author: Ken Hwang
# Play middle "C" for 1 second as reed instrument 

.text
.globl main

main:
  lw $a0, pitch
  lw $a1, duration
  lw $a2, instrument
  lw $a3, volume
  li $v0, 31            # code for MIDI out immediate
  syscall

  li $v0, 10            # code for exit
  syscall

.data
  pitch:      .word 60    # middle C
  duration:   .word 1000  # 1000 ms
  instrument: .word 64    # reed instrument
  volume:     .word 64    # volume
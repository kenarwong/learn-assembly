        .section  .rodata
        .align  2
stringData:
        .asciz "hello"
.LC0:
        .ascii  "x: %c, %i, %c\012y: %c, %i, %c\012z: %s\000"
        .text
        .align  2
        .global main
        .syntax unified
        .arm
        .fpu vfp
        .type   main, %function
main:
        @ args = 0, pretend = 0, frame = 24
        @ frame_needed = 1, uses_anonymous_args = 0
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #44
        mov     r3, #97
        strb    r3, [fp, #-16]    @@ x.abyte = 'a';
        mov     r3, #123
        str     r3, [fp, #-12]    @@ x.anInt = 123;
        mov     r3, #98
        strb    r3, [fp, #-8]     @@ x.anotherByte = 'b';
        mov     r3, #49
        strb    r3, [fp, #-28]    @@ y.abyte = '1';
        mov     r3, #456
        str     r3, [fp, #-24]    @@ y.anInt = 456;
        mov     r3, #50
        strb    r3, [fp, #-20]    @@ y.anotherByte = '2';
        ldrb    r3, [fp, #-16]  @ zero_extendqisi2
        mov     ip, r3
        ldr     r2, [fp, #-12]    @@ x.anInt
        ldrb    r3, [fp, #-8]   @ zero_extendqisi2
        mov     lr, r3
        ldrb    r3, [fp, #-28]  @ zero_extendqisi2
        mov     r1, r3
        ldr     r3, [fp, #-24]
        ldrb    r0, [fp, #-20]  @ zero_extendqisi2
        ldr     r4, =stringData
        str     r4, [sp, #12]
        str     r0, [sp, #8]      @@ y.anotherByte
        str     r3, [sp, #4]      @@ y.anInt
        str     r1, [sp]          @@ y.aByte
        mov     r3, lr            @@ x.aByte
        mov     r1, ip            @@ x.anotherByte
        ldr     r0, .L3           @@ formatting string
        bl      printf            @ printf must have args r0-r3 before it reads from stack
        mov     r3, #0
        mov     r0, r3
        sub     sp, fp, #4
        @ sp needed
        pop     {fp, pc}
.L4:
        .align  2
.L3:
        .word   .LC0

# registers prior to printf
# ip = x.abyte       = r1
# r2 = x.anInt
# lr = x.anotherByte = r3
# 
# r1 = y.abyte       => sp
# r3 = y.anInt       => sp+4
# r0 = y.anotherByte => sp+8
# 
# r0 = format
# 
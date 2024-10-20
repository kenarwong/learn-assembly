// Any symbols, macros, etc go at the very top
.section .text
    .global main

main:
// Call puts and return 
    stp fp, lr, [sp, #0x10]!
    mov fp, sp
    adr x0, msg
    bl puts
    mov w0, wzr
    ldp fp, lr, [sp], #0x10
    ret

msg:
    .asciz "Hello Again!"
    .align 2
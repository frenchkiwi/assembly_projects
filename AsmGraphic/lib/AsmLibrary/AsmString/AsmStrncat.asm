section .data

section .text
    global AsmStrncat
    %include "AsmLibrary.inc"

AsmStrncat:
    .goto_end:
        cmp byte[rdi], 0
        je .leave_goto_end
        inc rdi
        jmp .goto_end
    .leave_goto_end:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        cmp r8b, 0
        jne .loop
    .bye:
    mov byte[rdi + rcx], 0
    mov rax, rdi
    ret
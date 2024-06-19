section .data

section .text
    global AsmStrcat
    %include "AsmLibrary.inc"

AsmStrcat:
    .goto_end:
        cmp byte[rdi], 0
        je .leave_goto_end
        inc rdi
        jmp .goto_end
    .leave_goto_end:
    mov rcx, -1
    .loop:
        inc rcx
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        cmp r8b, 0
        jne .loop
    mov rax, rdi
    ret
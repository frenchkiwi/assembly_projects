section .data

section .text
    global AsmStrcspn
    %include "AsmLibrary.inc"

AsmStrcspn:
    mov rdx, -1
    .loop:
        inc rdx
        mov rcx, -1
        .in_list:
            inc rcx
            mov r8b, byte[rsi + rcx]
            cmp byte[rdi + rdx], r8b
            je .return_here
            cmp r8b, 0
            jne .in_list
        cmp byte[rdi + rdx], 0
        jne .loop
    xor rax, rax
    ret

    .return_here:
        mov rax, rdx
        ret
section .data

section .text
    global AsmStrpbrk
    %include "AsmLibrary.inc"

AsmStrpbrk:
    dec rdi
    .loop:
        inc rdi
        mov rcx, -1
        .in_list:
            inc rcx
            mov r8b, byte[rsi + rcx]
            cmp byte[rdi], r8b
            je .return_here
            cmp r8b, 0
            jne .in_list
        cmp byte[rdi], 0
        jne .loop
    xor rax, rax
    ret

    .return_here:
        mov rax, rdi
        ret
section .data

section .text
    global AsmStrstr
    %include "AsmLibrary.inc"

AsmStrstr:
    xor rcx, rcx
    .loop:
        mov bl, [rsi + rcx]
        cmp bl, 0
        je .found
        mov al, [rdi + rcx]
        cmp al, 0
        je .end
        cmp al, bl
        jne .restart
        inc rcx
        jmp .loop
    .restart:
        xor rcx, rcx
        inc rdi
        jmp .loop
    .end:
        xor rax, rax
        ret
    .found:
        mov rax, rdi
        ret
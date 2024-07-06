section .data

section .text
    global AsmSetPositionText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetPositionText:
    cmp rdi, 0
    je .bye_error

    mov dword[rdi + 20], esi

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret
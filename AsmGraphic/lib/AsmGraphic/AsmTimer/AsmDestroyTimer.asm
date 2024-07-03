section .data

section .text
    global AsmDestroyTimer
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDestroyTimer:
    cmp rdi, 0
    je .bye_error

    call AsmDalloc

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret
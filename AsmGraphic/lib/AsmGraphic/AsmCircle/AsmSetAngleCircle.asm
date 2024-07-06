section .data

section .text
    global AsmSetAngleCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetAngleCircle:
    cmp rdi, 0
    je .bye_error
    
    mov r8, 64
    cvtsi2sd xmm2, r8
    mulsd xmm0, xmm2
    mulsd xmm1, xmm2
    cvtsd2si r8, xmm0
    sub r8, 90 * 64
    mov word[rdi + 24], r8w
    neg word[rdi + 24]
    cvtsd2si r8, xmm1
    mov word[rdi + 26], r8w
    neg word[rdi + 26]

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret
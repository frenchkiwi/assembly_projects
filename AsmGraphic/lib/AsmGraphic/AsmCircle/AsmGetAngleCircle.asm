section .data

section .text
    global AsmGetAngleCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetAngleCircle:
    mov r8, 64
    cvtsi2sd xmm2, r8
    xor r8, r8
    movsx r8, word[rdi + 24]
    neg r8
    add r8, 90 * 64
    cvtsi2sd xmm0, r8
    divsd xmm0, xmm2
    xor r8, r8
    movsx r8, word[rdi + 26]
    neg r8
    cvtsi2sd xmm1, r8
    divsd xmm1, xmm2
    ret
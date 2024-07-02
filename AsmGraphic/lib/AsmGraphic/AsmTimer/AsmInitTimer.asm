section .data

section .text
    global AsmInitText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmInitTimer:
    mov rdi, 16
    call AsmAlloc
    cmp rax, 0
    je .bye_error0

    mov r8, rax
    cvtsd2si rdi, xmm0
    cvtsi2sd xmm1, rdi
    mov rax, rdi
    mov rdi, 1000000000
    mul rdi
    mov qword[r8], rax
    subsd xmm0, xmm1
    mov rdi, 1000000000
    cvtsi2sd xmm1, rdi
    mulsd xmm0, xmm1
    cvtsd2si rdi, xmm0
    add qword[r8], rdi
    mov qword[r8 + 8], 0

    mov rax, r8
    ret

    .bye_error0:
        xor rax, rax
        ret
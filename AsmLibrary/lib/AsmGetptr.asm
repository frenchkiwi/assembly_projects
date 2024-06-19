section .data

section .text
    global AsmGetptr
    %include "AsmLibrary.inc"

AsmGetptr:
    push rdi
    mov rdi, 8
    call AsmAlloc
    pop rdi
    cmp rax, 0
    je .bye
    mov qword[rax], rdi
    .bye:
    ret
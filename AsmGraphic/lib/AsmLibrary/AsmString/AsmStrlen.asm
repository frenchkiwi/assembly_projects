section .data

section .text
    global AsmStrlen
    %include "AsmLibrary.inc"

AsmStrlen:
    mov rax, -1
    .loop:
        inc rax
        cmp byte [rdi + rax], 0
        jne .loop
    ret
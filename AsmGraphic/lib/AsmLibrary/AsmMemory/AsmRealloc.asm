section .data

section .text
    global AsmRealloc
    %include "AsmLibrary.inc"

AsmRealloc:
    push rsi
    cmp rdi, 0
    je .no_free
    call AsmDalloc
    .no_free:
    pop rdi
    cmp rdi, 0
    je .no_malloc
    call AsmAlloc
    .no_malloc:
    ret
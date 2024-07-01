section .data

section .text
    global AsmWaitEvent
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmWaitEvent:
    mov r8, rdi ; set r8 to link
    mov r9, rdi
    add r9, 26 ; set r9 to the prev event
    .loop:
        cmp qword[r9], 0
        je AsmWaitEvent
        mov r10, qword[r9] ; set r10 to event
        cmp byte[r10 + 8], sil
        je .quit_loop
        mov r9, qword[r9]
        jmp .loop
    .quit_loop:
    push r8
    push r10
    lea rdi, [r8 + 12]
    call AsmLock
    pop r10
    pop r8
    mov r11, qword[r10]
    mov qword[r9], r11
    push r10
    lea rdi, [r8 + 12]
    call AsmUnlock
    pop rax
    ret
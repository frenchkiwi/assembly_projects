section .data

section .text
    global AsmWaitEvent
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmWaitEvent:
    mov r8, qword[rdi + 8] ; set r8 to link
    mov r9, qword[rdi + 8]
    add r9, 26 ; set r9 to the prev event
    .loop:
        cmp qword[r9], 0
        je AsmWaitEvent
        mov r10, qword[r9] ; set r10 to event
        cmp byte[r10 + 8], sil
        je .check_event
        .next_event:
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

    .check_event:
        cmp rsi, 17
        jle .quit_loop
        cmp rsi, 20
        jl .window4
        je .quit_loop
        cmp rsi, 23
        jl .window4
        jmp .quit_loop

    .window4:
        mov r11d, dword[r10 + 8 + 4]
        cmp dword[rdi], r11d
        jne .next_event
        jmp .quit_loop

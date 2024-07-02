section .data


section .text
    global AsmPollEvent
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmPollEvent:
    xor rax, rax
    cmp rsi, 0
    je .bye0
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rsi ; r12 is window
    mov r13, qword[WINDOW_LINK] ; r13 is link
    mov r14, rdi ; r14 is event

    mov r15, r13 
    add r15, 26 ; set r15 to the prev event
    .loop:
        cmp qword[r15], 0
        je .bye
        mov rbx, qword[r15] ; set r10 to event
        cmp byte[rbx + 8], 2
        jl .next_event
        cmp byte[rbx + 8], 9
        jl .window12
        cmp byte[rbx + 8], 11
        je .next_event
        cmp byte[rbx + 8], 13
        jl .window4
        cmp byte[rbx + 8], 16
        jl .window4
        je .window8
        cmp byte[rbx + 8], 20
        jl .window4
        je .window8
        cmp byte[rbx + 8], 23
        jl .window4
        je .window8
        cmp byte[rbx + 8], 27
        jl .window4
        je .window8
        cmp byte[rbx + 8], 28
        je .window4
        cmp byte[rbx + 8], 32
        jl .window8
        cmp byte[rbx + 8], 34
        jl .window4
        .next_event:
        mov r15, qword[r15]
        jmp .loop
    .quit_loop:
    lea rdi, [r13 + 12]
    call AsmLock
    mov r11, qword[rbx]
    mov qword[r15], r11
    lea rdi, [r13 + 12]
    call AsmUnlock
    mov r8, qword[rbx + 8]
    mov qword[r14], r8
    mov r8, qword[rbx + 16]
    mov qword[r14 + 8], r8
    mov r8, qword[rbx + 24]
    mov qword[r14 + 16], r8
    mov r8, qword[rbx + 32]
    mov qword[r14 + 24], r8
    mov rdi, rbx
    call AsmDalloc
    mov rax, 1
    .bye:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    .bye0:
    ret

    .window4:
        mov r8d, dword[rbx + 8 + 4]
        cmp dword[WINDOW_ID], r8d
        je .quit_loop
        jmp .next_event
    .window8:
        mov r8d, dword[rbx + 8 + 8]
        cmp dword[WINDOW_ID], r8d
        je .quit_loop
        jmp .next_event
    .window12:
        mov r8d, dword[rbx + 8 + 12]
        cmp dword[WINDOW_ID], r8d
        je .quit_loop
        jmp .next_event
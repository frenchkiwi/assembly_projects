section .data
    wm_delete_window db "WM_DELETE_WINDOW", 0

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
        jne .next_event
        cmp byte[rbx + 8], 22
        je .configure_notify
        cmp byte[rbx + 8], 33
        je .client_message
        jmp .quit_loop
    .configure_notify:
        mov byte[WINDOW_EVENT], 0
        .pos_diff:
        cmp dword[rbx + 8 + 16], 0
        je .size_diff
        mov r8d, dword[rbx + 8 + 16]
        cmp dword[WINDOW_POS], r8d
        je .size_diff
        mov dword[WINDOW_POS], r8d
        add byte[WINDOW_EVENT], 1
        .size_diff:
        mov r8d, dword[rbx + 8 + 20]
        cmp dword[WINDOW_SIZE], r8d
        je .quit_loop
        mov dword[WINDOW_SIZE], r8d
        add byte[WINDOW_EVENT], 2
        sub rsp, 32
        mov byte[rsp], 53 ; code create_pixmap
        mov r8b, byte[WINDOW_DEPTH]
        mov byte[rsp + 1], r8b ; depth
        mov word[rsp + 2], 4 ; length
        mov r8, qword[WINDOW_LINK]
        mov r9d, dword[r8 + 8]
        mov dword[rsp + 4], r9d ; set pixmap_id
        inc dword[r8 + 8]
        mov r10d, dword[WINDOW_PIXMAP] ; save old pixmap in r10
        mov dword[WINDOW_PIXMAP], r9d ; load pixmap_ip in window
        mov r8d, dword[WINDOW_ID]
        mov dword[rsp + 8], r8d ; set window_id
        mov r8d, dword[WINDOW_SIZE]
        mov dword[rsp + 12], r8d ; set size

        mov rax, 1
        mov rdi, qword[WINDOW_LINK]
        mov rdi, qword[rdi]
        lea rsi, [rsp]
        mov rdx, 16
        syscall

        mov byte[rsp], 62 ; code copy area
        mov word[rsp + 2], 7 ; length
        mov r8d, dword[WINDOW_PIXMAP]
        mov dword[rsp + 8], r8d ; new pixmap dest
        mov dword[rsp + 4], r10d ; old pixmap src
        mov r8d, dword[WINDOW_GC]
        mov dword[rsp + 12], r8d ; gc
        mov dword[rsp + 16], 0 ; x and y dest
        mov dword[rsp + 20], 0 ; x and y src
        mov r8d, dword[WINDOW_SIZE]
        mov dword[rsp + 24], r8d ; width and heigth

        mov rax, 1
        mov rdi, qword[WINDOW_LINK]
        mov rdi, qword[rdi]
        lea rsi, [rsp]
        mov rdx, 28
        syscall

        mov byte[rsp], 54 ; code delete_pixmap
        mov word[rsp + 2], 2 ; length
        mov dword[rsp + 4], r10d ; pixmap_id

        mov rax, 1
        mov rdi, qword[WINDOW_LINK]
        mov rdi, qword[rdi]
        lea rsi, [rsp]
        mov rdx, 8
        syscall

        add rsp, 32
        jmp .quit_loop
    .client_message:
        sub rsp, 8
        mov byte[rsp], 17
        mov word[rsp + 2], 2
        mov r8d, dword[rbx + 8 + 12]
        mov dword[rsp + 4], r8d

        mov rax, 1
        mov rdi, qword[WINDOW_LINK]
        mov rdi, qword[rdi]
        lea rsi, [rsp]
        mov rdx, 8
        syscall
        add rsp, 8

        mov rdi, r12
        mov rsi, 1
        call AsmWaitEvent
        mov r9, rax
        mov rdi, r9
        add rdi, 8 + 32
        lea rsi, [rel wm_delete_window]
        xor rdx, rdx
        mov dx, word[r9 + 8 + 8]
        call AsmStrncmp
        push rax
        mov rdi, r9
        call AsmDalloc
        pop rax
        cmp rax, 0
        jne .quit_loop
        mov byte[rbx + 8], 35

        jmp .quit_loop
    
    .window8:
        mov r8d, dword[rbx + 8 + 8]
        cmp dword[WINDOW_ID], r8d
        jne .next_event
        jmp .quit_loop
    .window12:
        mov r8d, dword[rbx + 8 + 12]
        cmp dword[WINDOW_ID], r8d
        jne .next_event
        jmp .quit_loop
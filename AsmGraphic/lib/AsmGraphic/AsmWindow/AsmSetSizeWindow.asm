section .data

section .text
    global AsmSetSizeWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetSizeWindow:
   cmp rdi, 0
    je .bye_error0

    sub rsp, 24
    mov byte[rsp], 12
    mov word[rsp + 2], 5
    mov r8d, dword[rdi]
    mov dword[rsp + 4], r8d
    mov word[rsp + 8], 0x4 | 0x8 ; width | heigth
    movzx r8, si
    mov dword[rsp + 12], r8d
    shr rsi, 16
    movzx r8, si
    mov dword[rsp + 16], r8d

    mov r8, rdi
    mov rax, 1
    mov rdi, qword[rdi + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 20
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error0

    push r12
    mov r12, r8

    mov rdi, r12
    mov rsi, 22
    call AsmWaitEvent
    mov r8d, dword[rax + 8 + 20]
    mov dword[WINDOW_SIZE], r8d
    mov rdi, rax
    call AsmDalloc

    mov rdi, r12
    mov rsi, 22
    call AsmWaitEvent
    mov rdi, rax
    call AsmDalloc

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
    pop r12

    xor rax, rax
    ret

    .bye_error:
        pop r12
    .bye_error0:
        mov rax, -1
        ret
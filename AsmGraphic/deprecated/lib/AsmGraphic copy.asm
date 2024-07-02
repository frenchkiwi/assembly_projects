section .text
    global aWindowUpdate
    global aIsWindowClosing
    global aIsWindowMoving
    global aIsWindowResizing
    global aGetWindowPosition
    global aGetWindowSize
    global aBell

aWindowUpdate:
    mov byte[rsi + 19], 0
    mov r10d, dword[rdx + 20]
    push rsi
    push rdx
    cmp dword[rsi + 12], r10d
    jne .resize
    .quit_resize:
    pop rdx
    pop rsi
    mov r10d, dword[rdx + 16]
    cmp dword[rsi + 8], r10d
    jne .move
    .quit_move:
    ret

    .resize:
        add byte[rsi + 19], 2
        mov dword[rsi + 12], r10d
        CALL_ my_malloc, 28
        mov r9, rax

        mov r8d, dword[rsi + 4]
        push r8 ; save old pixmap_id

        mov byte[r9], 53 ; code create_pixmap
        mov r10b, byte[rsi + 16]
        mov byte[r9 + 1], r10b ; depth
        mov word[r9 + 2], 4 ; length
        mov r10d, dword[rdi + 24]
        mov dword[r9 + 4], r10d
        mov r10d, dword[rel generate_id]
        add dword[r9 + 4], r10d ; set pixmap_id
        inc dword[rel generate_id]
        mov r10d, dword[r9 + 4]
        mov dword[rsi + 4], r10d ; load pixmap_ip in window
        mov r10d, dword[rsi]
        mov dword[r9 + 8], r10d ; set window_id
        mov r10d, dword[rsi + 12]
        mov dword[r9 + 12], r10d ; set size

        push rdi
        push rsi
        mov rax, 1
        xor r10, r10
        mov r10d, dword[rdi]
        mov rdi, r10
        lea rsi, [r9]
        mov rdx, 16
        syscall
        pop rsi
        pop rdi

        pop r8 ; reload old pixmap_id
        push r8 ; save old pixmap_id

        mov byte[r9], 62 ; code copy area
        mov word[r9 + 2], 7 ; length
        mov r10d, dword[rsi + 4]
        mov dword[r9 + 8], r10d ; new pixmap dest
        mov dword[r9 + 4], r8d ; old pixmap src
        mov r10d, dword[rdi + 48]
        mov dword[r9 + 12], r10d ; gc
        mov dword[r9 + 16], 0 ; x and y dest
        mov dword[r9 + 20], 0 ; x and y src
        mov r10d, dword[rsi + 12]
        mov dword[r9 + 24], r10d ; width and heigth

        push rdi
        push rsi
        mov rax, 1
        xor r10, r10
        mov r10d, dword[rdi]
        mov rdi, r10
        lea rsi, [r9]
        mov rdx, 28
        syscall
        pop rsi
        pop rdi

        pop r8 ; reload old pixmap_id
        mov byte[r9], 54 ; code delete_pixmap
        mov word[r9 + 2], 2 ; length
        mov dword[r9 + 4], r8d ; pixmap_id

        push rdi
        push rsi
        mov rax, 1
        xor r10, r10
        mov r10d, dword[rdi]
        mov rdi, r10
        lea rsi, [r9]
        mov rdx, 8
        syscall
        pop rsi
        pop rdi

        CALL_ my_free, r9
        jmp .quit_resize
    
    .move:
        mov dword[rsi + 8], r10d
        add byte[rsi + 19], 1
        jmp .quit_move

aIsWindowClosing:
    CALL_ my_malloc, 8
    mov r9, rax

    mov r10d, dword[rdx + 4]
    cmp dword[rsi], r10d
    jne .bye_zero
    
    mov byte[r9], 17
    mov word[r9 + 2], 2
    mov r10d, dword[rdx + 12]
    mov dword[r9 + 4], r10d

    push rdi
    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 8
    syscall
    pop rdi

    CALL_ my_free, r9

    CALL_ wait_reply, rdi
    mov r9, rax
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10

    xor r10, r10
    mov r10w, word[r9 + 16]
    cmp r10w, 16
    jne .bye_zero

    xor r10, r10
    lea r10, [rel closed_atom]
    mov r11, r9
    add r11, 40
    CALL_ my_strncmp, r10, r11, 16
    cmp rax, 0
    jne .bye_zero

    CALL_ my_free, r9

    mov rax, 1
    ret

    .bye_zero:
        CALL_ my_free, r9
        mov rax, 0
        ret

aIsWindowMoving:
    xor rax, rax
    mov al, byte[rdi + 19]
    or rax, 1
    cmp al, byte[rdi + 19]
    je .bye_1
    mov rax, 0
    ret
    .bye_1:
    mov rax, 1
    ret

aIsWindowResizing:
    xor rax, rax
    mov al, byte[rdi + 19]
    or rax, 2
    cmp al, byte[rdi + 19]
    je .bye_1
    mov rax, 0
    ret
    .bye_1:
    mov rax, 1
    ret
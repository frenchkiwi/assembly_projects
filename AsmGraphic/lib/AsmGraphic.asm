%include "AsmFunctions.asm"

section .data
    generate_id dd 0
    font_error dd "Font can't be load."
    closed_atom dd "WM_DELETE_WINDOW", 0

section .text
    global aCreateLink
    global aCloseLink
    global aCreateContext
    global aCreateWindow
    global aMapWindow
    global aCloseWindow
    global aOpenFont
    global aPollEvent
    global aWindowUpdate
    global aIsWindowClosing
    global aClearWindow
    global aDisplayWindow
    global aGetWindowFps
    global aGetWindowPosition
    global aGetWindowSize
    global aCreateText
    global aDrawText
    global aDestroyText
    global aCreateRectangle
    global aDrawRectangle
    global aDestroyRectangle
    global aBell
    global test_truc

aCreateLink:
    mov rax, 41
    mov rdi, 1
    mov rsi, 1
    mov rdx, 0
    syscall
    mov r8, rax

    cmp r8, 0
    jl .bye_error

    push r8
    mov rdi, 110
    mov rsi, 0
    call calloc
    mov r9, rax
    pop r8

    mov word[r9], 1
    mov byte[r9 + 2], '/'
    mov byte[r9 + 3], 't'
    mov byte[r9 + 4], 'm'
    mov byte[r9 + 5], 'p'
    mov byte[r9 + 6], '/'
    mov byte[r9 + 7], '.'
    mov byte[r9 + 8], 'X'
    mov byte[r9 + 9], '1'
    mov byte[r9 + 10], '1'
    mov byte[r9 + 11], '-'
    mov byte[r9 + 12], 'u'
    mov byte[r9 + 13], 'n'
    mov byte[r9 + 14], 'i'
    mov byte[r9 + 15], 'x'
    mov byte[r9 + 16], '/'
    mov byte[r9 + 17], 'X'
    mov byte[r9 + 18], '0'

    mov rax, 42
    mov rdi, r8
    mov rsi, r9
    mov rdx, 110
    syscall

    cmp rax, 0
    jne .bye_error_free

    push r8
    mov rdi, r9
    call free
    pop r8

    push r8
    mov rdi, 12
    mov rsi, 0
    call calloc
    mov r9, rax
    pop r8

    mov byte[r9], 'l'
    mov word[r9 + 2], 11

    mov rax, 1
    mov rdi, r8
    mov rsi, r9
    mov rdx, 12
    syscall

    push r8
    mov rdi, r9
    call free
    
    mov rdi, 8
    mov rsi, 0
    call calloc
    mov r11, rax
    pop r8

    push r11
    mov rax, 0
    mov rdi, r8
    mov rsi, r11
    mov rdx, 8
    syscall
    pop r11

    cmp byte[r11], 1
    jne .bye_error

    xor r10, r10
    mov r10w, word[r11 + 6]

    mov rax, r10
    mov rbx, 4
    mul rbx

    push r8
    push r11
    push rax
    mov rdi, rax
    add rdi, 20
    mov rsi, 0
    call calloc
    mov r9, rax
    pop r10
    pop r11
    pop r8

    mov dword[r9], r8d

    mov rcx, 11
    .loop_copy_header:
        inc rcx
        mov dl, byte[r11 + rcx - 4]
        mov byte[r9 + rcx], dl
        cmp rcx, 12
        jne .loop_copy_header

    push r9
    push r10
    mov rdi, r11
    call free
    pop r10
    pop r9

    mov rax, 0
    movzx rdi, byte[r9]
    mov rsi, r9
    add rsi, 20
    mov rdx, r10
    syscall

    cmp rax, 20
    jl .bye_error_free

    mov rdi, r9
    push r9

    xor r8, r8
    mov r8, rdi ; get socket_fd

    push rdi
    push r8
    push rsi
    mov rdi, 24 ; add basic need for this request
    call malloc
    mov r9, rax ; set my message
    pop rsi
    pop r8

    mov byte[r9], 55 ; code
    mov word[r9 + 2], 6 ; length of request

    mov r10d, dword[r8 + 24]
    mov dword[r9 + 4], r10d
    mov r10d, dword[rel generate_id]
    add dword[r9 + 4], r10d ; set context_id
    inc dword[rel generate_id]

    mov r10, r8
    add r10, 20
    add r10, 32 ; set r10 at end of know info
    xor r11, r11
    mov r11w, word[r8 + 36]
    add r10, r11 ; add vendor length
    xor rax, rax
    mov al, byte[r8 + 41]
    mov r11, 8
    mul r11
    add r10, rax ; add format length

    mov r11d, dword[r10]
    mov dword[r9 + 8], r11d ; set parent

    mov dword[r9 + 12], 65540 ; set flag foreground

    mov dword[r9 + 16], 13107455 ; set color foreground

    mov dword[r9 + 20], 0 ; set color foreground

    mov rax, 1
    xor rdi, rdi
    mov edi, dword [r8]
    lea rsi, [r9]
    mov rdx, 24
    syscall ; send my message

    pop rdi
    mov r10d, dword[r9 + 4]
    mov dword[rdi + 48], r10d
    mov rdi, r9
    call free

    pop rax
    .bye:
        ret
    .bye_error:
        mov rax, 0
        ret
    .bye_error_free:
        mov rdi, r9
        call free
        mov rax, 0
        ret

aCloseLink:
    cmp rdi, 0
    je .bye_error

    CALL_ malloc, 4
    mov r9, rax

    mov byte[r9], 112
    mov byte[r9 + 1], 0
    mov word[r9 + 2], 1

    push rdi
    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    mov rsi, r9
    mov rdx, 4
    syscall
    pop rdi

    CALL_ free, r9

    CALL_ free, rdi

    ret
    .bye_error:
        mov rax, -1
        ret

aCreateContext:
    xor r8, r8
    mov r8, rdi ; get socket_fd

    push rdi
    push r8
    push rsi
    mov rdi, 24 ; add basic need for this request
    call malloc
    mov r9, rax ; set my message
    pop rsi
    pop r8

    mov byte[r9], 55
    mov word[r9 + 2], 6

    mov r10d, dword[r8 + 24]
    mov dword[r9 + 4], r10d
    mov r10d, dword[rel generate_id]
    add dword[r9 + 4], r10d ; set context_id
    inc dword[rel generate_id]

    mov r10, r8
    add r10, 20
    add r10, 32 ; set r10 at end of know info
    xor r11, r11
    mov r11w, word[r8 + 36]
    add r10, r11 ; add vendor length
    xor rax, rax
    mov al, byte[r8 + 41]
    mov r11, 8
    mul r11
    add r10, rax ; add format length

    mov r11d, dword[r10]
    mov dword[r9 + 8], r11d ; set parent

    mov dword[r9 + 12], 12 ; set flag background et foreground

    mov dword[r9 + 16], 13107455 ; set color foreground

    mov dword[r9 + 20], 0 ; set color background

    mov rax, 1
    xor rdi, rdi
    mov edi, dword [r8]
    lea rsi, [r9]
    mov rdx, 24
    syscall ; send my message

    pop rdi
    mov r10d, dword[r9 + 4]
    mov dword[rdi + 48], r10d
    mov rdi, r9
    call free
    
    ret

aCreateWindow:
    xor r8, r8
    mov r8, rdi ; get socket_fd
    
    push rdi
    push r8
    push rsi
    mov rdi, 32 ; add basic need for this request
    add rdi, 8 ; add 2 value
    call malloc
    mov r9, rax ; set my message
    pop rsi
    pop r8

    mov byte[r9], 1 ; set create_window request
    mov byte[r9 + 1], 0 ; set depth
    mov word[r9 + 2], 10 ; set length

    mov r10d, dword[r8 + 24]
    mov dword[r9 + 4], r10d
    mov r10d, dword[rel generate_id]
    add dword[r9 + 4], r10d ; set window_id
    inc dword[rel generate_id]

    mov r10, r8
    add r10, 20
    add r10, 32 ; set r10 at end of know info
    xor r11, r11
    mov r11w, word[r8 + 36]
    add r10, r11 ; add vendor length
    xor rax, rax
    mov al, byte[r8 + 41]
    mov r11, 8
    mul r11
    add r10, rax ; add format length

    mov r11d, dword[r10]
    mov dword[r9 + 8], r11d ; set parent

    add r10, 32
    mov r11d, dword[r10]
    mov dword[r9 + 24], r11d ; set visual 

    mov word[r9 + 12], 200 ; set x
    mov word[r9 + 14], 200 ; set y

    mov r10w, word[rsi]
    mov word[r9 + 16], r10w ; set width
    mov r10w, word[rsi + 2]
    mov word[r9 + 18], r10w ; set height

    mov word[r9 + 20], 1 ; set group/class
    mov word[r9 + 22], 1 ; set border-width

    mov dword[r9 + 28], 2050 ; set bitmask

    mov dword[r9 + 32], 0; set first value at purple

    mov dword[r9 + 36], 163845 ; key press | button press | structure_notify

    mov rax, 1
    xor rdi, rdi
    mov edi, dword [r8]
    lea rsi, [r9]
    mov rdx, 40
    syscall ; send my message

    xor rax, rax
    mov eax, dword[r9 + 4]

    push rax
    mov rdi, r9
    call free

    CALL_ malloc, 18
    mov r8, rax
    pop rax
    mov dword[r8], eax

    pop rdi
    mov rsi, rax
    push r8
    push rdi

    push rsi
    CALL_ malloc, 24
    mov r9, rax

    mov byte[r9], 16 ; code
    mov byte[r9 + 1], 1 ; only if exits
    mov word[r9 + 2], 6 ; 2 + 16 / 4
    mov word[r9 + 4], 16 ; strlen de l'atom
    mov byte[r9 + 8], 'W'
    mov byte[r9 + 9], 'M'
    mov byte[r9 + 10], '_'
    mov byte[r9 + 11], 'D'
    mov byte[r9 + 12], 'E'
    mov byte[r9 + 13], 'L'
    mov byte[r9 + 14], 'E'
    mov byte[r9 + 15], 'T'
    mov byte[r9 + 16], 'E'
    mov byte[r9 + 17], '_'
    mov byte[r9 + 18], 'W'
    mov byte[r9 + 19], 'I'
    mov byte[r9 + 20], 'N'
    mov byte[r9 + 21], 'D'
    mov byte[r9 + 22], 'O'
    mov byte[r9 + 23], 'W'

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 24
    syscall

    CALL_ free, r9

    CALL_ malloc, 32
    mov r9, rax

    mov rax, 0
    mov rdi, rdi
    lea rsi, [r9]
    mov rdx, 32
    syscall

    xor r8, r8
    mov r8d, dword[r9 + 8]

    CALL_ free, r9

    CALL_ malloc, 20
    mov r9, rax

    mov byte[r9], 16 ; code
    mov byte[r9 + 1], 0 ; only if exits
    mov word[r9 + 2], 5 ; 2 + 12 / 4
    mov word[r9 + 4], 12 ; strlen de l'atom
    mov byte[r9 + 8], 'W'
    mov byte[r9 + 9], 'M'
    mov byte[r9 + 10], '_'
    mov byte[r9 + 11], 'P'
    mov byte[r9 + 12], 'R'
    mov byte[r9 + 13], 'O'
    mov byte[r9 + 14], 'T'
    mov byte[r9 + 15], 'O'
    mov byte[r9 + 16], 'C'
    mov byte[r9 + 17], 'O'
    mov byte[r9 + 18], 'L'
    mov byte[r9 + 19], 'S'

    mov rax, 1
    mov rdi, rdi
    lea rsi, [r9]
    mov rdx, 20
    syscall

    CALL_ free, r9

    CALL_ malloc, 32
    mov r9, rax

    mov rax, 0
    mov rdi, rdi
    lea rsi, [r9]
    mov rdx, 32
    syscall

    xor r10, r10
    mov r10d, dword[r9 + 8]

    CALL_ free, r9

    CALL_ malloc, 28
    mov r9, rax

    pop rsi
    mov byte[r9], 18 ; code
    mov byte[r9 + 1], 0 ; replace
    mov word[r9 + 2], 7 ; 6 + 1
    mov dword[r9 + 4], esi ; window_id
    mov dword[r9 + 8], r10d ; WM_PROTOCOLS atom
    mov dword[r9 + 12], 4 ; blk du type
    mov byte[r9 + 16], 32 ; format en 4octet
    mov dword[r9 + 20], 1 ; 1 atom
    mov dword[r9 + 24], r8d

    push rsi
    mov rax, 1
    mov rdi, rdi
    lea rsi, [r9]
    mov rdx, 28
    syscall

    CALL_ free, r9

    pop rsi
    pop rdi

    CALL_ malloc, 8
    mov r9, rax

    mov byte[r9], 14
    mov word[r9 + 2], 2
    xor r10, r10
    mov r10d, esi
    mov dword[r9 + 4], r10d

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

    CALL_ free, r9

    CALL_ wait_reply, rdi

    pop r8
    mov r10d, dword[rax + 12]
    mov dword[r8 + 8], r10d
    mov r11d, dword[rax + 16]
    mov dword[r8 + 12], r11d
    mov r10b, byte[rax + 1]
    mov byte[r8 + 16], r10b
    push r8
    mov r8b, byte[rax + 1]

    CALL_ free, rax

    CALL_ malloc, 16
    mov r9, rax

    mov byte[r9], 53 ; create pixmap
    mov byte[r9 + 1], r8b ; set depth
    mov word[r9 + 2], 4 ; set length
    mov r10d, dword[rdi + 24]
    mov dword[r9 + 4], r10d
    mov r10d, dword[rel generate_id]
    add dword[r9 + 4], r10d ; set pixmap id
    inc dword[rel generate_id]
    mov dword[r9 + 8], esi ; set ref window id
    mov dword[r9 + 12], r11d ; set width and heigth

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 16
    syscall

    pop r8
    mov r10d, dword[r9 + 4]
    mov dword[r8 + 4], r10d
    mov byte[r8 + 17], 244

    CALL_ free, r9

    mov rax, r8

    ret

aMapWindow:
    CALL_ malloc, 8
    mov r9, rax

    mov byte[r9], 8
    mov byte[r9 + 1], 0
    mov word[r9 + 2], 2
    mov r10d, dword[rsi]
    mov dword[r9 + 4], r10d

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 8
    syscall

    CALL_ free, r9

    ret

aCloseWindow:
    CALL_ malloc, 8
    mov r9, rax

    mov byte[r9], 4
    mov word[r9 + 2], 2
    mov r10d, dword[rsi]
    mov dword[r9 + 4], r10d

    push rsi
    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 8
    syscall
    pop rsi

    mov byte[r9], 54
    mov word[r9 + 2], 2
    mov r10d, dword[rsi + 4]
    mov dword[r9 + 4], r10d

    push rsi
    mov rax, 1
    mov rdi, rdi
    lea rsi, [r9]
    mov rdx, 8
    syscall
    pop rsi

    CALL_ free, r9

    CALL_ free, rsi

    ret

aOpenFont:
    push rdi
    CALL_ strlen, rsi
    mov rdx, rax
    neg rax
    and rax, -4
    neg rax
    add rax, 12
    push rax
    CALL_ malloc, rax
    mov r9, rax
    pop rax
    push rax

    mov byte[r9], 45
    push rdx
    mov r10, 4
    xor rdx, rdx
    div r10
    pop rdx

    mov word[r9 + 2], ax

    mov r10d, dword[rdi + 24]
    mov dword[r9 + 4], r10d
    mov r10d, dword[rel generate_id]
    add dword[r9 + 4], r10d ; set font_id
    xor r10, r10
    mov r10d, dword[r9 + 4]
    push r10
    inc dword[rel generate_id]

    mov dword[r9 + 8], edx

    mov rcx, 0
    .loop:
        cmp rcx, rdx
        je .quit_loop
        mov r10b, byte[rsi + rcx]
        mov byte[r9 + 12 + rcx], r10b
        inc rcx
        jmp .loop
    .quit_loop:
    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    pop r10
    pop rdx
    push rdx
    push r10
    syscall

    push rax
    CALL_ free, r9
    pop rax

    pop r8
    pop rdx
    cmp rax, rdx
    jne .error

    CALL_ malloc, 16
    mov r9, rax

    pop rdi
    mov byte[r9], 56
    mov word[r9 + 2], 4
    xor r10, r10
    mov r10d, dword[rdi + 48]
    mov dword[r9 + 4], r10d
    mov dword[r9 + 8], 16384
    mov dword[r9 + 12], r8d

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 16
    syscall

    CALL_ free, r9

    ret

    .error:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_error]
        mov rdx, 19
        syscall
        ret

aPollEvent:
    cmp qword[rdi + 4], 0
    jne .read_queue

    push rdi
    push rsi
    mov rax, 72
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    mov rsi, 3
    mov rdx, 0
    syscall

    mov rdx, rax
    or rdx, 2048

    mov rax, 72
    mov rsi, 4
    mov rdx, rdx
    syscall
    pop rsi
    pop rdi

    CALL_ malloc, 8
    mov r9, rax

    mov r10d, dword[rdi]
    mov dword[r9], r10d
    mov dword[r9 + 4], 1

    push rdi
    push rsi
    mov rax, 7
    lea rdi, [r9]
    mov rsi, 1
    mov rdx, 0
    syscall
    pop rsi
    pop rdi

    cmp rax, 0
    je .bye_no_event

    cmp word[r9 + 6], 8
    je _exit

    cmp word[r9 + 6], 16
    je _exit

    CALL_ free, r9

    CALL_ calloc, 32, 0
    mov r9, rax

    push rdi
    push rsi
    mov rax, 0
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 32
    syscall
    pop rsi
    pop rdi

    cmp rax, 1
    jle _exit

    mov r10, qword[r9]
    mov qword[rsi], r10
    mov r10, qword[r9 + 8]
    mov qword[rsi + 8], r10
    mov r10, qword[r9 + 16]
    mov qword[rsi + 16], r10
    mov r10, qword[r9 + 24]
    mov qword[rsi + 24], r10

    CALL_ free, r9

    mov rax, 72
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    mov rsi, 3
    mov rdx, 0
    syscall

    mov rdx, rax
    xor rdx, 2048

    mov rax, 72
    mov rsi, 4
    mov rdx, rdx
    syscall

    mov rax, 1
    ret
    .bye_no_event:
        CALL_ free, r9

        mov rax, 72
        xor r10, r10
        mov r10d, dword[rdi]
        mov rdi, r10
        mov rsi, 3
        mov rdx, 0
        syscall

        mov rdx, rax
        xor rdx, 2048

        mov rax, 72
        mov rsi, 4
        mov rdx, rdx
        syscall
        mov rax, 0
        ret

    .read_queue:
        mov r9, qword[rdi + 4]
        mov r10, qword[r9 + 32]
        mov qword[rdi + 4], r10

        mov r10, qword[r9]
        mov qword[rsi], r10
        mov r10, qword[r9 + 8]
        mov qword[rsi + 8], r10
        mov r10, qword[r9 + 16]
        mov qword[rsi + 16], r10
        mov r10, qword[r9 + 24]
        mov qword[rsi + 24], r10

        CALL_ free, r9

        mov rax, 1
        ret

aWindowUpdate:
    mov r10d, dword[rdx + 20]
    cmp dword[rsi + 12], r10d
    jne .resize
    .quit_resize:
    ret

    .resize:
        mov dword[rsi + 12], r10d
        CALL_ malloc, 28
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

        CALL_ free, r9
        jmp .quit_resize
        

aIsWindowClosing:
    CALL_ malloc, 8
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

    CALL_ free, r9

    CALL_ wait_reply, rdi
    mov r9, rax
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10

    xor r10, r10
    mov r10w, word[r9 + 8]
    cmp r10w, 16
    jne .bye_zero

    mov rax, 0
    mov rdi, rdi
    lea rsi, [r9]
    mov rdx, 16
    syscall

    xor r10, r10
    lea r10, [rel closed_atom]
    CALL_ strncmp, r10, r9, 16
    cmp rax, 0
    jne .bye_zero

    CALL_ free, r9

    mov rax, 1
    ret

    .bye_zero:
        CALL_ free, r9
        mov rax, 0
        ret

aGetWindowFps:
    xor rax, rax
    mov al, byte[rdi + 17]
    ret

aGetWindowPosition:
    xor rax, rax
    mov eax, dword[rdi + 8]
    ret

aGetWindowSize:
    xor rax, rax
    mov eax, dword[rdi + 12]
    ret

aClearWindow:
    CALL_ malloc, 12
    mov r9, rax

    mov word[r9], 0
    mov word[r9 + 2], 0
    mov r10d, dword[rsi + 12]
    mov dword[r9 + 4], r10d
    mov dword[r9 + 8], 0
    xor r10, r10
    mov r10w, word[rsi + 14]

    CALL_ aDrawRectangle, rdi, rsi, r9

    CALL_ free, r9

    ret

aDisplayWindow:
    CALL_ malloc, 28
    mov r9, rax

    mov byte[r9], 62 ; code copy area
    mov word[r9 + 2], 7 ; length
    mov r10d, dword[rsi]
    mov dword[r9 + 8], r10d ; window dest
    mov r10d, dword[rsi + 4]
    mov dword[r9 + 4], r10d ; pixmap src
    mov r10d, dword[rdi + 48]
    mov dword[r9 + 12], r10d ; gc
    mov dword[r9 + 16], 0 ; x and y dest
    mov dword[r9 + 20], 0 ; x and y src
    mov r10d, dword[rsi + 12]
    mov dword[r9 + 24], r10d ; width and heigth

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 28
    syscall
    
    CALL_ free, r9

    ret

aCreateText:
    push rdi
    push rsi
    push rdx
    mov rdi, 16
    call malloc
    mov r9, rax
    pop rdx
    pop rsi
    pop rdi
    CALL_ strdup, rdi
    mov qword[r9], rax
    mov r10w, si
    mov word[r9 + 8], r10w
    shr rsi, 16
    mov r10w, si
    mov word[r9 + 10], r10w
    mov byte[r9 + 15], 0
    mov r10b, byte[rdx]
    mov byte[r9 + 14], r10b
    mov r10b, byte[rdx + 1]
    mov byte[r9 + 13], r10b
    mov r10b, byte[rdx + 2]
    mov byte[r9 + 12], r10b

    mov rax, r9
    ret

aDrawText:
    push rdi
    push rsi
    push rdx

    CALL_ malloc, 16
    mov r9, rax

    mov byte[r9], 56 ; code for change gc
    mov word[r9 + 2], 4 ; lentgh
    mov r10d, dword[rdi + 48]
    mov dword[r9 + 4], r10d ; context_id
    mov dword[r9 + 8], 4 ; change foreground color
    xor r10, r10
    mov r10d, dword[rdx + 12]
    mov dword[r9 + 12], r10d

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 16
    syscall

    CALL_ free, r9

    pop rdx
    pop rsi
    pop rdi

    mov rcx, rdx
    add rcx, 8
    mov rdx, qword[rdx] ; decompose aText struct

    CALL_ strlen, rdx
    xor r10, r10
    mov r10b, al
    neg r10
    and r10, -4
    neg r10
    add r10, 16
    push r10
    ; get size to malloc

    CALL_ malloc, r10
    mov r9, rax

    mov byte[r9], 76 ; code
    CALL_ strlen, rdx
    mov byte[r9 + 1], al ; length of string
    push rdx
    mov rax, r10
    xor rdx, rdx
    mov rbx, 4
    div rbx
    mov word[r9 + 2], ax ; length of basic request + additionnal data
    pop rdx

    mov r10d, dword[rsi + 4]
    mov dword[r9 + 4], r10d ; window_id
    mov r10d, dword[rdi + 48]
    mov dword[r9 + 8], r10d ; context_id
    mov r10w, word[rcx]
    mov word[r9 + 12], r10w ; x
    mov r10w, word[rcx + 2]
    mov word[r9 + 14], r10w ; y

    xor rcx, rcx
    .loop: ; copy string
        cmp byte[r9 + 1], cl
        je .quit_loop
        xor r10, r10
        mov r10b, byte[rdx + rcx]
        mov byte[r9 + 16 + rcx], r10b
        inc rcx
        jmp .loop

    .quit_loop:
    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    pop rdx
    syscall

    CALL_ free, r9

    ret

aDestroyText:
    mov r10, qword[rdi]
    CALL_ free, r10
    CALL_ free, rdi
    ret

aCreateRectangle:
    push rdi
    push rsi
    mov rdi, 12
    call malloc
    mov r9, rax
    pop rsi
    pop rdi
    mov r10w, di
    mov word[r9], r10w
    shr rdi, 16
    mov r10w, di
    mov word[r9 + 2], r10w
    shr rdi, 16
    mov r10w, di
    mov word[r9 + 4], r10w
    shr rdi, 16
    mov r10w, di
    mov word[r9 + 6], r10w
    mov byte[r9 + 11], 0
    mov r10b, byte[rsi]
    mov byte[r9 + 10], r10b
    mov r10b, byte[rsi + 1]
    mov byte[r9 + 9], r10b
    mov r10b, byte[rsi + 2]
    mov byte[r9 + 8], r10b

    mov rax, r9
    ret

aDrawRectangle:
    push rdi
    push rsi
    push rdx

    CALL_ malloc, 16
    mov r9, rax

    mov byte[r9], 56 ; code for change gc
    mov word[r9 + 2], 4 ; lentgh
    mov r10d, dword[rdi + 48]
    mov dword[r9 + 4], r10d ; context_id
    mov dword[r9 + 8], 4 ; change foreground color
    add rdx, 8
    xor r10, r10
    mov r10d, dword[rdx]
    mov dword[r9 + 12], r10d

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 16
    syscall

    CALL_ free, r9

    pop rdx
    pop rsi
    pop rdi

    CALL_ malloc, 20
    mov r9, rax

    mov byte[r9], 70 ; code
    mov word[r9 + 2], 5 ; length of request

    mov r10d, dword[rsi + 4]
    mov dword[r9 + 4], r10d ; window_id
    mov r10d, dword[rdi + 48]
    mov dword[r9 + 8], r10d ; context_id
    mov r10w, word[rdx]
    mov word[r9 + 12], r10w ; x
    mov r10w, word[rdx + 2]
    mov word[r9 + 14], r10w ; y
    mov r10w, word[rdx + 4]
    mov word[r9 + 16], r10w ; width
    mov r10w, word[rdx + 6]
    mov word[r9 + 18], r10w ; height

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 20
    syscall

    CALL_ free, r9

    ret

aDestroyRectangle:
    CALL_ free, rdi
    ret

aBell:
    cmp rsi, -100
    jl .bye
    cmp rsi, 100
    jg .bye

    CALL_ malloc, 4
    mov r9, rax

    mov byte[r9], 104
    mov byte[r9 + 1], sil
    mov word[r9 + 2], 1

    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 4
    syscall

    CALL_ free, r9
    .bye:
    ret
_exit:
    mov rax, 60
    mov rdi, 1
    syscall

wait_reply:
    .loop:
        CALL_ malloc, 40
        mov r9, rax

        mov qword[r9 + 32], 0

        push rdi
        mov rax, 0
        xor r10, r10
        mov r10d, dword[rdi]
        mov rdi, r10
        lea rsi, [r9]
        mov rdx, 32
        syscall
        pop rdi

        cmp byte[r9], 1
        je .quit_loop

        mov r8, rdi
        sub r8, 28

        .go_to_last:
            cmp qword[r8 + 32], 0
            je .save_data
            mov r8, qword[r8 + 32]
            jmp .go_to_last

        .save_data:
        mov qword[r8 + 32], r9
        jmp .loop

    .quit_loop:
    mov rax, r9
    ret

test_truc:
    CALL_ malloc, 32
    mov r9, rax

    mov rax, 0
    mov rdi, 3
    lea rsi, [r9]
    mov rdx, 32
    syscall

    xor r10, r10
    mov r10b, byte[r9]
    CALL_ putnbr, r10
    CALL_ putchar, 10

    CALL_ free, r9

    ret

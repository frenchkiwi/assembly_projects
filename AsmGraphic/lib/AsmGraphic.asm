%include "AsmFunctions.asm"

%ifndef ASMGRAPHIC_MACRO
    %define ASMGRAPHIC_MACRO
    %define LINK_SOCKET 0
    %define LINK_EVENT_QUEUE 4
    %define LINK_HEADER 12
    %define LINK_BODY 20
    %define LINK_ID 24
    %define LINK_VENDOR_LENGTH 36
    %define LINK_FORMAT_LENGTH 41
    %define EVENT_NEXT 0
    %define EVENT_TYPE 8
%endif

section .data
    generate_id dd 0
    font_error db "Font can't be load."
    closed_atom db "WM_DELETE_WINDOW", 0
    xauthority db "XAUTHORITY=", 0
    xdisplay db "DISPLAY=", 0
    clock_display dq 0

section .text
    global aCreateLink
    global aCloseLink
    global aCreateContext
    global aCreateWindow
    global aMapWindow
    global aCloseWindow
    global aDestroyWindow
    global aOpenFont
    global aPollEvent
    global aWindowUpdate
    global aIsWindowOpen
    global aIsWindowClosing
    global aIsWindowMoving
    global aIsWindowResizing
    global aClearWindow
    global aDisplayWindow
    global aSetWindowFps
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
    mov rcx, 0
    mov rdx, 0
    .loop:
        cmp rdx, 3
        je .quit_loop
        cmp qword[rdi + rcx * 8], 0
        je .bye_error
        cmp rdx, 1
        je .is_xauthority
        .is_display:
            lea r11, [rel xdisplay]
            CALL_ my_strncmp, qword[rdi + rcx * 8], r11, 8
            cmp rax, 0
            jne .is_xauthority
            add rdx, 1
            mov r9, qword[rdi + rcx * 8]
            add r9, 9
            jmp .reloop
        .is_xauthority:
            cmp rdx, 2
            je .reloop
            lea r11, [rel xauthority]
            CALL_ my_strncmp, qword[rdi + rcx * 8], r11, 11
            cmp rax, 0
            jne .reloop
            add rdx, 2
            mov r10, qword[rdi + rcx * 8]
            add r10, 11
        .reloop:
        inc rcx
        jmp .loop
    .quit_loop:
    push r10
    push r9

    mov rax, 41
    mov rdi, 1
    mov rsi, 1
    mov rdx, 0
    syscall
    mov r8, rax ; set fd socket in r8

    pop r9
    pop r10
    cmp r8, 0
    jl .bye_error
    push r10
    push r9

    CALL_ my_calloc, 110, 0
    mov r9, rax

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
    pop r10
    mov r11, r9
    add r11, 18
    CALL_ my_strcpy, r11, r10

    mov rax, 42
    mov rdi, r8
    mov rsi, r9
    mov rdx, 110
    syscall ; connect to socket

    pop r10
    cmp rax, 0
    jne .bye_error_my_free

    CALL_ my_free, r9

    push r8

    mov rax, 2
    mov rdi, r10
    mov rsi, 0
    syscall ; open the xauth for get key auth

    cmp rax, -1
    je .bye_error

    mov r8, rax
    CALL_ my_malloc, 1024
    mov r9, rax

    .loop_len_r10:
        xor r10, r10
        mov rax, 0
        mov rdi, r8
        lea rsi, [r9]
        mov rdx, 2
        syscall ; read the family of the auth

        cmp rax, 2
        jne .bye_error_my_free
    
        cmp word[r9], 1 ; check if its unix family
        jne .not_auth
        mov r10, 1 ; set the mark for know if its the right family
        .not_auth:

        mov rax, 0
        mov rdi, r8
        lea rsi, [r9 + 2]
        mov rdx, 2
        syscall ; read adress size

        cmp rax, rdx
        jne .bye_error_my_free

        mov rax, 0
        mov rdi, r8
        lea rsi, [r9 + 4]
        xor rdx, rdx
        mov dl, byte[r9 + 2]
        shl rdx, 8
        mov dl, byte[r9 + 3] ; read adress
        add rdx, 2 ; and read seat number size too
        syscall

        cmp rax, rdx
        jne .bye_error_my_free

        mov rbx, rax
        add rbx, 4

        mov rax, 0
        mov rdi, r8
        lea rsi, [r9 + rbx]
        xor rdx, rdx
        mov dl, byte[r9 + rbx - 2]
        shl rdx, 8
        mov dl, byte[r9 + rbx - 1] ; read seat numnber
        add rdx, 2 ; and read name protocol size too
        syscall

        cmp rax, rdx
        jne .bye_error_my_free

        add rbx, rax

        mov rax, 0
        mov rdi, r8
        lea rsi, [r9 + rbx]
        xor rdx, rdx
        mov dl, byte[r9 + rbx - 2]
        shl rdx, 8
        mov dl, byte[r9 + rbx - 1] ; read name protocol
        add rdx, 2 ; and read key protocol size too
        syscall

        cmp rax, rdx
        jne .bye_error_my_free

        add rbx, rax

        mov rax, 0
        mov rdi, r8
        lea rsi, [r9 + rbx]
        xor rdx, rdx
        mov dl, byte[r9 + rbx - 2]
        shl rdx, 8
        mov dl, byte[r9 + rbx - 1] ; read key protocol
        syscall

        cmp rax, rdx
        jne .bye_error_my_free

        cmp r10, 0
        je .loop_len_r10

    mov rax, 3
    mov rdi, r8
    syscall ; close the xauth file

    cmp rax, 0
    jne .bye_error_my_free
    
    mov rbx, 12 ; set empty request size
    mov r8, 4 ; add family and size adress
    xor r11, r11
    mov r11b, byte[r9 + 2]
    shl r11, 8
    mov r11b, byte[r9 + 3]
    add r8, r11 ; add adress
    add r8 , 2 ; add size seat number
    xor r11, r11
    mov r11b, byte[r9 + r8 - 2]
    shl r11, 8
    mov r11b, byte[r9 + r8 - 1]
    add r8, r11 ; add seat number
    add r8 , 2 ; add size name protocol
    xor r11, r11
    mov r11b, byte[r9 + r8 - 2]
    shl r11, 8
    mov r11b, byte[r9 + r8 - 1]
    push r11 ; save name protocol size
    add rbx, r11
    add r8, r11 ; add name protocol
    add r8 , 2 ; add size key protocol
    xor r11, r11
    mov r11b, byte[r9 + r8 - 2]
    shl r11, 8
    mov r11b, byte[r9 + r8 - 1]
    push r11 ; save name protocol size
    add rbx, r11 ; add key protocol size
    add r8, r11 ; add key protocol

    add rbx, 6 ; for padding

    CALL_ my_calloc, rbx, 0
    mov r10, rax

    mov byte[r10], 'l' ; set order byte
    mov word[r10 + 2], 11 ; set version
    pop r11
    mov word[r10 + 8], r11w ; set size of key protocol
    pop r11
    mov word[r10 + 6], r11w ; set size of name protocol
    mov rdi, r10
    add rdi, 12
    mov rsi, r9
    add rsi, r8
    xor r11, r11
    mov r11w, word[r10 + 8]
    sub rsi, r11
    sub rsi, 2
    xor r11, r11
    mov r11w, word[r10 + 6]
    sub rsi, r11
    CALL_ my_strncpy, rdi, rsi, r11
    neg r11
    and r11, -4
    neg r11

    add rdi, r11
    mov rsi, r9
    add rsi, r8
    xor r11, r11
    mov r11w, word[r10 + 8]
    sub rsi, r11
    CALL_ my_strncpy, rdi, rsi, r11
    neg r11
    and r11, -4
    neg r11

    add rdi, r11
    sub rdi, r10

    CALL_ my_free, r9
    
    pop r8
    mov rdx, rdi
    mov rax, 1
    mov rdi, r8
    mov rsi, r10
    syscall ; send the connection request

    CALL_ my_free, r10
    
    CALL_ my_calloc, 8, 0 ; alloc header
    mov r11, rax

    push r11
    mov rax, 0
    mov rdi, r8
    mov rsi, r11
    mov rdx, 8
    syscall ; read header
    pop r11

    mov r9, r11
    cmp byte[r11], 1 ; check if all good
    jne .bye_error_my_free

    xor r10, r10
    mov r10w, word[r11 + 6] ; get anwser length

    mov rax, r10
    mov rbx, 4
    mul rbx ; get anwer real length 

    push rax
    mov rdi, rax ; size of anwser
    add rdi, 20 ; size of header + event_queue
    CALL_ my_calloc, rdi, 0 ; alloc the link
    mov r9, rax
    pop r10

    mov dword[r9 + LINK_SOCKET], r8d ; set fd scoket in link

    mov rdx, qword[r11]
    mov qword[r9 + LINK_HEADER], rdx ; set header in link

    CALL_ my_free, r11

    mov rax, 0
    movzx rdi, byte[r9]
    mov rsi, r9
    add rsi, LINK_BODY
    mov rdx, r10
    syscall ; read the body into link

    cmp rax, 20
    jl .bye_error_my_free

    mov rdi, r9
    push r9

    xor r8, r8
    mov r8, rdi ; get socket_fd

    push rdi
    CALL_ my_malloc, 24 ; add basic need for this request
    mov r9, rax ; set my message

    mov byte[r9], 55 ; code create gc
    mov word[r9 + 2], 6 ; length of request

    mov r10d, dword[r8 + LINK_ID]
    mov dword[r9 + 4], r10d ; set cid
    mov r10d, dword[rel generate_id]
    add dword[r9 + 4], r10d ; set context_id
    inc dword[rel generate_id]

    mov r10, r8
    add r10, 20
    add r10, 32 ; set r10 at end of know info
    xor r11, r11
    mov r11w, word[r8 + LINK_VENDOR_LENGTH]
    add r10, r11 ; add vendor length
    xor rax, rax
    mov al, byte[r8 + LINK_FORMAT_LENGTH]
    mov r11, 8
    mul r11
    add r10, rax ; add format length

    mov r11d, dword[r10]
    mov dword[r9 + 8], r11d ; set parent

    mov dword[r9 + 12], 0x00010004 ; set flag foreground

    mov dword[r9 + 16], 0x00C800FF ; set color foreground

    mov dword[r9 + 20], 0x00000000 ; set color foreground

    mov rax, 1
    xor rdi, rdi
    mov edi, dword [r8]
    lea rsi, [r9]
    mov rdx, 24
    syscall ; send my message

    pop rdi
    mov r10d, dword[r9 + 4]
    mov dword[rdi + 48], r10d
    CALL_ my_free, r9

    pop r10 ; get the link
    push r10
    CALL_ my_calloc, 22, 0
    mov r9, rax ; create the thread_info struct
    mov qword[r10 + 4], r9 ; set the thread_info into link

    CALL_ my_calloc, 1024 * 1024, 0
    mov r10, rax ; create stack for thread
    mov qword[r9 + 6], r10 ; set thread stack on the thread_info

    mov rax, 56 ; code for clone
    mov rdi, 0x00110F00 ; flag : vm, fs, files, sighand, thread, parent tid
    mov rsi, r10 ; load the stack pointer
    add rsi, 1024 * 1024 ; put stack pointer to base of stack
    lea rdx, [r9 + 2] ; set the tid store zone
    pop r9
    xor r10, r10
    xor r8, r8
    syscall

    mov r10, r9

    cmp rax, 0
    je aThreadEvent

    mov rax, r10
    .bye:
        ret
    .bye_error:
        mov rax, 0
        ret
    .bye_error_my_free:
        mov rdi, r9
        call my_free
        mov rax, 0
        ret

aThreadEvent:
    ; r8 store the event
    ; r9 store the thread_info
    ; r10 store link
    mov r9, qword[r10 + 4]
    .loop:
        CALL_ my_calloc, 40, 0
        mov r8, rax ; alloc the event
        mov rax, 0 ; code for read
        xor rdi, rdi
        mov edi, dword[r10] ; read fd socket
        lea rsi, [r8 + 8] ; link the event anwser space
        mov rdx, 32 ; read a basic 
        syscall

        cmp byte[r8 + 0], 1
        jne .add_to_queue
        cmp dword[r8 + 12], 0
        je .add_to_queue ; if no more data add the event to queue

        xor rax, rax
        mov eax, dword[r8 + 12] ; get the extra data length
        mov rbx, 4
        mul rbx ; extra data is each 4byte
        push rax ; save the length of extra data
        add rax, 40 ; set the size of the new event

        CALL_ my_calloc, rax, 0; alloc the right one event

        mov r11, qword[r8 + 8]
        mov qword[rax + 8], r11
        mov r11, qword[r8 + 16]
        mov qword[rax + 16], r11
        mov r11, qword[r8 + 24]
        mov qword[rax + 24], r11
        mov r11, qword[r8 + 32]
        mov qword[rax + 32], r11 ; copy the data of old event into new event

        xchg rax, r8 ; swap value for free
        CALL_ my_free, rax ; free the old event

        mov rax, 0 ; code for read
        xor rdi, rdi
        mov edi, dword[r10] ; read fd socket
        lea rsi, [r8 + 40] ; link the event anwser space
        pop rdx ; get back the extra data length
        syscall

        .add_to_queue:
        CALL_ futex_lock, r9
        mov r11, qword[r9 + 14]
        mov qword[r8], r11
        mov qword[r9 + 14], r8
        CALL_ futex_unlock, r9
        jmp .loop
    ret

aCloseLink:
    cmp rdi, 0
    je .bye_error

    CALL_ my_malloc, 4
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

    CALL_ my_free, r9

    CALL_ my_free, rdi

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
    call my_malloc
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
    call my_free
    
    ret

aCreateWindow:
    xor r8, r8
    mov r8, rdi ; get link
    
    push rdi
    push r8
    push rsi
    mov rdi, 32 ; add basic need for this request
    add rdi, 8 ; add 2 value
    call my_malloc
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

    mov dword[r9 + 36], 131077 ; key press | button press | structure_notify

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
    call my_free

    CALL_ my_malloc, 20
    mov r8, rax
    pop rax
    mov dword[r8], eax

    pop rdi
    mov rsi, rax
    push r8
    push rdi

    push rsi
    CALL_ my_malloc, 24
    mov r9, rax

    mov byte[r9], 16 ; code
    mov byte[r9 + 1], 1 ; only if exits
    mov word[r9 + 2], 6 ; 2 + 16 / 4
    mov word[r9 + 4], 16 ; my_strlen de l'atom
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

    CALL_ my_free, r9

    pop rsi
    pop rdi
    push rdi
    push rsi

    CALL_ wait_reply, rdi
    mov r9, rax

    xor r8, r8
    mov r8d, dword[r9 + 16]

    CALL_ my_free, r9

    CALL_ my_malloc, 20
    mov r9, rax

    mov byte[r9], 16 ; code
    mov byte[r9 + 1], 0 ; only if exits
    mov word[r9 + 2], 5 ; 2 + 12 / 4
    mov word[r9 + 4], 12 ; my_strlen de l'atom
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
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 20
    syscall

    CALL_ my_free, r9

    pop rsi
    pop rdi
    push rdi
    push rsi
    CALL_ wait_reply, rdi
    mov r9, rax

    xor r10, r10
    mov r10d, dword[r9 + 16]

    CALL_ my_free, r9

    CALL_ my_malloc, 28
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
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    lea rsi, [r9]
    mov rdx, 28
    syscall

    CALL_ my_free, r9

    pop rsi
    pop rdi

    CALL_ my_malloc, 8
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

    CALL_ my_free, r9

    CALL_ wait_reply, rdi

    pop r8
    mov r10d, dword[rax + 20]
    mov dword[r8 + 8], r10d
    mov r11d, dword[rax + 24]
    mov dword[r8 + 12], r11d
    mov r10b, byte[rax + 9]
    mov byte[r8 + 16], r10b
    push r8
    mov r8b, byte[rax + 9]

    CALL_ my_free, rax

    CALL_ my_malloc, 16
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
    mov byte[r8 + 18], 1
    mov byte[r8 + 19], 0

    CALL_ my_free, r9

    mov rax, r8

    ret

aMapWindow:
    CALL_ my_malloc, 8
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

    CALL_ my_free, r9

    ret

aCloseWindow:
    mov byte[rdi + 18], 0
    ret

aDestroyWindow:
    CALL_ my_malloc, 8
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

    CALL_ my_free, r9

    CALL_ my_free, rsi

    ret

aOpenFont:
    push rdi
    CALL_ my_strlen, rsi
    mov rdx, rax
    neg rax
    and rax, -4
    neg rax
    add rax, 12
    push rax
    CALL_ my_malloc, rax
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
    CALL_ my_free, r9
    pop rax

    pop r8
    pop rdx
    cmp rax, rdx
    jne .error

    CALL_ my_malloc, 16
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

    CALL_ my_free, r9

    ret

    .error:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_error]
        mov rdx, 19
        syscall
        ret

aPollEvent:
    mov r9, qword[rdi + 4] ; get the thread_info
    add r9, 14
    cmp qword[r9], 0
    je .empty_queue
    mov r10, r9
    .go_to_next:
        mov r9, qword[r9]
        cmp qword[r9], 0
        je .find_event
        mov r10, qword[r10]
        jmp .go_to_next
    .find_event:
        mov r11, qword[rdi + 4]
        CALL_ futex_lock, r11
        mov qword[r10], 0
        CALL_ futex_unlock, r11
        mov r11, qword[r9 + 8]
        mov qword[rsi], r11
        mov r11, qword[r9 + 16]
        mov qword[rsi + 8], r11
        mov r11, qword[r9 + 24]
        mov qword[rsi + 16], r11
        mov r11, qword[r9 + 32]
        mov qword[rsi + 24], r11
        CALL_ my_free, r9
        mov rax, 1
        ret
    .empty_queue:
        mov rax, 0
        ret

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

    mov rax, 0
    mov rdi, rdi
    lea rsi, [r9]
    mov rdx, 16
    syscall

    xor r10, r10
    lea r10, [rel closed_atom]
    CALL_ my_strncmp, r10, r9, 16
    cmp rax, 0
    jne .bye_zero

    CALL_ my_free, r9

    mov rax, 1
    ret

    .bye_zero:
        CALL_ my_free, r9
        mov rax, 0
        ret

aIsWindowOpen:
    xor rax, rax
    mov al, byte[rdi + 18]
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

aSetWindowFps:
    mov byte[rdi + 17], sil
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
    cmp byte[rsi + 18], 0
    je .bye

    CALL_ my_malloc, 12
    mov r9, rax

    mov word[r9], 0
    mov word[r9 + 2], 0
    mov r10d, dword[rsi + 12]
    mov dword[r9 + 4], r10d
    mov dword[r9 + 8], 0
    xor r10, r10
    mov r10w, word[rsi + 14]

    CALL_ aDrawRectangle, rdi, rsi, r9

    CALL_ my_free, r9

    .bye:
    ret

aDisplayWindow:
    cmp byte[rsi + 18], 0
    je .bye

    push rdi
    push rsi
    CALL_ my_malloc, 28
    mov r9, rax

    mov rax, 228
    mov rdi, 0
    lea rsi, [r9]
    syscall

    mov rax, qword[r9] ; get sec
    mov rbx, 1000000000
    mul rbx ; convert into sec
    mov rbx, qword[r9 + 8] ; get nanosec
    add rax, rbx ; add nanosec
    sub rax, qword[rel clock_display] ; get the delay between frame

    pop rsi
    push rsi
    push rax
    mov rax, 1000000000
    xor rdx, rdx
    xor rbx, rbx
    mov bl, byte[rsi + 17]
    div rbx
    mov r8, rax ; get the fps value for wanted delay
    pop rax

    sub r8, rax
    cmp r8, 0 ; check if need to sleep
    jle .bye_delay

    mov rax, r8
    xor rdx, rdx
    mov rbx, 1000000000
    div rbx ; get nanosec of sleep wanted

    mov qword[r9], rax ; set sec
    mul rbx
    sub r8, rax
    mov qword[r9 + 8], r8 ; set nanosec

    mov rax, 35
    lea rdi, [r9]
    xor rsi, rsi
    syscall ; nanosleep

    .bye_delay:
    mov rax, 228
    mov rdi, 0
    lea rsi, [r9]
    syscall

    mov rax, qword[r9] ; get sec
    mov rbx, 1000000000
    mul rbx ; convert into sec
    mov rbx, qword[r9 + 8] ; get nanosec
    add rax, rbx ; add nanosec
    mov qword[rel clock_display], rax ; save the act time for next display

    pop rsi
    pop rdi

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
    
    CALL_ my_free, r9

    .bye:
    ret

aCreateText:
    push rdi
    push rsi
    push rdx
    mov rdi, 16
    call my_malloc
    mov r9, rax
    pop rdx
    pop rsi
    pop rdi
    CALL_ my_strdup, rdi
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
    cmp byte[rsi + 18], 0
    je .bye

    push rdi
    push rsi
    push rdx

    CALL_ my_malloc, 16
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

    CALL_ my_free, r9

    pop rdx
    pop rsi
    pop rdi

    mov rcx, rdx
    add rcx, 8
    mov rdx, qword[rdx] ; decompose aText struct

    CALL_ my_strlen, rdx
    xor r10, r10
    mov r10b, al
    neg r10
    and r10, -4
    neg r10
    add r10, 16
    push r10
    ; get size to my_malloc

    CALL_ my_malloc, r10
    mov r9, rax

    mov byte[r9], 76 ; code
    CALL_ my_strlen, rdx
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

    CALL_ my_free, r9

    .bye:
    ret

aDestroyText:
    mov r10, qword[rdi]
    CALL_ my_free, r10
    CALL_ my_free, rdi
    ret

aCreateRectangle:
    push rdi
    push rsi
    mov rdi, 12
    call my_malloc
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
    cmp byte[rsi + 18], 0
    je .bye

    push rdi
    push rsi
    push rdx

    CALL_ my_malloc, 16
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

    CALL_ my_free, r9

    pop rdx
    pop rsi
    pop rdi

    CALL_ my_malloc, 20
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

    CALL_ my_free, r9

    .bye:
    ret

aDestroyRectangle:
    CALL_ my_free, rdi
    ret

aBell:
    cmp rsi, -100
    jl .bye
    cmp rsi, 100
    jg .bye

    CALL_ my_malloc, 4
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

    CALL_ my_free, r9
    .bye:
    ret
_exit:
    mov rax, 60
    mov rdi, 1
    syscall

wait_reply:
    mov r9, qword[rdi + 4] ; get the thread_info
    mov r10, r9
    add r10, 14 ; set the r8 to the event
    .loop:
        cmp qword[r10], 0
        je wait_reply
        mov r8, qword[r10]
        cmp byte[r8 + 8], 1
        je .quit_loop
        jmp _exit
        mov r10, r8
        mov r8, qword[r8]
        jmp .loop
    .quit_loop:
    CALL_ futex_lock, r9
    mov r11, qword[r8]
    mov qword[r10], r11
    CALL_ futex_unlock, r9
    mov rax, r8
    ret

test_truc:
    CALL_ my_malloc, 32
    mov r9, rax

    mov rax, 0
    mov rdi, 3
    lea rsi, [r9]
    mov rdx, 32
    syscall

    xor r10, r10
    mov r10b, byte[r9]
    CALL_ my_putnbr, r10
    CALL_ my_putchar, 10

    CALL_ my_free, r9

    ret

section .data
    generate_id dd 0
    xauthority db "XAUTHORITY=", 0
    xdisplay db "DISPLAY=", 0

section .text
    global AsmCreateLink
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateLink:
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
            CALL_ AsmStrncmp, qword[rdi + rcx * 8], r11, 8
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
            CALL_ AsmStrncmp, qword[rdi + rcx * 8], r11, 11
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

    CALL_ AsmCalloc, 110, 0
    cmp rax, 0
    je .bye_error
    push r10
    push r9
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
    CALL_ AsmStrcpy, r11, r10

    mov rax, 42
    mov rdi, r8
    mov rsi, r9
    mov rdx, 110
    syscall ; connect to socket

    pop r10
    cmp rax, 0
    jne .bye_error_AsmDalloc

    CALL_ AsmDalloc, r9

    push r8

    mov rax, 2
    mov rdi, r10
    mov rsi, 0
    syscall ; open the xauth for get key auth

    cmp rax, -1
    je .bye_error

    mov r8, rax
    CALL_ AsmAlloc, 1024
    mov r9, rax

    .loop_len_r10:
        xor r10, r10
        mov rax, 0
        mov rdi, r8
        lea rsi, [r9]
        mov rdx, 2
        syscall ; read the family of the auth

        cmp rax, 2
        jne .bye_error_AsmDalloc
    
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
        jne .bye_error_AsmDalloc

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
        jne .bye_error_AsmDalloc

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
        jne .bye_error_AsmDalloc

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
        jne .bye_error_AsmDalloc

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
        jne .bye_error_AsmDalloc

        cmp r10, 0
        je .loop_len_r10

    mov rax, 3
    mov rdi, r8
    syscall ; close the xauth file

    cmp rax, 0
    jne .bye_error_AsmDalloc
    
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

    CALL_ AsmCalloc, rbx, 0
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
    CALL_ AsmStrncpy, rdi, rsi, r11
    neg r11
    and r11, -4
    neg r11

    add rdi, r11
    mov rsi, r9
    add rsi, r8
    xor r11, r11
    mov r11w, word[r10 + 8]
    sub rsi, r11
    CALL_ AsmStrncpy, rdi, rsi, r11
    neg r11
    and r11, -4
    neg r11

    add rdi, r11
    sub rdi, r10

    CALL_ AsmDalloc, r9
    
    pop r8
    mov rdx, rdi
    mov rax, 1
    mov rdi, r8
    mov rsi, r10
    syscall ; send the connection request

    CALL_ AsmDalloc, r10
    
    CALL_ AsmCalloc, 8, 0 ; alloc header
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
    jne .bye_error_AsmDalloc

    xor r10, r10
    mov r10w, word[r11 + 6] ; get anwser length

    mov rax, r10
    mov rbx, 4
    mul rbx ; get anwer real length 

    push rax
    mov rdi, rax ; size of anwser
    add rdi, 20 ; size of header + event_queue
    CALL_ AsmCalloc, rdi, 0 ; alloc the link
    mov r9, rax
    pop r10

    mov dword[r9 + LINK_SOCKET], r8d ; set fd scoket in link

    mov rdx, qword[r11]
    mov qword[r9 + LINK_HEADER], rdx ; set header in link

    CALL_ AsmDalloc, r11

    mov rax, 0
    movzx rdi, byte[r9]
    mov rsi, r9
    add rsi, LINK_BODY
    mov rdx, r10
    syscall ; read the body into link

    cmp rax, 20
    jl .bye_error_AsmDalloc

    mov rdi, r9
    push r9

    xor r8, r8
    mov r8, rdi ; get socket_fd

    push rdi
    CALL_ AsmAlloc, 24 ; add basic need for this request
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
    CALL_ AsmDalloc, r9

    pop r10 ; get the link
    push r10
    CALL_ AsmCalloc, 22, 0
    mov r9, rax ; create the thread_info struct
    mov qword[r10 + 4], r9 ; set the thread_info into link

    CALL_ AsmCalloc, 1024 * 1024, 0
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
    je AsmThreadEvent

    mov rax, r10
    .bye:
        ret
    .bye_error:
        mov rax, 0
        ret
    .bye_error_AsmDalloc:
        mov rdi, r9
        call AsmDalloc
        mov rax, 0
        ret
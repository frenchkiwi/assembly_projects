section .data
    xauthority db "XAUTHORITY=", 0
    xdisplay db "DISPLAY=", 0

section .text
    global AsmCreateLink
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateLink:
    cmp rdi, 0
    je .bye_error0
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi ; the env table
    xor r13, r13 ; index
    xor r14, r14 ; counter of value find
    .check_env:
        cmp qword[r12 + r13 * 8], 0
        je .bye_error
        cmp r14, 1
        je .is_xauthority
        .is_display:
            mov rdi, qword[r12 + r13 * 8]
            lea rsi, [rel xdisplay]
            mov rdx, 8
            call AsmStrncmp
            cmp rax, 0
            jne .is_xauthority
            add r14, 1
            mov rbx, qword[r12 + r13 * 8] ; set display= in rbx
            add rbx, 9
            jmp .next_env_var
        .is_xauthority:
            cmp r14, 2
            je .next_env_var
            mov rdi, qword[r12 + r13 * 8]
            lea rsi, [rel xauthority]
            mov rdx, 11
            call AsmStrncmp
            cmp rax, 0
            jne .next_env_var
            add r14, 2
            mov r15, qword[r12 + r13 * 8] ; set xauthority= in r15
            add r15, 11
        .next_env_var:
        inc r13
        cmp r14, 3 ; check if all find
        jne .check_env

    mov rax, 41
    mov rdi, 1
    mov rsi, 1
    mov rdx, 0
    syscall
    cmp rax, 0
    jl .bye_error

    mov r12, rax ; set fd socket in r12

    mov rdi, 110
    mov rsi, 0
    call AsmCalloc
    cmp rax, 0
    je .bye_error

    mov r8, rax
    mov word[r8], 1
    mov byte[r8 + 2], '/'
    mov byte[r8 + 3], 't'
    mov byte[r8 + 4], 'm'
    mov byte[r8 + 5], 'p'
    mov byte[r8 + 6], '/'
    mov byte[r8 + 7], '.'
    mov byte[r8 + 8], 'X'
    mov byte[r8 + 9], '1'
    mov byte[r8 + 10], '1'
    mov byte[r8 + 11], '-'
    mov byte[r8 + 12], 'u'
    mov byte[r8 + 13], 'n'
    mov byte[r8 + 14], 'i'
    mov byte[r8 + 15], 'x'
    mov byte[r8 + 16], '/'
    mov byte[r8 + 17], 'X'
    mov rdi, r8
    add rdi, 18
    mov rsi, rbx
    call AsmStrcpy
    mov rsi, rax
    sub rsi, 18

    mov rax, 42
    mov rdi, r12
    ; rsi already set
    mov rdx, 110
    syscall ; connect to socket
    push rax
    mov rdi, rsi
    call AsmDalloc
    pop rax
    cmp rax, 0
    jne .bye_error

    mov rax, 2
    mov rdi, r15
    mov rsi, 0
    syscall ; open the xauth for get key auth
    cmp rax, 0
    jl .bye_error

    mov r15, rax

    mov rdi, 256 * 4 + 2 * 5 ; 4 string of max 256 byte and 5 word
    call AsmAlloc
    cmp rax, 0
    je .bye_error
    mov r8, rax ; save the fd of the xauth file in r8

    .get_auth_protocol:
        xor r9, r9
        mov rax, 0
        mov rdi, r15
        lea rsi, [r8]
        mov rdx, 4
        syscall ; read the family of the auth and the adress size
        cmp rax, rdx
        jne .bye_errorD

        cmp word[r8], 1 ; check if its unix family
        jne .not_auth
        mov r9,  1 ; set the mark for know if its the right family
        .not_auth:

        mov rax, 0
        mov rdi, r15
        lea rsi, [r8 + 4]
        movzx rdx, byte[r8 + 2]
        shl rdx, 8
        mov dl, byte[r8 + 3] ; read adress
        add rdx, 2 ; and read seat number size too
        syscall
        cmp rax, rdx
        jne .bye_errorD

        mov r9, rdx ; set the index in r9
        add r9, 4 ; add family and addr size bytes

        mov rax, 0
        mov rdi, r15
        lea rsi, [r8 + r9]
        movzx rdx, byte[r8 + r9 - 2]
        shl rdx, 8
        mov dl, byte[r8 + r9 - 1] ; read seat numnber
        add rdx, 2 ; and read name protocol size too
        syscall
        cmp rax, rdx
        jne .bye_errorD

        add r9, rdx ; add seat number and name protocol size bytes
        mov r13, r8
        add r13, r9
        sub r13, 2 ; set name protocol info in r13

        mov rax, 0
        mov rdi, r15
        lea rsi, [r8 + r9]
        movzx rdx, byte[r8 + r9 - 2]
        shl rdx, 8
        mov dl, byte[r8 + r9 - 1] ; read name protocol
        add rdx, 2 ; and read key protocol size too
        syscall
        cmp rax, rdx
        jne .bye_errorD

        add r9, rdx ; add name protocol and key protocol size bytes
        mov r14, r8
        add r14, r9
        sub r14, 2 ; set key protocol info in r14

        mov rax, 0
        mov rdi, r15
        lea rsi, [r8 + r9]
        movzx rdx, byte[r8 + r9 - 2]
        shl rdx, 8
        mov dl, byte[r8 + r9 - 1] ; read key protocol
        syscall
        cmp rax, rdx
        jne .bye_errorD

        cmp r9, 0
        je .get_auth_protocol

    mov rax, 3
    mov rdi, r15
    syscall ; close the xauth file
    cmp rax, 0
    jl .bye_errorD

    mov rdi, 12
    movzx r9, byte[r13]
    shl r9, 8
    mov r9b, byte[r13 + 1]
    neg r9
    and r9, -4
    neg r9
    add rdi, r9
    movzx r9, byte[r14]
    shl r9, 8
    mov r9b, byte[r14 + 1]
    neg r9
    and r9, -4
    neg r9
    add rdi, r9
    mov rbx, rdi
    push r8
    call AsmAlloc ; alloc the handshake
    pop r8
    cmp rax, 0
    je .bye_errorD

    push r8
    mov r15, rax
    mov byte[r15], 'l' ; set order byte
    mov word[r15 + 2], 11 ; set version major
    mov word[r15 + 4], 0 ; set version minor
    movzx r9, byte[r13]
    shl r9, 8
    mov r9b, byte[r13 + 1]
    mov word[r15 + 6], r9w
    movzx r9, byte[r14]
    shl r9, 8
    mov r9b, byte[r14 + 1]
    mov word[r15 + 8], r9w
    mov rdi, r15
    add rdi, 12
    mov rsi, r13
    add rsi, 2
    movzx rdx, word[r15 + 6]
    call AsmStrncpy
    mov rdi, r15
    add rdi, 12
    movzx r9, word[r15 + 6]
    neg r9
    and r9, -4
    neg r9
    add rdi, r9
    mov rsi, r14
    add rsi, 2
    movzx rdx, word[r15 + 8]
    call AsmStrncpy
    pop rdi
    call AsmDalloc

    mov r8, r15

    mov rax, 1
    mov rdi, r12
    lea rsi, [r8]
    mov rdx, rbx
    syscall ; send the handshake
    cmp rax, rdx
    jne .bye_errorD

    mov rax, 0
    mov rdi, r12
    lea rsi, [r8]
    mov rdx, 8
    syscall ; read header
    cmp rax, rdx
    jne .bye_errorD

    cmp byte[r8], 1
    jne .bye_errorD

    movzx rax, word[r8 + 6]
    mov rbx, 4
    mul rbx ; get anwser length
    mov r13, rax ; save anwser size in r13

    mov rdi, rax
    add rdi, 8 + 4 + 1 + 1 + 4 + 8 + 8 + 8; add fd + generator id + futex + thread variable + thread_id + thread_stack + event_queue + header
    push r8
    call AsmAlloc
    pop r8
    cmp rax, 0
    je .bye_errorD

    xchg r12, rax
    mov qword[LINK_SOCKET], rax
    mov dword[LINK_ID_GENERATOR], 0 ; clear generator id
    mov qword[LINK_ID_GENERATOR + 2], 0 ; clear futex + thread_var + thread_id
    mov qword[LINK_THREAD_STACK], 0 ; clear thread_stack
    mov qword[LINK_EVENT_QUEUE], 0 ; clear event_queue
    mov rax, qword[r8]
    mov qword[LINK_HEADER], rax ; copy header

    mov rdi, r8
    call AsmDalloc

    mov rax, 0
    mov rdi, qword[LINK_SOCKET]
    lea rsi, [LINK_BODY]
    mov rdx, r13
    syscall ; read header
    cmp rax, rdx
    jne .bye_errorD

    CALL_ AsmCalloc, 4096 * 2, 0
    mov r8, rax ; create stack for thread
    mov qword[LINK_THREAD_STACK], r8 ; set thread stack on the thread_info

    mov rax, 56 ; code for clone
    mov rdi, 0x00110F00 ; flag : vm, fs, files, sighand, thread, parent tid
    lea rsi, [r8] ; load the stack pointer
    add rsi, 4096 * 2 ; put stack pointer to base of stack
    lea rdx, [LINK_THREAD_ID] ; set the thread_id store zone
    syscall

    cmp rax, 0
    je AsmThreadEvent

    mov rax, r12
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

    .bye_errorD:
        mov rdi, r8
        call AsmDalloc
    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        xor rax, rax
        ret
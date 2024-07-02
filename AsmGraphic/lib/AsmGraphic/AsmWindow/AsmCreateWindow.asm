section .data

section .text
    global AsmCreateWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateWindow:
    cmp rdi, 0
    je .bye_error0
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx

    sub rsp, 32 + 4 + 4 ; create window minimum + 2 values
    mov byte[rsp], 1 ; set create_window request
    mov byte[rsp + 1], 0 ; set depth
    mov word[rsp + 2], 8 + 2 ; set length minimum + 2 value

    mov r10d, dword[LINK_ID_GENERATOR]
    mov dword[rsp + 4], r10d ; set window_id
    inc dword[LINK_ID_GENERATOR]

    mov r8, r12
    add r8, 74
    movzx r9, word[LINK_VENDOR_LENGTH]
    neg r9
    and r9, -4
    neg r9
    add r8, r9
    movzx rax, byte[LINK_FORMAT_LENGTH]
    mov r9, 8
    mul r9
    add r8, rax ; go to root section

    mov r9d, dword[r8]
    mov dword[rsp + 8], r9d ; set parent_id
    mov dword[rsp + 12], 0 ; set pos
    mov dword[rsp + 16], r13d ; set size
    mov word[rsp + 20], 1 ; set group/class
    mov word[rsp + 22], 1 ; set border-width
    mov r9d, dword[r8 + 32]
    mov dword[rsp + 24], r9d ; set visual_id
    mov dword[rsp + 28], 0x2 | 0x800 ; set bitmask
    mov dword[rsp + 32], 0x00000000 ; set background to black
    mov dword[rsp + 36], 0x1 | 0x4 | 0x20000 ; key press | button press | structure_notify
    
    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [rsp]
    mov rdx, 32 + 4 + 4
    syscall ; send my message
    cmp rax, rdx
    jne .bye_errorS

    mov rdi, 34
    call AsmAlloc
    cmp rax, 0
    je .bye_errorS

    mov r8d, dword[rsp + 4]
    mov dword[rax], r8d
    mov dword[rax + 4], 0
    mov qword[rax + 8], r12
    mov dword[rax + 16], 0
    mov dword[rax + 20], r13d
    mov word[rax + 24], 0
    mov dword[rax + 30], 0
    mov r15, rax ; r15 is now the window
    add rsp, 32 + 4 + 4

    sub rsp, 24
    mov byte[rsp], 16 ; code
    mov byte[rsp + 1], 1 ; only if exist
    mov word[rsp + 2], 6 ; 2 + 16 / 4
    mov word[rsp + 4], 16 ; my_strlen de l'atom
    mov byte[rsp + 8], 'W'
    mov byte[rsp + 9], 'M'
    mov byte[rsp + 10], '_'
    mov byte[rsp + 11], 'D'
    mov byte[rsp + 12], 'E'
    mov byte[rsp + 13], 'L'
    mov byte[rsp + 14], 'E'
    mov byte[rsp + 15], 'T'
    mov byte[rsp + 16], 'E'
    mov byte[rsp + 17], '_'
    mov byte[rsp + 18], 'W'
    mov byte[rsp + 19], 'I'
    mov byte[rsp + 20], 'N'
    mov byte[rsp + 21], 'D'
    mov byte[rsp + 22], 'O'
    mov byte[rsp + 23], 'W'

    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [rsp]
    mov rdx, 24
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error

    mov rdi, r12
    mov rsi, 1
    call AsmWaitEvent

    xor r13, r13
    mov r13d, dword[rax + 16] ; r13 is now WM_DELETE_WINDOW id

    mov rdi, rax
    call AsmDalloc

    sub rsp, 24
    mov byte[rsp], 16 ; code
    mov byte[rsp + 1], 0 ; only if exits
    mov word[rsp + 2], 5 ; 2 + 12 / 4
    mov word[rsp + 4], 12 ; my_strlen de l'atom
    mov byte[rsp + 8], 'W'
    mov byte[rsp + 9], 'M'
    mov byte[rsp + 10], '_'
    mov byte[rsp + 11], 'P'
    mov byte[rsp + 12], 'R'
    mov byte[rsp + 13], 'O'
    mov byte[rsp + 14], 'T'
    mov byte[rsp + 15], 'O'
    mov byte[rsp + 16], 'C'
    mov byte[rsp + 17], 'O'
    mov byte[rsp + 18], 'L'
    mov byte[rsp + 19], 'S'

    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [rsp]
    mov rdx, 20
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error

    mov rdi, r12
    mov rsi, 1
    call AsmWaitEvent

    xor rbx, rbx
    mov ebx, dword[rax + 16]

    mov rdi, rax
    call AsmDalloc

    sub rsp, 32
    mov byte[rsp], 18 ; code
    mov byte[rsp + 1], 0 ; replace
    mov word[rsp + 2], 7 ; 6 + 1
    mov r8d, dword[r15]
    mov dword[rsp + 4], r8d ; window_id
    mov dword[rsp + 8], ebx ; WM_PROTOCOLS atom
    mov dword[rsp + 12], 4 ; type ATOM
    mov byte[rsp + 16], 32 ; format en 4octet
    mov dword[rsp + 20], 1 ; 1 atom
    mov dword[rsp + 24], r13d ; WM_DELETE_WINDOW atom

    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [rsp]
    mov rdx, 28
    syscall
    add rsp, 32
    cmp rax, rdx
    jne .bye_error

    sub rsp, 8

    mov byte[rsp], 14
    mov word[rsp + 2], 2
    mov r10d, dword[r15]
    mov dword[rsp + 4], r10d

    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    add rsp, 8
    cmp rax, rdx
    jne .bye_error

    mov rdi, r12
    mov rsi, 1
    call AsmWaitEvent

    mov r8d, dword[rax + 20]
    mov dword[r15 + 16], r8d
    mov r8b, byte[rax + 9]
    mov byte[r15 + 24], r8b

    mov rdi, rax
    call AsmDalloc

    sub rsp, 24
    mov byte[rsp], 55
    mov word[rsp + 2], 4 + 1
    mov r8d, dword[LINK_ID_GENERATOR]
    mov dword[rsp + 4], r8d
    mov dword[r15 + 26], r8d
    inc dword[LINK_ID_GENERATOR]

    mov r8d, dword[LINK_ID]
    mov dword[rsp + 8], r8d
    mov dword[rsp + 12], 0x00010000
    mov dword[rsp + 16], 0

    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [rsp]
    mov rdx, 20
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error

    cmp r14, 0
    je .bye

    mov rdi, r15
    mov rsi, r14
    call AsmRenameWindow

    .bye:
    mov rax, r15
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

    .bye_errorS:
        add rsp, 32 + 4 + 4
    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        xor rax, rax
        ret
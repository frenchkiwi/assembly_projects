section .data

section .text
    global AsmRenameWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmRenameWindow:
    cmp rdi, 0
    je .bye_error0

    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r15, rsi
    sub rsp, 16

    mov byte[rsp], 16 ; code
    mov byte[rsp + 1], 1 ; only if exist
    mov word[rsp + 2], 4 ; 2 + (7 + 1) / 4
    mov word[rsp + 4], 7 ; my_strlen de l'atom
    mov byte[rsp + 8], 'W'
    mov byte[rsp + 9], 'M'
    mov byte[rsp + 10], '_'
    mov byte[rsp + 11], 'N'
    mov byte[rsp + 12], 'A'
    mov byte[rsp + 13], 'M'
    mov byte[rsp + 14], 'E'

    mov rax, 1
    mov rdi, qword[r12 + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 16
    syscall
    add rsp, 16
    cmp rax, rdx
    jne .bye_error

    mov rdi, qword[r12 + 8]
    mov rsi, 1
    call AsmWaitEvent

    xor r13, r13
    mov r13d, dword[rax + 16] ; r13 is now WM_NAME id 

    mov rdi, rax
    call AsmDalloc

    sub rsp, 16

    mov byte[rsp], 16 ; code
    mov byte[rsp + 1], 1 ; only if exist
    mov word[rsp + 2], 4 ; 2 + (6 + 2) / 4
    mov word[rsp + 4], 6 ; my_strlen de l'atom
    mov byte[rsp + 8], 'S'
    mov byte[rsp + 9], 'T'
    mov byte[rsp + 10], 'R'
    mov byte[rsp + 11], 'I'
    mov byte[rsp + 12], 'N'
    mov byte[rsp + 13], 'G'

    mov rax, 1
    mov rdi, qword[r12 + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 16
    syscall
    add rsp, 16
    cmp rax, rdx
    jne .bye_error

    mov rdi, qword[r12 + 8]
    mov rsi, 1
    call AsmWaitEvent

    xor r14, r14
    mov r14d, dword[rax + 16] ; r13 is now STRING id

    mov rdi, rax
    call AsmDalloc

    mov rdi, r15
    call AsmStrlen

    mov r11, rax
    neg rax
    and rax, -4
    neg rax
    add rax, 24
    mov rbx, rax

    neg rax
    and rax, -8
    neg rax
    sub rsp, rax

    mov byte[rsp], 18 ; code
    mov byte[rsp + 1], 0 ; replace
    xor rax, rax
    mov rax, rbx
    xor rdx, rdx
    mov r8, 4
    div r8
    mov word[rsp + 2], ax ; 6 + (strlen(name) + p) / 4
    mov r8d, dword[WINDOW_ID]
    mov dword[rsp + 4], r8d ; window_id
    mov dword[rsp + 8], r13d ; WM_NAME atom
    mov dword[rsp + 12], r14d ; type ATOM
    mov byte[rsp + 16], 8 ; format en 4octet
    mov dword[rsp + 20], r11d ; strlen(name)
    xor rcx, rcx
    .copy_name:
        cmp rcx, r11
        je .bye_copy_name
        mov r8b, byte[r15 + rcx]
        mov byte[rsp + 24 + rcx], r8b
        inc rcx
        jmp .copy_name

    .bye_copy_name:
    mov rax, 1
    mov rdi, qword[r12 + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, rbx
    syscall
    neg rbx
    and rbx, -8
    neg rbx
    add rsp, rbx
    cmp rax, rdx
    jne .bye_error

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    xor rax, rax
    ret

    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        mov rax, -1
        ret
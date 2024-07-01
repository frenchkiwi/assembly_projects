section .data

section .text
    global AsmCreateFont
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateFont:
    cmp rdi, 0
    je .bye_error0
    cmp rsi, 0
    je .bye_error0

    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi

    mov rdi, r13
    call AsmStrlen
    mov r14, rax
    neg rax
    and rax, -4
    neg rax
    add rax, 12
    mov r15, rax

    sub rsp, r15

    mov byte[rsp], 45 ; openfont request
    mov rax, r15
    xor rdx, rdx
    mov r8, 4
    div r8
    mov word[rsp + 2], ax ; length of request 3 + (strlen + p) / 4
    mov r8d, dword[LINK_ID_GENERATOR]
    mov dword[rsp + 4], r8d ; set font_id
    inc dword[LINK_ID_GENERATOR]
    mov ebx, r8d
    mov word[rsp + 8], r14w
    xor rcx, rcx
    .copy_name:
        cmp rcx, r14
        je .bye_copy_name
        mov r8b, byte[r13 + rcx]
        mov byte[rsp + 12 + rcx], r8b
        inc rcx
        jmp .copy_name

    .bye_copy_name:
    mov rax, 1
    mov rdi, qword[LINK_SOCKET]
    lea rsi, [rsp]
    mov rdx, r15
    syscall
    add rsp, r15
    cmp rax, rdx
    jne .bye_error

    mov rdi, 12
    call AsmAlloc
    cmp rax, 0
    je .bye_error

    mov dword[rax], ebx
    mov qword[rax + 4], r12

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        xor rax, rax
        ret

; aOpenFont:
;     push rdi
;     CALL_ my_strlen, rsi
;     mov rdx, rax
;     neg rax
;     and rax, -4
;     neg rax
;     add rax, 12
;     push rax
;     CALL_ my_malloc, rax
;     mov r9, rax
;     pop rax
;     push rax

;     mov byte[r9], 45
;     push rdx
;     mov r10, 4
;     xor rdx, rdx
;     div r10
;     pop rdx

;     mov word[r9 + 2], ax

;     mov r10d, dword[rdi + 24]
;     mov dword[r9 + 4], r10d
;     mov r10d, dword[rel generate_id]
;     add dword[r9 + 4], r10d ; set font_id
;     xor r10, r10
;     mov r10d, dword[r9 + 4]
;     push r10
;     inc dword[rel generate_id]

;     mov dword[r9 + 8], edx

;     mov rcx, 0
;     .loop:
;         cmp rcx, rdx
;         je .quit_loop
;         mov r10b, byte[rsi + rcx]
;         mov byte[r9 + 12 + rcx], r10b
;         inc rcx
;         jmp .loop
;     .quit_loop:
;     mov rax, 1
;     xor r10, r10
;     mov r10d, dword[rdi]
;     mov rdi, r10
;     lea rsi, [r9]
;     pop r10
;     pop rdx
;     push rdx
;     push r10
;     syscall

;     push rax
;     CALL_ my_free, r9
;     pop rax

;     pop r8
;     pop rdx
;     cmp rax, rdx
;     jne .error

;     CALL_ my_malloc, 16
;     mov r9, rax

;     pop rdi
;     mov byte[r9], 56
;     mov word[r9 + 2], 4
;     xor r10, r10
;     mov r10d, dword[rdi + 48]
;     mov dword[r9 + 4], r10d
;     mov dword[r9 + 8], 16384
;     mov dword[r9 + 12], r8d

;     mov rax, 1
;     xor r10, r10
;     mov r10d, dword[rdi]
;     mov rdi, r10
;     lea rsi, [r9]
;     mov rdx, 16
;     syscall

;     CALL_ my_free, r9

;     ret

;     .error:
;         mov rax, 1
;         mov rdi, 2
;         lea rsi, [rel font_error]
;         mov rdx, 19
;         syscall
;         ret
section .data

section .text
    global AsmRenameWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmRenameWindow:
    cmp rdi, 0
    je .bye_error0
    cmp rsi, 0
    je .bye_error0

    push rbx
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi
    
    mov rdi, r13
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
    mov dword[rsp + 8], 39 ; WM_NAME atom
    mov dword[rsp + 12], 31 ; type ATOM STRING
    mov byte[rsp + 16], 8 ; format en 4octet
    mov dword[rsp + 20], r11d ; strlen(name)
    xor rcx, rcx
    .copy_name:
        cmp rcx, r11
        je .bye_copy_name
        mov r8b, byte[r13 + rcx]
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

    pop r13
    pop r12
    pop rbx
    xor rax, rax
    ret

    .bye_error:
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        mov rax, -1
        ret
section .data

section .text
    global strcmp

my_strcmp:
    mov rcx, -1
    .loop_strcmp:
        inc rcx
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rcx], r9b
        jne .bye_strcmp
        cmp byte [rdi + rcx], 0
        jne .loop_strcmp
    mov rax, 0
    ret

    .bye_strcmp:
        movzx rax, byte [rdi + rcx]
        movzx rbx, byte [rsi + rcx]
        sub rax, rbx
        ret

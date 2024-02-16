section .data
    string db "hElLo World", 0

section .text
    extern my_putstr
    global _start

my_strcapitalize:
    mov rcx, -1
    mov rdx, 1
    loop_strcapitalize:
        inc rcx
        call down_strcapitalize
        again_loop_strcapitalize:
            cmp byte [rdi + rcx], 0
            jne loop_strcapitalize
    mov rax, rdi
    ret

    down_strcapitalize:
        cmp byte [rdi + rcx], 'A'
        jl up_strcapitalize
        cmp byte [rdi + rcx], 'Z'
        jg up_strcapitalize
        add byte [rdi + rcx], 32
        jmp up_strcapitalize

    up_strcapitalize:
        cmp rdx, 0
        je check_strcapitalize
        cmp byte [rdi + rcx], 'a'
        jl check_strcapitalize
        cmp byte [rdi + rcx], 'z'
        jg check_strcapitalize
        sub byte [rdi + rcx], 32
        mov rdx, 0
        jmp check_strcapitalize

    check_strcapitalize:
        cmp byte [rdi + rcx], 'A'
        jl is_capitalize
        cmp byte [rdi + rcx], 'z'
        jg is_capitalize
        jmp check_strcapitalize2

    check_strcapitalize2:
        cmp byte [rdi + rcx], 'Z'
        jle again_loop_strcapitalize
        cmp byte [rdi + rcx], 'a'
        jge again_loop_strcapitalize
        jmp is_capitalize

    is_capitalize:
        mov rdx, 1
        jmp again_loop_strcapitalize

_start:
    mov rdi, string
    call my_strcapitalize
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

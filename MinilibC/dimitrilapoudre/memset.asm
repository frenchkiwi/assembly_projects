section .data

section .text
    global memset

memset:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov byte [rdi + rcx], sil
        jmp .loop
    .bye:
    mov rax, rdi
    ret

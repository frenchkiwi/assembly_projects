section .data

section .text
    global strlen

strlen:
    mov rax, -1
    .loop_strlen:
        inc rax
        cmp byte [rdi + rax], 0
        jne .loop_strlen
    ret

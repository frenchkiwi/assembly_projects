.global _start
.intel_syntax noprefix

_start:
    jmp end

    write:
        mov rax, 1
        mov rdi, 1
        mov rdx, 1
        syscall

    end:
        mov rax, 60
        mov rdi, 0
        syscall

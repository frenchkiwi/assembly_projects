.global _start
.intel_syntax noprefix

.data
    newline: .long 10
    letter: .long 97
    count: .long 26

.text
    _start:
        mov rbx, [count]
        
        loop:
            mov rax, 1
            mov rdi, 1
            lea rsi, [letter]
            mov rdx, 1
            syscall

            mov eax, [letter]
            add eax, 1
            mov [letter], eax

            sub rbx, 1
            jnz loop


        mov rax, 1
        mov rdi, 1
        lea rsi, [newline]
        mov rdx, 1
        syscall

        mov rax, 60
        mov rdi, 0
        syscall


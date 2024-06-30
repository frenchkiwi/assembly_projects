section .data

section .text
    global AsmCloseLink
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCloseLink:
    cmp rdi, 0
    je .bye_error0

    push r12
    push r13
    push r14
    mov r12, rdi

    mov byte[LINK_THREAD_VAR], 1 ; set the thread exit value
    .wait_thread_close:
        cmp byte[LINK_THREAD_VAR], 0 ; wait for thread to close
        jne .wait_thread_close

    mov r13, qword[LINK_EVENT_QUEUE]
    .clear_queue:
        cmp r13, 0
        je .delete_thread
        mov r14, qword[r13]
        mov rdi, r13
        call AsmDalloc
        mov r13, r14
        jmp .clear_queue

    .delete_thread:
    mov rax, 3
    mov rdi, qword[LINK_SOCKET]
    syscall
    cmp rax, 0
    jl .bye_error

    mov rdi, qword[LINK_THREAD_STACK]
    call AsmDalloc
        
    mov rdi, r12
    call AsmDalloc

    pop r14
    pop r13
    pop r12
    xor rax, rax
    ret

    .bye_error:
        pop r14
        pop r13
        pop r12
    .bye_error0:
        mov rax, -1
        ret

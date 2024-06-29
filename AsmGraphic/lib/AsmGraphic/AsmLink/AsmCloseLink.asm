section .data

section .text
    global AsmCloseLink
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCloseLink:
    cmp rdi, 0
    je .bye_error
    
    mov r9, qword[rdi + 4] ; get the thread_info
    mov byte[r9 + 1], 1 ; set the thread exit value
    .wait_thread_close:
        cmp byte[r9 + 1], 0 ; wait for thread to close
        jne .wait_thread_close
    .clear_queue:
        mov r9, qword[rdi + 4] ; get the thread_info
        add r9, 14 ; go to event_queue
        cmp qword[r9], 0
        je .delete_thread
        mov r10, r9
        .go_to_next:
            mov r9, qword[r9]
            cmp qword[r9], 0
            je .find_event
            mov r10, qword[r10]
            jmp .go_to_next
        .find_event:
            mov r11, qword[rdi + 4]
            mov qword[r10], 0
            CALL_ AsmDalloc, r9
            jmp .clear_queue

    .delete_thread:
    mov r9, qword[rdi + 4] ; get the thread_info
    mov r11, qword[r9 + 6]
    CALL_ AsmDalloc, r11
    CALL_ AsmDalloc, r9

    CALL_ AsmAlloc, 4
    mov r9, rax

    mov byte[r9], 112
    mov byte[r9 + 1], 0
    mov word[r9 + 2], 1

    push rdi
    mov rax, 1
    xor r10, r10
    mov r10d, dword[rdi]
    mov rdi, r10
    mov rsi, r9
    mov rdx, 4
    syscall
    pop rdi

    CALL_ AsmDalloc, r9

    push rdi
    mov rax, 3
    xor r10, r10
    mov r10d, dword[rdi]
    syscall
    pop rdi

    CALL_ AsmDalloc, rdi

    xor rax, rax
    ret
    .bye_error:
        mov rax, -1
        ret

section .data

section .text
    global AsmCreateWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateWindow:
    cmp rdi, 0
    je .bye_error0
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx

    mov rdi, 32 + 4 + 4 ; create window minimum + 2 values
    call AsmAlloc
    cmp rax, 0
    je .bye_error

    mov r15, rax
    mov byte[r15], 1 ; set create_window request
    mov byte[r15 + 1], 0 ; set depth
    mov word[r15 + 2], 8 + 2 ; set length minimum + 2 value

    mov r10d, dword[LINK_ID]
    add r10d, dword[LINK_ID_GENERATOR]
    add dword[r15 + 4], r10d ; set window_id
    inc dword[LINK_ID_GENERATOR]

    mov r8, r12
    add r8, 74
    movzx r9, word[LINK_VENDOR_LENGTH]
    neg r9
    and r9, -4
    neg r9
    add r8, r9
    movzx rax, byte[LINK_FORMAT_LENGTH]
    mov r9, 8
    mul r9
    add r8, rax ; go to root section

    mov r9d, dword[r8]
    mov dword[r15 + 8], r9d ; set parent_id
    mov dword[r15 + 12], 0 ; set pos
    mov dword[r15 + 16], r13d ; set size
    mov word[r15 + 20], 1 ; set group/class
    mov word[r15 + 22], 1 ; set border-width
    mov r9d, dword[r8 + 32]
    mov dword[r15 + 24], r9d ; set visual_id
    mov dword[r15 + 28], 2050 ; set bitmask
    mov dword[r15 + 32], 0; set background to black
    mov dword[r15 + 36], 0x1 | 0x4 | 0x20000 ; key press | button press | structure_notify
    
    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [r15]
    mov rdx, 32 + 4 + 4
    syscall ; send my message
    cmp rax, rdx
    jne .bye_error

    mov rdi, 18
    call AsmAlloc
    cmp rax, 0
    je .bye_error

    mov r8d, dword[r15 + 4]
    mov dword[rax], r8d
    mov dword[rax + 4], 0
    mov qword[rax + 8], r12
    mov dword[rax + 16], 0
    mov dword[rax + 20], r13d
    mov word[rax + 24], 0
    xchg r15, rax

    mov rdi, rax
    call AsmDalloc

    sub rsp, 24
    mov byte[rsp], 16 ; code
    mov byte[rsp + 1], 1 ; only if exist
    mov word[rsp + 2], 6 ; 2 + 16 / 4
    mov word[rsp + 4], 16 ; my_strlen de l'atom
    mov byte[rsp + 8], 'W'
    mov byte[rsp + 9], 'M'
    mov byte[rsp + 10], '_'
    mov byte[rsp + 11], 'D'
    mov byte[rsp + 12], 'E'
    mov byte[rsp + 13], 'L'
    mov byte[rsp + 14], 'E'
    mov byte[rsp + 15], 'T'
    mov byte[rsp + 16], 'E'
    mov byte[rsp + 17], '_'
    mov byte[rsp + 18], 'W'
    mov byte[rsp + 19], 'I'
    mov byte[rsp + 20], 'N'
    mov byte[rsp + 21], 'D'
    mov byte[rsp + 22], 'O'
    mov byte[rsp + 23], 'W'

    mov rax, 1
    mov rdi, qword[r12]
    lea rsi, [rsp]
    mov rdx, 24
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error

    ; call AsmWaitReply

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

; aCreateWindow:
;     xor r8, r8
;     mov r8, rdi ; get link
    
;     push rdx
;     push rdi
;     push r8
;     push rsi
;     mov rdi, 32 ; add basic need for this request
;     add rdi, 8 ; add 2 value
;     call my_malloc
;     mov r9, rax ; set my message
;     pop rsi
;     pop r8

;     mov byte[r9], 1 ; set create_window request
;     mov byte[r9 + 1], 0 ; set depth
;     mov word[r9 + 2], 10 ; set length

;     mov r10d, dword[r8 + 24]
;     mov dword[r9 + 4], r10d
;     mov r10d, dword[rel generate_id]
;     add dword[r9 + 4], r10d ; set window_id
;     inc dword[rel generate_id]

;     mov r10, r8
;     add r10, 20
;     add r10, 32 ; set r10 at end of know info
;     xor r11, r11
;     mov r11w, word[r8 + 36]
;     add r10, r11 ; add vendor length
;     xor rax, rax
;     mov al, byte[r8 + 41]
;     mov r11, 8
;     mul r11
;     add r10, rax ; add format length

;     mov r11d, dword[r10]
;     mov dword[r9 + 8], r11d ; set parent

;     add r10, 32
;     mov r11d, dword[r10]
;     mov dword[r9 + 24], r11d ; set visual 

;     mov word[r9 + 12], 200 ; set x
;     mov word[r9 + 14], 200 ; set y

;     mov r10w, word[rsi]
;     mov word[r9 + 16], r10w ; set width
;     mov r10w, word[rsi + 2]
;     mov word[r9 + 18], r10w ; set height

;     mov word[r9 + 20], 1 ; set group/class
;     mov word[r9 + 22], 1 ; set border-width

;     mov dword[r9 + 28], 2050 ; set bitmask

;     mov dword[r9 + 32], 0; set first value at purple

;     mov dword[r9 + 36], 131077 ; key press | button press | structure_notify

;     mov rax, 1
;     xor rdi, rdi
;     mov edi, dword [r8]
;     lea rsi, [r9]
;     mov rdx, 40
;     syscall ; send my message

;     xor rax, rax
;     mov eax, dword[r9 + 4]

;     push rax
;     mov rdi, r9
;     call my_free

;     CALL_ my_malloc, 20
;     mov r8, rax
;     pop rax
;     mov dword[r8], eax

;     pop rdi
;     mov rsi, rax
;     push r8
;     push rdi

;     push rsi
;     CALL_ my_malloc, 24
;     mov r9, rax

;     mov byte[r9], 16 ; code
;     mov byte[r9 + 1], 1 ; only if exist
;     mov word[r9 + 2], 6 ; 2 + 16 / 4
;     mov word[r9 + 4], 16 ; my_strlen de l'atom
;     mov byte[r9 + 8], 'W'
;     mov byte[r9 + 9], 'M'
;     mov byte[r9 + 10], '_'
;     mov byte[r9 + 11], 'D'
;     mov byte[r9 + 12], 'E'
;     mov byte[r9 + 13], 'L'
;     mov byte[r9 + 14], 'E'
;     mov byte[r9 + 15], 'T'
;     mov byte[r9 + 16], 'E'
;     mov byte[r9 + 17], '_'
;     mov byte[r9 + 18], 'W'
;     mov byte[r9 + 19], 'I'
;     mov byte[r9 + 20], 'N'
;     mov byte[r9 + 21], 'D'
;     mov byte[r9 + 22], 'O'
;     mov byte[r9 + 23], 'W'

;     mov rax, 1
;     xor r10, r10
;     mov r10d, dword[rdi]
;     mov rdi, r10
;     lea rsi, [r9]
;     mov rdx, 24
;     syscall

;     CALL_ my_free, r9

;     pop rsi
;     pop rdi
;     push rdi
;     push rsi

;     CALL_ wait_reply, rdi
;     mov r9, rax

;     xor r8, r8
;     mov r8d, dword[r9 + 16]

;     CALL_ my_free, r9

;     CALL_ my_malloc, 20
;     mov r9, rax

;     mov byte[r9], 16 ; code
;     mov byte[r9 + 1], 0 ; only if exits
;     mov word[r9 + 2], 5 ; 2 + 12 / 4
;     mov word[r9 + 4], 12 ; my_strlen de l'atom
;     mov byte[r9 + 8], 'W'
;     mov byte[r9 + 9], 'M'
;     mov byte[r9 + 10], '_'
;     mov byte[r9 + 11], 'P'
;     mov byte[r9 + 12], 'R'
;     mov byte[r9 + 13], 'O'
;     mov byte[r9 + 14], 'T'
;     mov byte[r9 + 15], 'O'
;     mov byte[r9 + 16], 'C'
;     mov byte[r9 + 17], 'O'
;     mov byte[r9 + 18], 'L'
;     mov byte[r9 + 19], 'S'

;     mov rax, 1
;     xor r10, r10
;     mov r10d, dword[rdi]
;     mov rdi, r10
;     lea rsi, [r9]
;     mov rdx, 20
;     syscall

;     CALL_ my_free, r9

;     pop rsi
;     pop rdi
;     push rdi
;     push rsi
;     CALL_ wait_reply, rdi
;     mov r9, rax

;     xor r10, r10
;     mov r10d, dword[r9 + 16]

;     CALL_ my_free, r9

;     CALL_ my_malloc, 28
;     mov r9, rax

;     pop rsi
;     mov byte[r9], 18 ; code
;     mov byte[r9 + 1], 0 ; replace
;     mov word[r9 + 2], 7 ; 6 + 1
;     mov dword[r9 + 4], esi ; window_id
;     mov dword[r9 + 8], r10d ; WM_PROTOCOLS atom
;     mov dword[r9 + 12], 4 ; type ATOM
;     mov byte[r9 + 16], 32 ; format en 4octet
;     mov dword[r9 + 20], 1 ; 1 atom
;     mov dword[r9 + 24], r8d

;     push rsi
;     mov rax, 1
;     xor r10, r10
;     mov r10d, dword[rdi]
;     mov rdi, r10
;     lea rsi, [r9]
;     mov rdx, 28
;     syscall

;     CALL_ my_free, r9

;     pop rsi
;     pop rdi

;     CALL_ my_malloc, 8
;     mov r9, rax

;     mov byte[r9], 14
;     mov word[r9 + 2], 2
;     xor r10, r10
;     mov r10d, esi
;     mov dword[r9 + 4], r10d

;     push rdi
;     push rsi
;     mov rax, 1
;     xor r10, r10
;     mov r10d, dword[rdi]
;     mov rdi, r10
;     lea rsi, [r9]
;     mov rdx, 8
;     syscall
;     pop rsi
;     pop rdi

;     CALL_ my_free, r9

;     CALL_ wait_reply, rdi

;     pop r8
;     mov r10d, dword[rax + 20]
;     mov dword[r8 + 8], r10d
;     mov r11d, dword[rax + 24]
;     mov dword[r8 + 12], r11d
;     mov r10b, byte[rax + 9]
;     mov byte[r8 + 16], r10b
;     push r8
;     mov r8b, byte[rax + 9]

;     CALL_ my_free, rax

;     CALL_ my_malloc, 16
;     mov r9, rax

;     mov byte[r9], 53 ; create pixmap
;     mov byte[r9 + 1], r8b ; set depth
;     mov word[r9 + 2], 4 ; set length
;     mov r10d, dword[rdi + 24]
;     mov dword[r9 + 4], r10d
;     mov r10d, dword[rel generate_id]
;     add dword[r9 + 4], r10d ; set pixmap id
;     inc dword[rel generate_id]
;     mov dword[r9 + 8], esi ; set ref window id
;     mov dword[r9 + 12], r11d ; set width and heigth

;     push rdi
;     mov rax, 1
;     xor r10, r10
;     mov r10d, dword[rdi]
;     mov rdi, r10
;     lea rsi, [r9]
;     mov rdx, 16
;     syscall
;     pop rdi

;     pop r8
;     mov r10d, dword[r9 + 4]
;     mov dword[r8 + 4], r10d
;     mov byte[r8 + 17], 244
;     mov byte[r8 + 18], 1
;     mov byte[r8 + 19], 0

;     CALL_ my_free, r9

;     pop rdx
;     CALL_ aRenameWindow, rdi, r8, rdx

;     mov rax, r8

;     ret
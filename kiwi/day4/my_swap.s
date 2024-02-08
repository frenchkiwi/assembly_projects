.global my_swap
.intel_syntax noprefix

.text
    my_swap:
        xchg rdi, rsi
        ret

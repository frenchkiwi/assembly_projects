#include <linux/futex.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>

// Adresse du futex
int futex_addr = 0;

// Fonction pour appeler le syscall futex
int futex(int *uaddr, int futex_op, int val, const struct timespec *timeout, int *uaddr2, int val3) {
    return syscall(SYS_futex, uaddr, futex_op, val, timeout, uaddr2, val3);
}

// Fonction pour acquérir le futex
void futex_lock(int *futex_addr) {
    if (__sync_lock_test_and_set(futex_addr, 1) != 0) {
        // Chemin lent : attente si le futex est déjà verrouillé
        while (__sync_lock_test_and_set(futex_addr, 2) != 0) {
            futex(futex_addr, FUTEX_WAIT, 2, NULL, NULL, 0);
        }
    }
}

// Fonction pour libérer le futex
void futex_unlock(int *futex_addr) {
    if (__sync_fetch_and_sub(futex_addr, 1) != 1) {
        __sync_lock_release(futex_addr);
        futex(futex_addr, FUTEX_WAKE, 1, NULL, NULL, 0);
    }
}

int main() {
    // Exemples d'utilisation des fonctions futex_lock et futex_unlock
    futex_lock(&futex_addr);
    printf("Futex acquis\n");
    futex_unlock(&futex_addr);
    printf("Futex libéré\n");

    return 0;
}

// __sync_lock_test_and_set:
    // mov rax, rsi
    // lock xchg byte[rdi], rax
    // ret

// __sync_fetch_and_sub:
    // mov rax, rsi
    // lock xadd byte[rdi], rax
    // ret

// __sync_lock_release:
    // mov rax, 0
    // lock xchg byte[rdi], rax
    // ret

// futex_lock:
//     mov rax, 1
//     lock xchg byte[rdi], rax
//     cmp rax, 0
//     je .bye
//     .loop:
//         mov rax, 2
//         lock xchg byte[rdi], rax
//         cmp rax, 0
//         je .bye
//         mov rax, 202
//         mov rdi, rdi
//         mov rsi, 0
//         mov rdx, 2
//         mov r10, 0
//         mov r8, 0
//         syscall
//         jmp .loop
//     .bye:
//         ret

// futex_unlock:
//     mov rax, rsi
//     lock xadd byte[rdi], rax
//     cmp rax, 1
//     je .bye
//     mov rax, 0
//     lock xchg byte[rdi], rax
//     mov rax, 202
//     mov rdi, rdi
//     mov rsi, 1
//     mov rdx, 1
//     mov r10, 0
//     mov r8, 0
//     syscall
//     .bye:
//         ret

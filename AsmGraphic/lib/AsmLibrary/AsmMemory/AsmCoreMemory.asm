section .data
    AsmCoreMemory dq -1 ; 8octet for next_malloc_page | 8octet free to use | 240 node of (8octet for size of allocation | 8octet for addr of allocation | 1octet for allocation state (1 = owned | 0 = free))
    AsmFutexMemory db 0 ; futex for memory action

section .text
    global AsmCoreMemory
    global AsmFutexMemory
    %include "AsmLibrary.inc"
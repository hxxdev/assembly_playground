bits 64
default rel

segment .data
    msg db "Hello world! %d", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess
extern printf
main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    lea     rcx, [msg]
    mov     edx, 5
    call    printf

    xor     rax, rax
    call    ExitProcess

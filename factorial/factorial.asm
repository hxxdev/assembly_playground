default rel
bits 64

segment .data
    msg db "factorial is %d", 0xd, 0xa, 0

segment .text
global main
global factorial
extern _CRT_INIT
extern printf
extern ExitProcess
factorial:
    push    rbp
    mov     rbp , rsp
    sub     rsp , 32

    test    ecx , ecx       ; input n
    jz      .zero           ; if n == 0

    mov     ebx , 1         ; iteration index ebx = 1
    mov     eax , 1         ; result eax = 1
    inc     ecx             ; increment n by 1 to loop through 1~n.

.for_loop:
    cmp     ebx , ecx
    je      .end_loop
    mul     ebx             ; eax = eax * ebx
    inc     ebx
    jmp     .for_loop

.zero:
    mov     eax , 1

.end_loop:
    leave
    ret

main:
    push    rbp
    mov     rbp , rsp
    sub     rsp , 32

    mov     rcx , 5
    call    factorial       ; factorial(5)

    lea     rcx , [msg]
    mov     rdx , rax
    call    printf

    xor     rax , rax
    call    ExitProcess

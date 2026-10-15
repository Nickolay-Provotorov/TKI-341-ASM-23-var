section .data
    a    dd 5678901
    b    dd 6789012
    c    dd 7890123
    d    dd 8901234
    e    dd 9012345
    f    dd 10123456

    quot dd 0
    rem  dd 0

section .text
    global _start

_start:
    imul esi, [a], 4
    sub  esi, [b]
    dec  esi

    mov  eax, [c]
    cdq
    idiv dword [b]
    add  eax, [a]
    mov  ebx, eax

    mov  eax, esi
    cdq
    idiv ebx

    mov  [quot], eax
    mov  [rem], edx

done:
    mov  eax, 1
    xor  ebx, ebx
    int  0x80

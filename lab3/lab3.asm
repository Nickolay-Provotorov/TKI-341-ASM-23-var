section .data
    data       times 512 dw 0
    cnt_even   dw 0
    cnt_odd    dw 0
    cnt_ge50k  dw 0
    cnt_lt10k  dw 0
    seed       dw 12345

    filename   db "counters.txt", 0

    lbl_even   db "Even count    : "
    len_even   equ $ - lbl_even

    lbl_odd    db "Odd count     : "
    len_odd    equ $ - lbl_odd

    lbl_ge50k  db "GE 50k count  : "
    len_ge50k  equ $ - lbl_ge50k

    lbl_lt10k  db "LT 10k count  : "
    len_lt10k  equ $ - lbl_lt10k

    newline    db 10

section .bss
    fd         resd 1
    num_buf    resb 12

section .text
    global _start

_start:

main_loop:
    mov ax, [cnt_even]
    cmp ax, 128
    jge exit

    mov ax, [cnt_odd]
    cmp ax, 128
    jge exit

    mov ax, [cnt_ge50k]
    cmp ax, 128
    jge exit

    mov ax, [cnt_lt10k]
    cmp ax, 128
    jge exit

    mov ax, [seed]
    add ax, 9283
    mov [seed], ax
    mov bx, ax

    test bx, 1
    jz is_even
    jmp is_odd

is_even:
    movzx ecx, word [cnt_even]
    mov [data + ecx*2], bx
    inc word [cnt_even]
    jmp check_value_ranges

is_odd:
    movzx ecx, word [cnt_odd]
    mov [data + 256 + ecx*2], bx
    inc word [cnt_odd]

check_value_ranges:
    cmp bx, 50000
    jl check_10k
    movzx ecx, word [cnt_ge50k]
    mov [data + 512 + ecx*2], bx
    inc word [cnt_ge50k]

check_10k:
    cmp bx, 10000
    jge main_loop
    movzx ecx, word [cnt_lt10k]
    mov [data + 768 + ecx*2], bx
    inc word [cnt_lt10k]

    jmp main_loop

exit:
    mov eax, 5
    mov ebx, filename
    mov ecx, 0x241
    mov edx, 0666h
    int 0x80
    mov [fd], eax

    mov ecx, lbl_even
    mov edx, len_even
    call print_both

    movzx eax, word [cnt_even]
    call num_to_str

    mov ecx, newline
    mov edx, 1
    call print_both

    mov ecx, lbl_odd
    mov edx, len_odd
    call print_both

    movzx eax, word [cnt_odd]
    call num_to_str

    mov ecx, newline
    mov edx, 1
    call print_both

    mov ecx, lbl_ge50k
    mov edx, len_ge50k
    call print_both

    movzx eax, word [cnt_ge50k]
    call num_to_str

    mov ecx, newline
    mov edx, 1
    call print_both

    mov ecx, lbl_lt10k
    mov edx, len_lt10k
    call print_both

    movzx eax, word [cnt_lt10k]
    call num_to_str

    mov ecx, newline
    mov edx, 1
    call print_both

    mov eax, 6
    mov ebx, [fd]
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

print_both:
    push edx
    push ecx

    mov eax, 4
    mov ebx, [fd]
    mov ecx, [esp]
    mov edx, [esp + 4]
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, [esp]
    mov edx, [esp + 4]
    int 0x80

    pop ecx
    pop edx
    ret

num_to_str:
    mov edi, num_buf + 11
    mov byte [edi], 0
    mov ecx, 10

.loop:
    xor edx, edx
    div ecx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .loop

    mov ecx, edi
    mov edx, num_buf + 11
    sub edx, ecx

    call print_both
    ret

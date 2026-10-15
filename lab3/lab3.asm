section .data
    seed      dd 0
    cnt_even  dd 0
    cnt_odd   dd 0
    cnt_big   dd 0
    cnt_small dd 0

section .bss
    data resw 512

section .text
    global _start

randomize:
    push edx
    rdtsc
    mov  [seed], eax
    pop  edx
    ret

random:
    push ecx
    push edx
    mov  ecx, eax
    mov  eax, [seed]
    imul eax, eax, 0x08088405
    inc  eax
    mov  [seed], eax
    mul  ecx
    mov  eax, edx
    pop  edx
    pop  ecx
    ret

_start:
    call randomize

loop_start:
    mov  eax, 65536
    call random
    movzx ebx, ax

    test bl, 1
    jnz  odd_number

    mov  ecx, [cnt_even]
    mov  [data + ecx*2], bx
    inc  dword [cnt_even]
    jmp  check_big

odd_number:
    mov  ecx, [cnt_odd]
    mov  [data + 256 + ecx*2], bx
    inc  dword [cnt_odd]

check_big:
    cmp  ebx, 50000
    jb   check_small
    mov  ecx, [cnt_big]
    mov  [data + 512 + ecx*2], bx
    inc  dword [cnt_big]
    jmp  check_end

check_small:
    cmp  ebx, 10000
    jae  check_end
    mov  ecx, [cnt_small]
    mov  [data + 768 + ecx*2], bx
    inc  dword [cnt_small]

check_end:
    cmp  dword [cnt_even], 127
    ja   done
    cmp  dword [cnt_odd], 127
    ja   done
    cmp  dword [cnt_big], 127
    ja   done
    cmp  dword [cnt_small], 127
    ja   done
    jmp  loop_start

done:
    mov  eax, 1
    xor  ebx, ebx
    int  0x80

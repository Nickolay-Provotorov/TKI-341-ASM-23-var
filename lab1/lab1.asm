section .test
	global _start

_start:
	mov eax, 0x11111111
	mov ebx, 0x22222222

	xchg eax, ebx

	mov eax, 0x33333333
	mov ebx, 0x44444444

	push eax
	push ebx
	pop eax
	pop ebx

	mov eax, 0x55555555
	mov ebx, 0x66666666

	mov ecx, eax
	mov eax, ebx
	mov ebx, ecx

	mov eax, 0x77777777
	mov ebx, 0x88888888

	lea ecx, [eax]
	lea eax, [ebx]
	lea ebx, [ecx]

	mov ax, 0x1111
	mov bx, 0x2222

	xchg ax, bx

	mov ax, 0x3333
	mov bx, 0x4444

	push ax
	push bx
	pop ax
	pop bx

	mov ax, 0x5555
	mov bx, 0x6666

	mov cx, ax
	mov ax, bx
	mov bx, cx

	mov bx, 0x7777
	mov si, 0x8888

	lea bp, [si]
	lea si, [bx]
	lea bx, [bp]

	mov al, 0x11
	mov bl, 0x22

	xchg al, bl

	mov al, 0x55
	mov bl, 0x66

	mov cl, al
	mov al, bl
	mov bl, cl

	mov eax, 1
 	xor ebx, ebx
	int 0x80

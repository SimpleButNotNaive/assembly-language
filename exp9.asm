assume cs:codeseg, ds:dataseg

dataseg segment
    db 'welcome to masm!'
dataseg ends

codeseg segment
start:
    mov ax, dataseg
    mov ds, ax

    mov ax, 0b800h
    mov es, ax

    mov cx, 16
    mov bx, 3eh
    xor di, di
    xor si, si
s:
    mov al, [si]
    mov es:[bx + di], al
    mov byte ptr es:[bx + di + 1], 10001010b

    mov es:[bx + di + 160], al
    mov byte ptr es:[bx + di + 161], 00101100b

    mov es:[bx + di + 320], al
    mov byte ptr es:[bx + di + 321], 01110001b

    inc si
    add di, 2

    loop s

    mov ax, 4c00h
    int 21h

codeseg ends
end start
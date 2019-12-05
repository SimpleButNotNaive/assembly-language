assume cs:codeseg

dataseg segment
    dw 7c00h, 0
dataseg ends
codeseg segment
    start:
        mov ax, 0
        mov es, ax
        mov bx, 7c00h

        mov ax, dataseg
        mov ds, ax

        mov ah, 02h
        mov al, 1
        mov ch, 0
        mov cl, 1
        mov dh, 0
        mov dl, 80h
        int 13h

        jmp dword ptr ds:[0]

codeseg ends
end start
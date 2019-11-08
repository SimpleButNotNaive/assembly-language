assume cs:codeseg, ds:dataseg

dataseg segment
    db "??/??/?? ??:??:??"
dataseg ends

codeseg segment
    start:
        mov ax, dataseg
        mov ds, ax

        ;处理年：
        mov al, 9
        out 70h, al
        in al, 71h

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b

        add ah, 30h
        add al, 30h

        mov ds:[0], ah
        mov ds:[1], al

        ;处理月
        mov al, 8
        out 70h, al
        in al, 71h

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b

        add ah, 30h
        add al, 30h

        mov ds:[3], ah
        mov ds:[4], al

        mov al, 7
        out 70h, al
        in al, 71h

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b

        add ah, 30h
        add al, 30h

        mov ds:[6], ah
        mov ds:[7], al

        ;处理时
        mov al, 4
        out 70h, al
        in al, 71h

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b

        add ah, 30h
        add al, 30h

        mov ds:[9], ah
        mov ds:[10], al

        mov al, 2
        out 70h, al
        in al, 71h

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b

        add ah, 30h
        add al, 30h

        mov ds:[12], ah
        mov ds:[13], al

        mov al, 0
        out 70h, al
        in al, 71h

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b

        add ah, 30h
        add al, 30h

        mov ds:[15], ah
        mov ds:[16], al

        mov ax, 0b800h
        mov es, ax
        mov si, 0
        mov di, 160*10+2*10
        mov cx, 17
    show_str_cycle:
        mov al, [si]
        mov es:[di], al

        inc si
        add di, 2
        loop show_str_cycle
        jmp start


        mov ax, 4c00h
        int 21h
codeseg ends
end start
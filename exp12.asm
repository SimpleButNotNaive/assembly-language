assume cs:codeseg

codeseg segment
    start:
        mov ax, cs
        mov ds, ax
        mov si, offset do0 ; ds:si指向源地址

        mov ax, 0
        mov es, ax
        mov di, 200h ;es:di指向目的地址 0:200

        mov cx, offset do0_end - offset do0
        cld

        rep movsb 

        mov ax, 0
        mov es, ax
        mov word ptr es:[0*4], 200h
        mov word ptr es:[0*4 + 2], 0

        int 0

        mov ax, 4c00h
        int 21h
    do0:
        jmp short do0_start
        db "divide error !"
    do0_start:
        mov ax, cs
        mov ds, ax
        mov si, 202h 

        mov ax, 0b800h
        mov es, ax
        mov di, 12*160+36*2

        mov cx, 14
    do0_loop:
        mov al, ds:[si]
        mov es:[di], al
        inc si
        add di, 2
        loop do0_loop

        mov ax, 4c00h
        int 21h
    do0_end:
        nop
codeseg ends
end start
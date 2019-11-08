assume cs:codeseg, ss:stackseg

stackseg segment stack
    dw 32 dup(?)
stackseg ends

codeseg segment
    start:
        mov ax, cs
        mov ds, ax
        mov si, offset int_7c

        mov ax, stackseg
        mov ss, ax
        mov sp, 64

        mov ax, 0
        mov es, ax
        mov di, 200h


        mov cx, offset int_7c_end - offset int_7c
        cld

        rep movsb

        mov ax, 0
        mov es, ax
        mov word ptr es:[7ch*4], 200h
        mov word ptr es:[7ch*4 + 2], 0

        mov cx, 5
        mov bx, offset cycle - offset cycle_end
        mov ax, 0b800h
        mov es, ax
        mov di, 160*10+2*21

    cycle:
        mov byte ptr es:[di], 'h'
        add di, 2
        int 7ch
    cycle_end:

        mov ax, 4c00h
        int 21h

    int_7c:
        push bp
        mov bp, sp
        dec cx
        jcxz int_7c_return 

        add ss:[bp + 2], bx
    int_7c_return:
        pop bp
        iret
    int_7c_end:
        nop
codeseg ends
end start
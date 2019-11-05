assume cs:codeseg, ds:a, ss:b

a segment
    dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh, 0ffh
a ends

b segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
b ends

codeseg segment
    start:
        mov ax, a
        mov ds, ax

        mov ax, b
        mov ss, ax
        mov sp, 16
        
        mov cx, 8
        mov bx, 16
    s:
        sub bx, 2
        mov ax, ds:[bx]

        push ax
        loop s

        mov ax, 4c00h
        int 21h

codeseg ends
end start
assume cs:codeseg
codeseg segment

    mov ax, 0
    mov ds, ax

    mov bx, 200h
    mov cx, 3fh

s:
    mov [bx], bl
    inc bx
    loop s

    mov ax, 4c00h
    int 21h

codeseg ends
end
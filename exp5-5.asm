assume cs:code, ds:a, es:c

a segment
    db 1, 2, 3, 4, 5, 6, 7, 8
a ends

b segment 
    db 1, 2, 3, 4, 5, 6, 7, 8
b ends

c segment
    db 0, 0, 0, 0, 0, 0, 0, 0
c ends

code segment
start:
    mov ax, c
    mov es, ax

    mov cx, 8
    mov bx, 0
s:
    mov ax, a
    mov ds, ax

    mov dx, ds:[bx]

    mov ax, b
    mov ds, ax

    add dx, ds:[bx]
    mov es:[bx], dx
    
    inc bx
    loop s

    mov ax, 4c00h
    int 21h

code ends
end start
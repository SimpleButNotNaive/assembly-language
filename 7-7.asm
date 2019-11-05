assume cs:codeseg, ds:dataseg, ss:stackseg

dataseg segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
dataseg ends

stackseg segment
    dw 8 dup(0)
stackseg ends

codeseg segment
start:
    mov ax, dataseg
    mov ds, ax

    mov ax, stackseg
    mov ss, ax
    mov sp, 16

    mov cx, 4
    xor bx, bx
outer:
    push cx
    mov cx, 3 
    xor si, si
inner:
    mov al, [bx + si]
    add al, 11011111b
    mov [bx + si], al
    inc si
    loop inner

    pop cx
    add bx, 16
    loop outer

    mov ax, 4c00h
    int 21h

codeseg ends
end start
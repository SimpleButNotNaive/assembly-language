assume cs:codeseg, ss:stackseg, ds:dataseg

dataseg segment
    db '1. display    '
    db '2. brows      '
    db '3. replace    '
    db '4. modify     '
dataseg ends

stackseg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stackseg ends

codeseg segment
start:
    mov ax, dataseg
    mov ds, ax

    mov ax, stackseg
    mov ss, ax
    mov sp, 16

    mov cx, 4
    mov bx, 0
outer:
    push cx
    mov cx, 4
    xor si, si
inner:
    mov al, [3 + bx + si]
    and al, 11011111b
    mov [3 + bx + si], al
    inc si
    loop inner

    pop cx 
    add bx, 14 
    loop outer

    mov ax, 4c00h
    int 21h

codeseg ends
end start
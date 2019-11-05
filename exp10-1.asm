assume cs:codeseg, ds:dataseg

dataseg segment
    db 'liangqiaocheng' 
    db 3
    db 'wangyi', 0
dataseg ends


codeseg segment
start:
    mov ax, dataseg
    mov ds, ax

    mov dh, 3
    mov dl, 0
    mov al, 2

    mov cx, 3
big_cycle:
    push cx
    mov cx, 20
    mov si, 0
    mov dh, 3
    inc dl
cycle:
    push cx
    mov cl, al

    call show_str
    inc al

    inc dh
    inc dl

    pop cx
    loop cycle

    pop cx

    loop big_cycle

    mov ax, 4c00h
    int 21h

show_str:
    ;使用的寄存器入栈：
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov bx, 0b800h
    mov es, bx

    mov al, 160
    mul dh

    add dl, dl
    mov dh, 0
    add ax, dx

    mov bx, ax

    xor di, di
    mov dl, cl
s:
    mov cl, [si]
    mov ch, 0
    jcxz finish 

    mov ch, dl
    mov es:[bx + di], cx
    inc si
    add di, 2
    jmp s

finish:
    ;恢复之前保存的寄存器
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    mov es, bx

    ret
codeseg ends
end start
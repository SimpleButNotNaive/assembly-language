assume cs:codeseg, ss:stackseg

stackseg segment
    dw 16 dup(?)
stackseg ends

codeseg segment
start:
    mov ax, stackseg
    mov ss, ax
    mov sp, 32

    mov ax, 4240h
    mov dx, 000fh    
    mov cx, 0ah

    call divdw

    mov ax, 4c00h
    int 21h

divdw:
    push bx
    mov bx, dx
    ; bx = H

    push cx
    push dx
    call quotient
    add sp, 4
    ; dx = int(H/N)*65536的高位
    push dx

    mov dx, bx
    push cx
    push dx
    call reminder
    add sp, 4
    ; dx = rem(H/N)*65536的高位

    div cx
    ; ax = rem(H/N)*65536 + L的商
    ; dx 为余数
    mov cx, dx

    pop dx
    pop bx
    ret
; sp + 2：16位被除数, sp + 4：16位除数
;入栈顺序：2               1        
;返回值：dx
quotient:
    push ax
    push bx
    push bp

    mov bp, sp

    mov ax, [bp + 8]
    mov dx, 0
    mov bx, [bp + 10]

    div bx
    mov dx, ax

    pop bp
    pop bx
    pop ax
    ret 
reminder:
    push ax
    push bx
    push bp

    mov bp, sp

    mov ax, [bp + 8]
    mov dx, 0
    mov bx, [bp + 10]

    div bx

    pop bp
    pop bx
    pop ax
    ret 

codeseg ends

end start
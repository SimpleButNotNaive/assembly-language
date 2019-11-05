assume cs:codeseg, ds:dataseg, ss:stackseg

dataseg segment
    db 10 dup(0)
dataseg ends

stackseg segment
    dw 16 dup(0)
stackseg ends

codeseg segment
start:
    mov ax, dataseg
    mov ds, ax

    mov ax, stackseg
    mov ss, ax
    mov sp, 32

    mov ax, 14305
    mov si, 0
    call dtoc

    mov dh, 8
    mov dl, 3
    mov cl, 2
    call show_str

    mov ax, 4c00h
    int 21h

;将word型数据转化为十进制字符串，结果存在si指向的空间中
; 参数：ax 要转换的数
dtoc:
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx, si
dtoc_cycle:
    xor dx, dx
    mov cx, 10
    ;设置每次除法的除数

    call divdw
    ; 参数：ax被除数低16位，dx被除数高16位，cx：除数
    ; 返回值：ax结果低16位，dx结果高16位，cx：余数
    add cl, 30h
    mov [bx], cl
    inc bx
    cmp ax, 0

    jz dtoc_reverse
    jmp dtoc_cycle


dtoc_reverse:
    dec bx
dtoc_reverse2:
    cmp bx, si
    jle dtoc_end
    mov cl, [bx]
    mov dh, [si]
    mov [si], cl
    mov [bx], dh

    inc si
    dec bx
    jmp dtoc_reverse2

dtoc_end:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

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

; 参数：ax 被除数低16位，dx被除数高16位，cx：除数
; 返回值：ax结果低16位，dx结果高16位，cx：余数
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
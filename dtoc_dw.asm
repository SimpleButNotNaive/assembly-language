assume cs:codeseg, ds:dataseg

dataseg segment
    dw 5 dup(?)
dataseg ends

stackseg segment stack
    dw 32 dup(?)
stackseg ends


codeseg segment
start:
    mov ax, dataseg
    mov ds, ax

    mov ax, stackseg
    mov ss, ax
    mov sp, 20h

    mov si, 0
    mov ax, 7cc7h
    mov dx, 1h
    call dw_dtoc

    mov ax, 4c00h
    int 21h

    
;将dword型数据转化为十进制字符串，结果存在si指向的空间中
; 参数：ax 要转换的数的低十六位，dx要转换的数的高十六位
dw_dtoc:
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx, si ;将数据地址存入基址寄存器bx

dw_dtoc_cycle_ax:
    mov cx, 10
    ;设置每次除法的除数

    call divdw
    ; 参数：ax被除数低16位，dx被除数高16位，cx：除数
    ; 返回值：ax结果低16位，dx结果高16位，cx：余数
    add cl, 30h
    mov [bx], cl ;将数字转化为ascii码
    inc bx
    cmp ax, 0 ;如果结果为0则说明转化结束

    jnz dw_dtoc_cycle_ax

dw_dtoc_reverse_str:
    dec bx
dw_dtoc_reverse_str_inner:

    cmp bx, si
    jle dw_dtoc_end
    mov cl, [bx]
    mov dh, [si]
    mov [si], cl
    mov [bx], dh

    inc si
    dec bx
    jmp dw_dtoc_reverse_str_inner

dw_dtoc_end:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; 参数：ax 被除数低16位，dx被除数高16位，cx：除数
; 返回值：ax结果低16位，dx结果高16位，cx：余数
; 不会溢出的除法，被除数为dword型，除数为word型，结果为dword型
divdw:
    push bx
    mov bx, dx
    ; bx = H

    push cx
    push dx
    call divdw_calculate_quotient ;传入参数，计算int(H/N)
    add sp, 4 ;恢复栈帧
    ; dx = int(H/N)*65536的高位
    push dx ;将dx入栈保护

    mov dx, bx
    push cx
    push dx
    call divdw_calculate_reminder ;传入参数，计算rem(H/N)*65536
    add sp, 4
    ; dx = rem(H/N)*65536的高位

    ;此时dx = rem(H/N)*65536的高位，ax=L`
    div cx
    ; ax = (rem(H/N)*65536 + L)/N
    ; dx 为余数
    mov cx, dx

    pop dx
    pop bx
    ret

; sp + 2：16位被除数, sp + 4：16位除数
;返回值：dx
divdw_calculate_quotient:
    push ax
    push bx
    push bp

    mov bp, sp ;利用栈基址寄存器进行寻址

    mov ax, [bp + 8] ;将第一个参数移到ax寄存器中，作为被除数的低16位
    mov dx, 0 ;将被除数的高十六位置为0
    mov bx, [bp + 10] ;将第二个参数放到bx中作为除数

    div bx
    mov dx, ax ;将16位的商移动到dx返回

    pop bp
    pop bx
    pop ax
    ret 

; sp + 2：16位被除数, sp + 4：16位除数
;返回值：dx
divdw_calculate_reminder:
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
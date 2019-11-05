assume cs:codeseg, ds:dataseg, ss:stackseg

dataseg segment
    ; +0
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'
    ; +84
    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
    ; +168
    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800
    ; +210
    dd 5 dup(?) ;数据缓冲区
dataseg ends

; table segment
;     db 21 dup('year summ ne ?? ')
; table ends

stackseg segment stack
    dw 32 dup(?)
stackseg ends

codeseg segment
start:
    mov ax, dataseg ;初始化数据段
    mov ds, ax

    mov ax, stackseg ;初始化栈
    mov ss, ax
    mov sp, 40h

    mov cx, 21
    mov ax, 0
print_all_years:
    mov di, 210 ;设置字符串转移的目的地为缓冲区+210
    push cx  ;保存cx
    mov cx, 4 ;设置内循环循环次数
    xor si, si
transfer_one_char:
    mov dl, [si + bx]
    mov [di], dl 

    inc si
    inc di
    loop transfer_one_char

    mov byte ptr[di], 0

    pop cx

    add bx, 4

    push dx
    push cx
    mov dh, al 
    mov dl, 0
    mov cl, 2
    mov si, 210
    call show_str

    pop cx
    pop dx

    inc ax
    loop print_all_years

    mov cx, 21
    xor ax, ax
    mov bx, 84

print_all_salary:
    push ax
    mov ax, [bx]
    mov dx, [bx + 2]
    mov si, 210
    call dw_dtoc
    pop ax

    push dx
    push cx
    mov dh, al
    mov dl, 8
    mov cl, 2
    mov si, 210
    call show_str

    pop cx
    pop dx

    add bx, 4
    inc ax
    loop print_all_salary

    mov cx, 21
    mov bx, 168
    mov ax, 0
print_all_numbers_of_workers:
    push ax
    mov ax, [bx]
    mov si, 210
    call dtoc
    pop ax

    push dx
    push cx
    mov dh, al
    mov dl, 18
    mov cl, 2
    mov si, 210
    call show_str

    pop cx
    pop dx

    add bx, 2
    inc ax
    loop print_all_numbers_of_workers

    mov cx, 21
    mov ax, 0

    mov bp, 84
    mov bx, 168
print_all_average_salary:

    push ax
    push cx
    mov ax, ds:[bp]
    mov dx, ds:[bp + 2]
    mov cx, [bx]
    call divdw
    ;结果存在ax中

    mov si, 210
    call dtoc 
    pop cx
    pop ax

    push cx
    mov dh, al 
    mov dl, 25
    mov cl, 2
    mov si, 210
    call show_str
    pop cx

    inc ax
    add bx, 2
    add bp, 4
    loop print_all_average_salary

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

    mov bx, si ;将数据地址存入基址寄存器bx

dtoc_cycle:
    xor dx, dx
    mov cx, 10
    ;设置每次除法的除数

    call divdw
    ; 参数：ax被除数低16位，dx被除数高16位，cx：除数
    ; 返回值：ax结果低16位，dx结果高16位，cx：余数
    add cl, 30h
    mov [bx], cl ;将数字转化为ascii码
    inc bx
    cmp ax, 0 ;如果结果为0则说明转化结束

    jz dtoc_reverse_str
    jmp dtoc_cycle


dtoc_reverse_str:
    mov byte ptr[bx], 0
    dec bx
dtoc_reverse_str_inner:

    cmp bx, si
    jle dtoc_end
    mov cl, [bx]
    mov dh, [si]
    mov [si], cl
    mov [bx], dh

    inc si
    dec bx
    jmp dtoc_reverse_str_inner

dtoc_end:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

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
    mov byte ptr[bx], 0
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

;打印内存中的字符串
;参数：dh 行号，dl 列号，cl 颜色，ds:si指向字符串的首地址
show_str:
    ;使用的寄存器入栈：
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov bx, 0b800h
    mov es, bx ;将附加段寄存器设置为显存的基地址（0xb8000)

    mov al, 160 ;计算行首地址
    mul dh ;结果保存在ax中

    add dl, dl
    mov dh, 0
    add ax, dx ;将列地址加行首地址得到真正的地址

    mov bx, ax ;将计算出来的真正地址移动到基址寄存器bx中

    xor di, di
    mov dl, cl ;清零di，将代表颜色的数存进di
show_str_show_one_char:
    mov cl, [si]
    mov ch, 0
    jcxz show_str_finish ;如果在字符串中遇到了一个0则结束

    mov ch, dl ;将代表颜色的数值存入高8位
    mov es:[bx + di], cx ;将两个字节存到显存中

    inc si ;移动指针指向下一个字符
    add di, 2 ;移动指针指向下一个显存单元
    jmp show_str_show_one_char ;重复之前的操作

show_str_finish:
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
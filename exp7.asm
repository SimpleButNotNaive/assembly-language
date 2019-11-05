assume cs:codeseg, ds:dataseg, ss:stackseg, es:table

dataseg segment
    ; +0
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'
    ; +84
    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
    ; +164
    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800
dataseg ends

table segment
    db 21 dup('year summ ne ?? ')
table ends

stackseg segment
    dw 32 dup(?)
stackseg ends

codeseg segment
start:
    mov ax, dataseg
    mov ds, ax

    mov ax, stackseg
    mov ss, ax
    mov sp, 32

    mov ax, table
    mov es, ax

; 处理21年的年份字符串
    mov cx, 21
    xor bx, bx
    xor si, si
handle_years:
    xor di, di
    push cx
    mov cx, 4
handle_one_year:
    mov al, [si]
    mov es:[bx].0[di], al
    
    inc di
    inc si
    loop handle_one_year

    pop cx
    add bx, 16
    loop handle_years

; 处理21年的收入
    mov cx, 21
    xor si, si
    xor di, di  
handle_income:

    mov ax, 84[si]
    mov es:[di + 5], ax
    mov ax, 84[si + 2]
    mov es:[di + 7], ax

    add si, 4
    add di, 16

    loop handle_income
; 处理21年的雇员数
    mov cx, 21
    xor si, si
    xor di, di  
handle_num_employee:

    mov ax, 168[si]
    mov es:[di + 10], ax

    add si, 2
    add di, 16

    loop handle_num_employee
;计算21年的平均薪水
    mov cx, 21
    xor bx, bx

    mov ax, table
    mov ds, ax
calculate_average_income:
    mov ax, [bx + 5]
    mov dx, [bx + 7]
    div word ptr[bx + 10]
    mov [bx + 13], ax

    add bx, 16
    loop calculate_average_income


    mov ax, 4c00h
    int 21h

codeseg ends
end start
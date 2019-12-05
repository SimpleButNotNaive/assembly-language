assume cs:codeseg

codeseg segment

    int7c:
        jmp short int7c_start
        table dw int7c_clear_screen, int7c_set_front_color, int7c_set_back_color, int7c_roll_screen 
    int7c_start:
        ;保存将要被改变的寄存器
        ;根据ah中的数值调用对应的函数
        push bx
        cmp ah, 3
        ja int7c_return

        mov bl, ah
        mov bh, 0
        ;将子程序号乘2以得到入口地址的偏移量
        add bx, bx 

        call word ptr table[bx]
        ;恢复将要改变的寄存器
    int7c_return:
        pop bx
        iret

    int7c_clear_screen:
        push ax
        push cx
        push si
        push es
        ;保存寄存器
        ;将所有的字节都设置为空格
        mov ax, 0b800h
        mov es, ax
        mov cx, 2000
        mov si, 0
    int7c_clear_screen_loop:
        mov byte ptr es:[si],  ' '
        add si, 2
        loop int7c_clear_screen_loop
        ;恢复寄存器
        pop es
        pop si
        pop cx
        pop ax
        ret

    int7c_set_front_color:
        ;保存寄存器
        push bx
        push cx
        push es
        ;将每个状态字的低三位设置为al的值
        mov bx, 0b800h
        mov es, bx
        mov bx, 1
        mov cx, 2000
    int7c_set_front_color_loop:
        and byte ptr es:[bx], 11111000b
        or byte ptr es:[bx], al
        add bx, 2
        loop int7c_set_front_color_loop
        ;恢复寄存器
        pop es
        pop cx
        pop bx

        ret
    int7c_set_back_color:
        ;保存寄存器
        push bx
        push cx
        push es
        ;将每个状态字的4 5 6位设置为al的值
        mov cl, 4
        shl al, cl
        mov bx, 0b800h
        mov es, bx
        mov bx, 1
        mov cx, 2000
    int7c_set_back_color_loop:
        and byte ptr es:[bx], 10001111b
        or byte ptr es:[bx], al
        add bx, 2
        loop int7c_set_back_color_loop
        ;恢复寄存器
        pop es
        pop cx
        pop bx

        ret 
    int7c_roll_screen:
        ;保存寄存器到栈
        push cx
        push si
        push di
        push es
        push ds
        ;将前24行设置为下一行的内容
        mov cx, 24

        mov si, 0b800h
        mov es, si
        mov ds, si

        mov si, 160
        mov di, 0
        cld
    int7c_roll_screen_roll_one_line:
        push cx
        mov cx, 160
        rep movsb
        pop cx
        loop int7c_roll_screen_roll_one_line
        ;将最后一行清空
        mov cx, 80
        mov si, 0
    int7c_roll_screen_clear_last_line:
        mov byte ptr es:[si + 160*24], ' ' 
        add si, 2
        loop int7c_roll_screen_clear_last_line
        ;恢复寄存器
        pop ds
        pop es
        pop di
        pop si
        pop cx

        ret

    int7c_end:
        nop

    start:;安装程序
        ;设置段寄存器
        mov ax, cs
        mov ds, ax

        mov ax, 0
        mov es, ax
        ;安装中断处理程序到200h
        mov si, offset int7c
        mov di, 200h
        mov cx, offset int7c_end - offset int7c
        cld
        rep movsb
        ;设置中断向量表中的中断处理程序入口地址
        mov word ptr es:[7ch*4], 0
        mov word ptr es:[7ch*4+2], 20h

        mov ax, 4c00h
        int 21h
codeseg ends
end start
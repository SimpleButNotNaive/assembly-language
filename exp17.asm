assume cs:codeseg

codeseg segment
    start:
        ;设置段寄存器
        mov ax, cs
        mov ds, ax

        mov ax, 0
        mov es, ax
        ;安装中断处理程序到0:200h
        mov si, offset int7c
        mov di, 200h
        mov cx, offset int7c_end - offset int7c
        cld
        rep movsb
        ;设置中断向量表的表项
        mov word ptr es:[7ch*4], 200h
        mov word ptr es:[7ch*4+2], 0

        mov ax, 4c00h
        int 21h

    int7c:
    ;ah传递功能号，0代表读，1代表写,dx传递逻辑扇区号，es：bx指向存储读出数据或写入数据的内存区

        ;保护寄存器到栈
        push ax
        push cx
        push dx
        ;计算面号
        push ax
        push bx
        mov ax, dx
        mov dx, 0
        mov cx, 1440
        div cx
        mov bh, al ;将用bh暂存面号

        ;计算磁道号
        mov ax, dx ;将余数给ax

        mov bl, 18
        div bl
        mov ch, al ;将磁道号给ch
        mov dh, bh ;将面号给dh
        ;计算扇区号
        mov al, ah
        mov ah, 0
        inc ax
        mov cl, al ;将扇区号给cl
        ;调用int 13h号中断进行读写
        pop bx
        pop ax
        mov dl, 80h
        add ah, 2
        mov al, 1
        int 13h
        ;恢复寄存器
        pop dx
        pop cx
        pop ax

        iret
    int7c_end:
        nop
codeseg ends
end start
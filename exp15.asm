assume cs:codeseg

dataseg segment
    dw 0, 0
dataseg ends

stackseg segment
    db 128 dup(0)
stackseg ends

codeseg segment
    start:
        ;初始化段寄存器
        mov ax, stackseg
        mov ss, ax
        mov sp, 128

        ;安装新的中断处理程序到0:204
        mov ax, 0
        mov es, ax

        mov ax, cs
        mov ds, ax

        mov si, offset int9
        mov di, 204h
        mov cx, offset int9_end - offset int9
        cld
        rep movsb

        ;保存旧的九号中断处理程序入口地址到0:200,0:202
        push es:[9*4]
        pop es:[200h]
        push es:[9*4+2]
        pop es:[202h]
        ;设置中断向量表中的中断例程入口地址
        cli
        mov word ptr es:[9*4], 204h
        mov word ptr es:[9*4+2], 0
        sti

        mov ax, 4c00h
        int 21h

    int9:
        ;保存寄存器到栈中
        push ax
        push bx
        push cx
        push es
        ;从60h号端口中获得扫描码
        in al, 60h
        ;保存标志寄存器，调用旧的中断处理程序
        pushf
        call dword ptr cs:[200h]
        ;根据扫描码进行判断，如果是A的断码则显示满屏幕的A，如果不是则返回
        cmp al, 9Eh
        jne int9_return

        ;显示满屏幕的A
        mov cx, 2000
        mov ax, 0b800h
        mov es, ax
        mov bx, 0
    show_a_A:
        mov byte ptr es:[bx], 'A'
        add bx, 2
        loop show_a_A
    
        ;返回
    int9_return:
        pop es
        pop cx
        pop bx
        pop ax
        iret
    int9_end:
        nop
codeseg ends
end start
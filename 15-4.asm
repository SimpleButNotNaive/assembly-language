assume cs:code

stack segment
    db 128 dup(0)
stack ends

data segment
    dw 0, 0
data ends

code segment
    start:
        mov ax, stack
        mov ss, ax
        mov sp, 128

        mov ax, data
        mov ds, ax

        mov ax, 0
        mov es, ax

        push es:[9*4] ;保存旧的int9中断例程入口地址
        pop ds:[0]
        push es:[9*4+2]
        pop ds:[2]

        cli
        mov word ptr es:[9*4], offset int9 ;设置新的int9中断例程入口地址
        mov es:[9*4+2], cs
        sti

        mov ax, 0b800h
        mov es, ax
        mov ah, 'a'
     
    show_char_cycle:
        mov es:[160*12+40*2], ah
        call delay
        inc ah
        cmp ah, 'z'
        jna show_char_cycle ;循环在屏幕中央显示a-z
    
        mov ax, 0
        mov es, ax

        push ds:[0]
        pop es:[9*4]
        push ds:[2]
        pop es:[9*4+2] ;恢复int9的中断处理例程入口地址

        mov ax, 4c00h
        int 21h

    delay:
        push ax
        push dx
        mov dx, 1000h
        mov ax, 0
    delay_cycle:
        sub ax, 1
        sbb dx, 0
        cmp ax, 0
        jne delay_cycle
        cmp dx, 0
        jne delay_cycle
        pop dx
        pop ax
        ret

    int9:
        push ax
        push bx
        push es

        in al, 60h

        pushf
        call dword ptr ds:[0] ;调用bios设置的int9中断例程

        cmp al, 1
        jne int9_ret

        mov ax, 0b800h
        mov es, ax
        inc byte ptr es:[160*12+40*2+1]

    int9_ret:
        pop es
        pop bx
        pop ax
        iret

code ends
end start
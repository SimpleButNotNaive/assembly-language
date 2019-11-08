assume cs:codeseg, ds:dataseg

dataseg segment
    db "Beginner's All-purpose Symbolic Instruction Code.", 0
dataseg ends

codeseg segment
    start:
        mov ax, dataseg
        mov ds, ax
        call letterc

        mov ax, 4c00h
        int 21h

    letterc:
        push si
        push ax
        mov si, 0
    letterc_loop:
        mov al, [si]      
        cmp al, 0
        jz letterc_finish

        cmp al, 'a'
        jb letterc_one_loop_end
        cmp al, 'z'
        ja letterc_one_loop_end

        and al, 11011111b
        mov [si], al
    
    letterc_one_loop_end:
        inc si
        jmp letterc_loop

    letterc_finish:
        pop ax
        pop si
        ret
codeseg ends
end start
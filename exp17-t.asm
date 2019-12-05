assume cs:codeseg

stackseg segment
    db 128 dup(0)
stackseg ends

dataseg segment
    db 512 dup(0)
dataseg ends

codeseg segment
    start:
        mov ax, stackseg
        mov ss, ax
        mov sp, 128

        mov ax, dataseg
        mov es, ax
        mov bx, 0

        mov dx, 0
        mov ah, 0
        int 7ch

        mov ax, 4c00h
        int 21h
codeseg ends
end start
assume cs:codeseg

stackseg segment stack
    db 128 dup(0)
stackseg ends
codeseg segment
    start:
        mov ah, 3
        int 7ch

        mov ax, 4c00h
        int 21h
codeseg ends
end start
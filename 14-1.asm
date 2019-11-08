assume cs:codeseg

codeseg segment
    mov al, 2
    out 70h, al
    mov al, 0
    out 71h, al

    mov al, 2
    out 70h, al

    in al, 71h
    
    mov ax, 4c00h
    int 21h

codeseg ends
end
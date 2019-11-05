assume cs:codeseg

codeseg segment
    mov dx, 1
    mov ax, 86A1h
    mov bx, 100
    div bx
codeseg ends

end
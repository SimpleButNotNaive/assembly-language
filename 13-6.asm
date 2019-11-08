assume cs:code

code segment

    mov ah, 2
    mov bh, 0
    mov dh, 5
    mov dl, 12
    int 10h

code ends
end
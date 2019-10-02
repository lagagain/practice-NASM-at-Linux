global _start

section .data
        msg db "Hello, World!", 0x0a
        len equ $ - msg

section .text

_start:
        mov eax, 4              ; sys_write system call
        mov ebx, 1              ; stdout file descriptor
        mov ecx, msg            ; byte to write
        mov edx, len            ; number of bytes to write
        int 0x80                ; perform system call

        ;; exit program
        mov eax, 1
        mov ebx, 0
        int 0x80

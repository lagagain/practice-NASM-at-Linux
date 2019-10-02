;;;  about jump
;;; je A,B ; jump if Equal
;;; jne A, B; jump if Not Equal
;;; jg A, B ; jump if Greater
;;; jge A, B; jump if Grater or Equal
;;; jl A, B ; jump if Less
;;; jle A, B ; jump if Less or Equal

        global _start
        section .text
_start:
        mov ecx, 101             ; set exc to 99
        mov ebx, 42             ; exit status is 42
        mov eax, 1              ; sys_exit system call
        cmp ecx, 100            ; compare ecx to 100
        jl skip                 ; jump if less then
        mov ebx, 13             ; exit status is 13
skip:
        int 0x80

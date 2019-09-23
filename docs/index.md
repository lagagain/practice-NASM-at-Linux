

# 說明

這是我的NASM組合語言練習筆記。我是根據[{YouTube}Intro to x86 Assembly Language](https://www.youtube.com/watch?v=wLXIWKUWpSs&list=PLmxT2pVYo5LB5EzTPZGfFN0c2GDiSXgQe)進行學習。筆記下多數程式碼是該影片的範例修改而來。


# 建置(Build)&執行(Exec)

建置以前你需要先將本範例中的程式碼 `tangle` 出去。

    (org-babel-tangle)

-   src/ex4.asm
-   src/ex3.asm
-   src/ex2.asm
-   src/ex1.asm
-   src/hello.asm

接著建置：

    make

所有目的執行程式都會在 `build` 目錄下。你可以參考本筆記內容執行程式，或是在Emacs org-mode下執行本筆記。


## 清除(Clean)

    make clean


# Hello World

程式碼：

    section     .text
    global      _start                              ;must be declared for linker (ld)
    
    _start:                                                 ;tell linker entry point
    
            mov     edx,len                             ;message length
            mov     ecx,        msg                     ;message to write
            mov     ebx,1                               ;file descriptor (stdout)
            mov     eax,4                               ;system call number (sys_write)
            int     0x80                                ;call kernel
    
            mov     eax,1                               ;system call number (sys_exit)
            int     0x80                                ;call kernel
    
    
    section     .data
    
            msg     db  'Hello, world!',0xa                 ;our dear string
            len      equ $ - msg                             ;length of our dear string

編譯：

    nasm -f elf64 hello.asm -o hello.o
    ld -m elf_x86_64 hello.o -o hello

執行：

    ./hello

    Hello, world!


# Example1

            global _start
    
    _start:
            mov eax, 1
            mov ebx, 42
            sub ebx, 29
            int 0x80                ;eax:1 -> terminal print; ebx:status

    nasm -f elf64 ex1.asm -o ex1.o
    ld -m elf_x86_64 ex1.o -o ex1

    ./ex1
    echo $?

    
    13


# Example2

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

    nasm -f elf64 ex2.asm -o ex2.o
    ld -m elf_x86_64 ex2.o -o ex2

    ./ex2

    Hello, World!


# Example3

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

    nasm -f elf64 ex3.asm -o ex3.o
    ld -m elf_x86_64 ex3.o -o ex3

    ./ex3
    echo $?

    
    13


# Example4

            global _start
            section .text
    _start:
            mov ebx, 1              ;start ebx at 1
            mov ecx, 6              ; number of iterations
    label:
            add ebx, ebx            ; ebx += ebx
            dec ecx                 ; ecx -= 1 ; inc => +1
            cmp ecx, 0              ; compare ecx with 0
            jg label                ; jump to label if greater
            mov eax, 1              ; sys_exit system call
            int 0x80

    nasm -f elf64 ex4.asm -o ex4.o
    ld -m elf_x86_64 ex4.o -o ex4

    ./ex4
    echo $?

    
    64


# 授權(LICENSE)

**本筆記除了程式碼部份外，其餘部份採用CC-3.0授權。**

<a rel="license" href="http://creativecommons.org/licenses/by/3.0/tw/"><img alt="創用 CC 授權條款" style="border-width:0" src="https://i.creativecommons.org/l/by/3.0/tw/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">又LAG在Linux上的x86組合語言練習(使用NASM)</span>由<a xmlns:cc="http://creativecommons.org/ns#" href="https://www.lagagain.com" property="cc:attributionName" rel="cc:attributionURL"> lagagain(LAG)</a>製作，以<a rel="license" href="http://creativecommons.org/licenses/by/3.0/tw/">創用CC 姓名標示 3.0 台灣 授權條款</a>釋出。


# 後記

雖然我以前就有NASM的基礎，不過以前看的書的範例平台是使用Windows，也未太過深入了解系統中斷、系統呼叫。這次有比較深入的學習。


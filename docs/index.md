

# 說明

這是我的NASM組合語言練習筆記。我是根據[{YouTube}Intro to x86 Assembly Language](https://www.youtube.com/watch?v=wLXIWKUWpSs&list=PLmxT2pVYo5LB5EzTPZGfFN0c2GDiSXgQe)進行學習。筆記下多數程式碼是該影片的範例修改而來。
原始程式碼倉庫：<https://github.com/code-tutorials/assembly-intro>


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


# Linux 系統呼叫

-   [Linux Syscall Reference](https://syscalls.kernelgrok.com/)
-   [Linux and Unix exit code tutorial with examples](https://shapeshed.com/unix-exit-codes/)
-   [Linux系統呼叫（System call）函式增加篇『總整理』](https://linux.incomeself.com/linux%E7%B3%BB%E7%B5%B1%E5%91%BC%E5%8F%AB%EF%BC%88system-call%EF%BC%89%E5%87%BD%E5%BC%8F%E5%A2%9E%E5%8A%A0%E7%AF%87%E3%80%8E%E7%B8%BD%E6%95%B4%E7%90%86%E3%80%8F/)

系統呼叫表原始碼位置： `/usr/src/linux-headers-4.4.0-98-generic/arch/x86/include/generated/uapi/asm/unistd_64.h`


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


# Example5

    global _start
    
    section .data
        addr db "yellow"
    
    section .text
    _start:
        mov [addr], byte 'H'
        mov [addr+5], byte '!'
        mov eax, 4    ; sys_write system call
        mov ebx, 1    ; stdout file descriptor
        mov ecx, addr ; bytes to write
        mov edx, 6    ; number of bytes to write
        int 0x80      ; perform system call
        mov eax, 1    ; sys_exit system call
        mov ebx, 0    ; exit status is 0
        int 0x80

    nasm -f elf32 ex5.asm -o ex5.o
    ld -m elf_i386 ex5.o -o ex5

    ./ex5

    Hello!


# Example6

    global _start
    
    _start:
        sub esp, 4
        mov [esp], byte 'H'
        mov [esp+1], byte 'e'
        mov [esp+2], byte 'y'
        mov [esp+3], byte '!'
        mov eax, 4    ; sys_write system call
        mov ebx, 1    ; stdout file descriptor
        mov ecx, esp  ; bytes to write
        mov edx, 4    ; number of bytes to write
        int 0x80      ; perform system call
        mov eax, 1    ; sys_exit system call
        mov ebx, 0    ; exit status is 0
        int 0x80

    nasm -f elf32 ex6.asm -o ex6.o
    ld -m elf_i386 ex6.o -o ex6

    ./ex6

    Hey!


# Example7

     1  global _start
     2  
     3  _start:
     4      call func
     5      mov eax, 1                  ;
     6      int 0x80
     7  
     8  func:
     9      mov ebx, 42
    10      pop eax                     ;
    11      jmp eax                     ;

32 bit的暫存器用eax命名，64 bits的叫rax(第5行)。

第10-11行 同樣可以表示為 `ret` ，見下方ex7-2

    nasm -f elf32 ex7-1.asm -o ex7-1.o
    ld -m elf_i386 ex7-1.o -o ex7-1

    ./ex7-1
    echo $?

    42

---

    global _start
    
    _start:
        call func
        mov eax, 1
        int 0x80
    
    func:
        mov ebx, 42
        ret

    nasm -f elf32 ex7-2.asm -o ex7-2.o
    ld -m elf_i386 ex7-2.o -o ex7-2

    1  ./ex7-2
    2  echo $?
    3  

    42


# Example8

    global _start
    
    _start:
        call func
        mov eax, 1
        mov ebx, 0
        int 0x80
    
    func:
        push ebp
        mov ebp, esp
        sub esp, 2
        mov [esp], byte 'H'
        mov [esp+1], byte 'i'
        mov eax, 4    ; sys_write system call
        mov ebx, 1    ; stdout file descriptor
        mov ecx, esp  ; bytes to write
        mov edx, 2    ; number of bytes to write
        int 0x80      ; perform system call
        mov esp, ebp
        pop ebp
        ret

    nasm -f elf32 ex8.asm -o ex8.o
    ld -m elf_i386 ex8.o -o ex8

    ./ex8

    Hi


# Example9

    global _start
    
    _start:
        push 21
        call times2
        mov ebx, eax
        mov eax, 1
        int 0x80
    
    times2:
        push ebp
        mov ebp, esp
        mov eax, [ebp+8]
        add eax, eax
        mov esp, ebp
        pop ebp
        ret

    nasm -f elf32 ex9.asm -o ex9.o
    ld -m elf_i386 ex9.o -o ex9

    ./ex9
    echo $?

    42


# Example10

    global main
    
    extern printf
    
    section .data
        msg db "Testing %i...", 0x0a, 0x00
    
    main:
        push ebp
        mov ebp, esp
        push 123
        push msg
        call printf
        mov eax, 0
        mov esp, ebp
        pop ebp
        ret

    nasm -f elf32 ex10.asm -o ex10.o
    gcc -m32 ex10.o -o ex10

Note: 貌似我沒安裝32位元的gcc，找不到-lgcc

    ./ex10


# Example11

    global add42
    
    add42:
        push ebp
        mov ebp, esp
        mov eax, [ebp+8]
        add eax, 42
        mov esp, ebp
        pop ebp
        ret

    // Function that returns x + 42
    int add42(int x);

    #include <stdio.h>
    #include "add42.h"
    
    int main() {
        int result;
        result = add42(30);
        printf("Result: %i\n", result);
        return 0;
    }

    nasm -f elf32 add42.asm -o add42.o
    gcc -m32 add42.o ex11.c -o ex11

    ./ex11


# 授權(LICENSE)

**本筆記除了程式碼部份外，其餘部份採用CC-3.0授權。**

<a rel="license" href="http://creativecommons.org/licenses/by/3.0/tw/"><img alt="創用 CC 授權條款" style="border-width:0" src="https://i.creativecommons.org/l/by/3.0/tw/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">又LAG在Linux上的x86組合語言練習(使用NASM)</span>由<a xmlns:cc="http://creativecommons.org/ns#" href="https://www.lagagain.com" property="cc:attributionName" rel="cc:attributionURL"> lagagain(LAG)</a>製作，以<a rel="license" href="http://creativecommons.org/licenses/by/3.0/tw/">創用CC 姓名標示 3.0 台灣 授權條款</a>釋出。


# 後記

雖然我以前就有NASM的基礎，不過以前看的書的範例平台是使用Windows，也未太過深入了解系統中斷、系統呼叫。這次有比較深入的學習。


## Other

[他犧牲自己的一生，揭發政府監控人民的真相! | 永久檔案 | 啾讀。第51集 | 啾啾鞋](https://youtu.be/Ac4cCEySLUs?list=WL&t=75)

> 理解一件科技設備，並且當它壞掉的時候以正確的方式檢查，嘗試修復它，是一個人對於科技的最基本的責任，不要隨便敷衍科技。
> 
> 現在的人東西壞掉就換新的，導致沒人在乎一件設備的運作原理，久了以後就造成人們被科技產品反噬。


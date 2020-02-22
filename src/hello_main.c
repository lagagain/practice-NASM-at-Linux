#include<stdio.h>
#include<stdlib.h>
#include "hello_asm.h"
#include "hello_c.h"
//extern void hello_asm(void);
//extern void hello_c();

int main(void){
  printf("Hello, World\n");
  hello_asm();
  printf("\n");
  hello_c();
  return 0;
}

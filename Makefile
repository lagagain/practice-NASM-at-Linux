.PHONY: clean_obj

BUILD_DIR = build
TARGET = ${BUILD_DIR}/hello
TARGET += ${BUILD_DIR}/ex1
TARGET += ${BUILD_DIR}/ex2
TARGET += ${BUILD_DIR}/ex3
TARGET += ${BUILD_DIR}/ex4
TARGET += ${BUILD_DIR}/ex5

all: build_dir ${TARGET}

${BUILD_DIR}/%.o:src/%.asm
	nasm -f elf64 $^ -o $@

${BUILD_DIR}/%: build/%.o
	ld -m elf_x86_64 $^ -o $@

build_dir:
	mkdir -p ${BUILD_DIR}

clean:
	rm build -rf

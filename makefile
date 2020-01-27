ASM = nasm
ASM_OPTIONS = -f elf64
INC = 
GXX = g++

all: runner
	
main.o:
	$(GXX) -c main.cpp -o main.o

shading.o:
	$(ASM) $(ASM_OPTIONS) shading.s

runner: shading.o main.o
	$(GXX) -fPIC main.o shading.o -o runner -no-pie -lallegro -lallegro_image -lallegro_dialog

clean:
	rm *.o
	rm runner

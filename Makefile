CC := g++
LD := g++
AS := nasm

CFLAGS :=  $(shell pkg-config --cflags sdl2)
LDFLAGS :=  $(shell pkg-config --libs sdl2)

objs := main.o code.o

all: program
	./program output512x512.png

program: $(objs)
	$(LD) $(objs) $(LDFLAGS) -o program

main.o: main.cpp
	$(CC) $(CFLAGS) -c main.cpp -o main.o

code.o: code.asm
	$(AS) -f elf64	code.asm -o code.o

clean:
	rm -rf $(objs) program

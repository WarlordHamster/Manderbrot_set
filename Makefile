CC := g++
LD := g++
AS := nasm

CFLAGS :=  $(shell pkg-config --cflags sdl2)
LDFLAGS :=  $(shell pkg-config --libs sdl2)

objs := main.o code.o

all: program
	./program

program: $(objs)
	$(LD) $(objs) $(LDFLAGS) -g -o program

main.o: main.cpp
	$(CC) $(CFLAGS) -g -c main.cpp -o main.o

code.o: code.asm
	$(AS) -g -f elf64	code.asm -o code.o

clean:
	rm -rf $(objs) program

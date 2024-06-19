##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsm.a

SRC = AsmPutchar.asm \
	  AsmPutstr.asm \
	  AsmPutlstr.asm \
	  AsmIsNum.asm \
	  AsmGetnbr.asm \
	  AsmGetstr.asm \
	  AsmPutnbr.asm \
	  AsmPutlnbr.asm \
	  AsmStrlen.asm \
	  AsmStrcpy.asm \
	  AsmStrncpy.asm \
	  AsmStrcmp.asm \
	  AsmStrncmp.asm \
	  AsmStrcasecmp.asm \
	  AsmStrcat.asm \
	  AsmStrncat.asm \
	  AsmStrchr.asm \
	  AsmStrrchr.asm \
	  AsmStrpbrk.asm \
	  AsmStrcspn.asm \
	  AsmStrstr.asm \
	  AsmPrint.asm \
	  AsmStrcut.asm \
	  AsmPower.asm \
	  AsmMemset.asm \
	  AsmMemcpy.asm \
	  AsmMemmove.asm \
	  AsmAlloc.asm \
	  AsmDalloc.asm \
	  AsmCalloc.asm \
	  AsmRealloc.asm \
	  AsmStrdup.asm \
	  AsmGetptr.asm \
	  AsmShowMemory.asm \
	  AsmClearMemory.asm \

OBJ = $(SRC:.asm=.o)

CFLAGS = -I ../include

all: $(NAME)

$(NAME): $(OBJ)
	ar rc $(NAME) $(OBJ)

%.o: %.asm
	nasm -f elf64 $< -o $@ $(CFLAGS)

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all

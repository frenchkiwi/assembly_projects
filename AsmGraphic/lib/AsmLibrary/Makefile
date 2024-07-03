##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsmLibrary.a

SRC = AsmString/AsmPutchar.asm \
	  AsmString/AsmPutstr.asm \
	  AsmString/AsmPutlstr.asm \
	  AsmString/AsmIsNum.asm \
	  AsmString/AsmGetnbr.asm \
	  AsmString/AsmGetstr.asm \
	  AsmString/AsmPutnbr.asm \
	  AsmString/AsmPutlnbr.asm \
	  AsmString/AsmStrlen.asm \
	  AsmString/AsmStrcpy.asm \
	  AsmString/AsmStrncpy.asm \
	  AsmString/AsmStrcmp.asm \
	  AsmString/AsmStrncmp.asm \
	  AsmString/AsmStrcasecmp.asm \
	  AsmString/AsmStrcat.asm \
	  AsmString/AsmStrncat.asm \
	  AsmString/AsmStrchr.asm \
	  AsmString/AsmStrrchr.asm \
	  AsmString/AsmStrpbrk.asm \
	  AsmString/AsmStrcspn.asm \
	  AsmString/AsmStrstr.asm \
	  AsmString/AsmPrint.asm \
	  AsmString/AsmStrcut.asm \
	  AsmMath/AsmPower.asm \
	  AsmMemory/AsmMemset.asm \
	  AsmMemory/AsmMemcpy.asm \
	  AsmMemory/AsmMemmove.asm \
	  AsmMemory/AsmCoreMemory.asm \
	  AsmMemory/AsmAlloc.asm \
	  AsmMemory/AsmDalloc.asm \
	  AsmMemory/AsmCalloc.asm \
	  AsmMemory/AsmRealloc.asm \
	  AsmMemory/AsmStrdup.asm \
	  AsmMemory/AsmGetptr.asm \
	  AsmMemory/AsmShowMemory.asm \
	  AsmMemory/AsmClearMemory.asm \
	  AsmFutex/AsmLock.asm \
	  AsmFutex/AsmUnlock.asm \

OBJ = $(SRC:.asm=.o)

CFLAGS = -I ../../include

all: $(NAME)

$(NAME): $(OBJ)
	@ar rc $(NAME) $(OBJ)
	@mv $(NAME) ..

%.o: %.asm
	@nasm -f elf64 $< -o $@ $(CFLAGS)

clean:
	@rm -rf $(OBJ)

fclean: clean
	@rm -rf ../$(NAME)

re: fclean all

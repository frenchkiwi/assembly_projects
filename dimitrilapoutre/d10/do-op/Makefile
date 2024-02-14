##
## EPITECH PROJECT, 2023
## dimitrilapoutre
## File description:
## Makefile
##

NAME = do-op

SRC = do-op.asm

OBJ = ${SRC:.asm=.o}

LIB = ../../lib.asm

OBJ_LIB = ${LIB:.asm=.o}

all: ${NAME}

${NAME}:
	nasm -f elf64 -I ../../include/ -o ${OBJ} ${SRC}
	nasm -f elf64 -o ${OBJ_LIB} ${LIB}
	ld ${OBJ} ${OBJ_LIB} -o ${NAME}

clean:
	rm -rf ${OBJ}
	rm -rf ${OBJ_LIB}

fclean: clean
	rm -rf ${NAME}

re: fclean all

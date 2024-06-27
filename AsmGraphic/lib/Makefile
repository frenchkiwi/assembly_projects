##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsmGlobal.a

SRC = libAsmLibrary.a \
	  libAsmGraphic.a \

CFLAGS = -I ../include

all: $(NAME)

$(NAME):
	@make -s -C ./AsmLibrary/
	@make -s -C ./AsmGraphic/

	@rm -rf ./AsmGlobal/*.o
	@mkdir -p ./AsmGlobal/
	@$(foreach FILE, $(SRC), ar -x $(FILE); mv *o ./AsmGlobal/;)
	@ld -r -o ./AsmGlobal/AsmGlobal.o ./AsmGlobal/*.o
	@ar rcs $(NAME) ./AsmGlobal/AsmGlobal.o

clean:
	@make -s -C ./AsmLibrary/ fclean
	@make -s -C ./AsmGraphic/ fclean

	@rm -rf ./AsmGlobal/

fclean: clean
	@rm -rf $(NAME)

re: fclean all
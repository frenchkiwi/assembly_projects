##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsmGraphic.a

SRC = AsmLink/AsmCreateLink.asm \
	  AsmLink/AsmThreadEvent.asm \
	  AsmLink/AsmWaitReply.asm \
	  AsmLink/AsmCloseLink.asm \
	  AsmWindow/AsmCreateWindow.asm \
	  AsmWindow/AsmOpenWindow.asm \
	  AsmWindow/AsmClearWindow.asm \
	  AsmWindow/AsmDisplayWindow.asm \
	  AsmWindow/AsmRenameWindow.asm \
	  AsmWindow/AsmCloseWindow.asm \
	  AsmWindow/AsmDestroyWindow.asm \
	  AsmText/AsmCreateFont.asm \
	  AsmText/AsmDestroyFont.asm \
	  AsmText/AsmCreateText.asm \
	  AsmText/AsmDrawText.asm \
	  AsmText/AsmDestroyText.asm \
	  AsmRectangle/AsmCreateRectangle.asm \
	  AsmRectangle/AsmDrawRectangle.asm \
	  AsmRectangle/AsmDestroyRectangle.asm \
	  AsmTimer/AsmInitTimer.asm \
	  AsmTimer/AsmTickTimer.asm \

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

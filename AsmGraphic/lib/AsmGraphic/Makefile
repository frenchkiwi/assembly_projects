##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsmGraphic.a

SRC = AsmLink/AsmCreateLink.asm \
	  AsmLink/AsmThreadEvent.asm \
	  AsmLink/AsmWaitEvent.asm \
	  AsmLink/AsmPollEvent.asm \
	  AsmLink/AsmCloseLink.asm \
	  AsmWindow/AsmCreateWindow.asm \
	  AsmWindow/AsmOpenWindow.asm \
	  AsmWindow/AsmIsOpenWindow.asm \
	  AsmWindow/AsmHasMovedWindow.asm \
	  AsmWindow/AsmHasResizedWindow.asm \
	  AsmWindow/AsmGetPositionWindow.asm \
	  AsmWindow/AsmGetSizeWindow.asm \
	  AsmWindow/AsmSetPositionWindow.asm \
	  AsmWindow/AsmSetSizeWindow.asm \
	  AsmWindow/AsmClearWindow.asm \
	  AsmWindow/AsmDisplayWindow.asm \
	  AsmWindow/AsmRenameWindow.asm \
	  AsmWindow/AsmCloseWindow.asm \
	  AsmWindow/AsmDestroyWindow.asm \
	  AsmText/AsmCreateFont.asm \
	  AsmText/AsmDestroyFont.asm \
	  AsmText/AsmCreateText.asm \
	  AsmText/AsmGetColorText.asm \
	  AsmText/AsmGetPositionText.asm \
	  AsmText/AsmSetColorText.asm \
	  AsmText/AsmSetPositionText.asm \
	  AsmText/AsmDrawText.asm \
	  AsmText/AsmDestroyText.asm \
	  AsmRectangle/AsmCreateRectangle.asm \
	  AsmRectangle/AsmGetColorRectangle.asm \
	  AsmRectangle/AsmGetDimensionRectangle.asm \
	  AsmRectangle/AsmSetColorRectangle.asm \
	  AsmRectangle/AsmSetDimensionRectangle.asm \
	  AsmRectangle/AsmDrawRectangle.asm \
	  AsmRectangle/AsmDestroyRectangle.asm \
	  AsmCircle/AsmCreateCircle.asm \
	  AsmCircle/AsmGetAngleCircle.asm \
	  AsmCircle/AsmGetColorCircle.asm \
	  AsmCircle/AsmGetDimensionCircle.asm \
	  AsmCircle/AsmSetAngleCircle.asm \
	  AsmCircle/AsmSetColorCircle.asm \
	  AsmCircle/AsmSetDimensionCircle.asm \
	  AsmCircle/AsmDrawCircle.asm \
	  AsmCircle/AsmDestroyCircle.asm \
	  AsmTimer/AsmInitTimer.asm \
	  AsmTimer/AsmTickTimer.asm \
	  AsmTimer/AsmDestroyTimer.asm \
	  AsmBell.asm \

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

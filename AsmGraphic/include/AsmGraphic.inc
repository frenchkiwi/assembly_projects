%ifndef AsmGraphic_
    %define AsmGraphic_

    %define LINK_SOCKET r12 + 0
    %define LINK_ID_GENERATOR r12 + 8
    %define LINK_FUTEX r12 + 12
    %define LINK_THREAD_VAR r12 + 13
    %define LINK_THREAD_ID r12 + 14
    %define LINK_THREAD_STACK r12 + 18
    %define LINK_EVENT_QUEUE r12 + 26
    %define LINK_HEADER r12 + 34
    %define LINK_BODY r12 + 42
    %define LINK_ID r12 + 46
    %define LINK_VENDOR_LENGTH r12 + 58
    %define LINK_FORMAT_LENGTH r12 + 63
    %define LINK_VENDOR r12 + 74
    %define EVENT_NEXT 0
    %define EVENT_TYPE 8

    %define WINDOW_ID r12 + 0
    %define WINDOW_PIXMAP r12 + 4
    %define WINDOW_LINK r12 + 8
    %define WINDOW_POSSIZE r12 + 16
    %define WINDOW_POS r12 + 16
    %define WINDOW_X r12 + 16
    %define WINDOW_Y r12 + 18
    %define WINDOW_SIZE r12 + 20
    %define WINDOW_WIDTH r12 + 20
    %define WINDOW_HEIGHT r12 + 22
    %define WINDOW_DEPTH r12 + 24
    %define WINDOW_EVENT r12 + 25
    %define WINDOW_GC r12 + 26
    %define WINDOW_COLOR r12 + 30

    %define TEXT_STRING r12 + 0
    %define TEXT_LINK r12 + 8
    %define TEXT_GC r12 + 16
    %define TEXT_POS r12 + 20
    %define TEXT_X r12 + 20
    %define TEXT_Y r12 + 22
    %define TEXT_FORE r12 + 24

    %define RECTANGLE_POSSIZE r12 + 0
    %define RECTANGLE_POS r12 + 0
    %define RECTANGLE_X r12 + 0
    %define RECTANGLE_Y r12 + 2
    %define RECTANGLE_SIZE r12 + 4
    %define RECTANGLE_WIDTH r12 + 4
    %define RECTANGLE_HEIGHT r12 + 6
    %define RECTANGLE_LINK r12 + 8
    %define RECTANGLE_GC r12 + 16
    %define RECTANGLE_COLOR r12 + 20
    %define RECTANGLE_BLUE r12 + 20
    %define RECTANGLE_GREEN r12 + 21
    %define RECTANGLE_RED r12 + 22
    %define RECTANGLE_UNUSED r12 + 23

    %define CIRCLE_POSSIZE r12 + 0
    %define CIRCLE_POS r12 + 0
    %define CIRCLE_X r12 + 0
    %define CIRCLE_Y r12 + 2
    %define CIRCLE_SIZE r12 + 4
    %define CIRCLE_WIDTH r12 + 4
    %define CIRCLE_HEIGHT r12 + 6
    %define CIRCLE_LINK r12 + 8
    %define CIRCLE_GC r12 + 16
    %define CIRCLE_COLOR r12 + 20
    %define CIRCLE_BLUE r12 + 20
    %define CIRCLE_GREEN r12 + 21
    %define CIRCLE_RED r12 + 22
    %define CIRCLE_UNUSED r12 + 23
    %define CIRCLE_ANGLE r12 + 24
    %define CIRCLE_BASE_ANGLE r12 + 24
    %define CIRCLE_REAL_ANGLE r12 + 26

    extern AsmCreateLink
    extern AsmThreadEvent
    extern AsmWaitEvent
    extern AsmPollEvent
    extern AsmCloseLink

    extern AsmCreateWindow
    extern AsmOpenWindow
    extern AsmIsOpenWindow
    extern AsmHasMovedWindow
    extern AsmHasResizeddWindow
    extern AsmGetPositionWindow
    extern AsmGetSizeWindow
    extern AsmSetPositionWindow
    extern AsmSetSizeWindow
    extern AsmRenameWindow
    extern AsmDisplayWindow
    extern AsmCloseWindow
    extern AsmDestroyWindow

    extern AsmCreateFont
    extern AsmDestroyFont
    extern AsmCreateText
    extern AsmGetColorText
    extern AsmGetPositionText
    extern AsmSetColorText
    extern AsmSetPositionText
    extern AsmDrawText
    extern AsmDestroyText

    extern AsmCreateRectangle
    extern AsmGetColorRectangle
    extern AsmGetDimensionRectangle
    extern AsmSetColorRectangle
    extern AsmSetDimensionRectangle
    extern AsmDrawRectangle
    extern AsmDestroyRectangle

    extern AsmCreateCircle
    extern AsmGetAngleCircle
    extern AsmGetColorCircle
    extern AsmGetDimensionCircle
    extern AsmSetAngleCircle
    extern AsmSetColorCircle
    extern AsmSetDimensionCircle
    extern AsmDrawCircle
    extern AsmDestroyCircle

    extern AsmInitTimer
    extern AsmTickTimer
    extern AsmDestroyTimer

    extern AsmBell

%endif
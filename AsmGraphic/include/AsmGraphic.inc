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
    %define WINDOW_X r12 + 16
    %define WINDOW_Y r12 + 18
    %define WINDOW_HEIGHT r12 + 20
    %define WINDOW_WIDTH r12 + 22
    %define WINDOW_DEPTH r12 + 24
    %define WINDOW_EVENT r12 + 25

    extern AsmCreateLink
    extern AsmThreadEvent
    extern AsmWaitEvent
    extern AsmCloseLink

    extern AsmCreateWindow
    extern AsmOpenWindow
    extern AsmRenameWindow
    extern AsmCloseWindow
    extern AsmDestroyWindow

%endif
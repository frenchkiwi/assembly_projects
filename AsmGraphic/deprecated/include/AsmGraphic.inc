%ifndef ASMGRAPHIC_MACRO
    %define ASMGRAPHIC_MACRO
    %define LINK_SOCKET 0
    %define LINK_EVENT_QUEUE 4
    %define LINK_HEADER 12
    %define LINK_BODY 20
    %define LINK_ID 24
    %define LINK_VENDOR_LENGTH 36
    %define LINK_FORMAT_LENGTH 41
    %define EVENT_NEXT 0
    %define EVENT_TYPE 8
%endif

section .text
    extern aCreateLink
    extern aCloseLink
    extern aCreateContext
    extern aCreateWindow
    extern aMapWindow
    extern aRenameWindow
    extern aCloseWindow
    extern aDestroyWindow
    extern aOpenFont
    extern aPollEvent
    extern aWindowUpdate
    extern aIsWindowOpen
    extern aIsWindowClosing
    extern aIsWindowMoving
    extern aIsWindowResizing
    extern aClearWindow
    extern aDisplayWindow
    extern aGetWindowPosition
    extern aGetWindowSize
    extern aCreateText
    extern aDrawText
    extern aDestroyText
    extern aCreateRectangle
    extern aDrawRectangle
    extern aDestroyRectangle
    extern aBell
    extern aRunTask

%include "AsmFunctions.inc"
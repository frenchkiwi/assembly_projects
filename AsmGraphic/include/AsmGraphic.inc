%ifndef AsmGraphic_
    %define AsmGraphic_

    %define LINK_SOCKET 0
    %define LINK_EVENT_QUEUE 4
    %define LINK_HEADER 12
    %define LINK_BODY 20
    %define LINK_ID 24
    %define LINK_VENDOR_LENGTH 36
    %define LINK_FORMAT_LENGTH 41
    %define EVENT_NEXT 0
    %define EVENT_TYPE 8

    extern AsmCreateLink
    extern AsmCloseLink

%endif
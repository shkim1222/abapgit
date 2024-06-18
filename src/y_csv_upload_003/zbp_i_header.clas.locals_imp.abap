CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*   METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.

    METHODS Upload FOR MODIFY
      IMPORTING keys FOR ACTION Attachments~Upload.

    TYPES :
    BEGIN OF ty_excel,
        Line        TYPE string,
        Material    TYPE string,
        Qty         TYPE string,
        Unit        TYPE string,
    END OF ty_excel.
ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

  METHOD Upload.
    "CBO 데이터 조회
    READ ENTITIES OF zi_header IN LOCAL MODE
        ENTITY Attachments
        ALL FIELDS
            "keys 값 설정
            WITH CORRESPONDING #( keys )
        RESULT    DATA(lt_result)
        FAILED    DATA(lt_failed)
        REPORTED  DATA(lt_reported).

    "데이터 문자열로 변환
    DATA: lv_content TYPE zattachment,
          order_uuid TYPE string,
          lv_string  TYPE string.

    lv_content = lt_result[ 1 ]-Attachment.
    order_uuid = lt_result[ 1 ]-OrderUuid.

    lv_string = cl_abap_conv_codepage=>create_in( )->convert( lv_content ).

    REPLACE ALL OCCURRENCES OF REGEX '\r\n' IN lv_string WITH ';'.

    DATA : lt_item      TYPE STANDARD TABLE OF zitem,
           ls_item      TYPE                   zitem,
           lt_header    TYPE STANDARD TABLE OF zheader,
           ls_header    TYPE                   zheader,
           ls_itab      TYPE string,
           lt_itab      TYPE TABLE OF string.

    "테이블로 담기
    SPLIT lv_string AT ';' INTO TABLE lt_itab.

    LOOP AT lt_itab INTO ls_itab.
        "Header 라인은 넘어감.
        IF sy-tabix = 1.
            continue.
        ENDIF.

        CLEAR : ls_item.

        SPLIT ls_itab AT ',' INTO ls_header-salesordertype ls_header-salesorganization ls_header-distributionchannel ls_header-soldtoparty ls_item-salesorderitem ls_item-material ls_item-requestedquantity ls_item-requestedquantityunit.
        ls_item-item_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        ls_item-order_uuid = order_uuid.
        APPEND ls_item TO lt_item.
    ENDLOOP.

    ls_header-so_uuid = order_uuid.
    APPEND ls_header TO lt_header.

    UPDATE zheader FROM TABLE @lt_header.
    INSERT zitem FROM TABLE @lt_item.
  ENDMETHOD.
ENDCLASS.

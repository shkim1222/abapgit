CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

   METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Attachment RESULT result.

    METHODS Upload FOR MODIFY
      IMPORTING keys FOR ACTION Attachment~Upload.
ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.

  METHOD get_instance_authorizations.
      "이미 Header 정보 생성 되어 있으면 파일업로드 기능 비활성화
      READ ENTITIES OF ZI_Att_004 IN LOCAL MODE
        ENTITY Attachment
        FIELDS ( status ) WITH CORRESPONDING #( keys )
        RESULT DATA(attachments)
        FAILED failed.

    "souuid가 있는 경우 action 버튼 비활성화 처리
    result =
        VALUE #(
            FOR attachment IN attachments
            LET statusval = COND #(   WHEN attachment-status = '1'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
                                      IN ( %tky = attachment-%tky
                                      %action-Upload = statusval
                                  )
               ).
  ENDMETHOD.

  METHOD Upload.
    "CBO 데이터 조회
    READ ENTITIES OF ZI_Att_004 IN LOCAL MODE
        ENTITY Attachment
        ALL FIELDS
            "keys 값 설정
            WITH CORRESPONDING #( keys )
        RESULT    DATA(lt_result)
        FAILED    DATA(lt_failed)
        REPORTED  DATA(lt_reported).

    DATA :
      datas TYPE TABLE FOR UPDATE     ZI_Att_004,
      data  TYPE STRUCTURE FOR UPDATE ZI_Att_004.

    LOOP AT lt_result INTO DATA(ls_result).
        data = CORRESPONDING #( ls_result ).

        "상태 변경
        data-Status = '1'.
        APPEND data TO datas.
    ENDLOOP.

    "데이터 문자열로 변환
    DATA: lv_content TYPE zattachment,
          attach_id  TYPE string,
          lv_string  TYPE string.

    lv_content = lt_result[ 1 ]-Attachment.
    attach_id = lt_result[ 1 ]-AttachId.

    lv_string = cl_abap_conv_codepage=>create_in( )->convert( lv_content ).

    REPLACE ALL OCCURRENCES OF REGEX '\r\n' IN lv_string WITH ';'.

    DATA : lt_item      TYPE STANDARD TABLE OF zitem_004,
           ls_item      TYPE                   zitem_004,
           lt_header    TYPE STANDARD TABLE OF zheader_004,
           ls_header    TYPE                   zheader_004,
           ls_itab      TYPE string,
           lt_itab      TYPE TABLE OF string,
           lt_excel     TYPE TABLE OF string,
           ls_excel     TYPE string,
           order_div, order_div_bf, order_uuid TYPE string.

    "테이블로 담기
    SPLIT lv_string AT ';' INTO TABLE lt_itab.

    "excel table Loop
    LOOP AT lt_itab INTO ls_itab.

        "Header 라인은 넘어감.
        IF sy-tabix = 1.
            continue.
        ENDIF.

        SPLIT ls_itab AT ',' INTO TABLE lt_excel.

        "row Loop
        "1,OR,4310,10,1000001,10,qm001,1,ea
        LOOP AT lt_excel INTO ls_excel.

            IF sy-tabix = 1. order_div = ls_excel. ENDIF.

            "현재 row 오더 구분자와 이전 row 오더 구분자가 같으면 = 동일한 오더
            IF order_div = order_div_bf.
                IF sy-tabix = 6. ls_item-salesorderitem         = ls_excel. ENDIF.
                IF sy-tabix = 7. ls_item-material               = ls_excel. ENDIF.
                IF sy-tabix = 8. ls_item-requestedquantity      = ls_excel. ENDIF.
                IF sy-tabix = 9. ls_item-requestedquantityunit  = ls_excel. ENDIF.

            "현재 row 오더 구분자와 이전 row 오더 구분자가 다르면 = 새로운 오더
            ELSE.
                IF sy-tabix = 2. ls_header-salesordertype       = ls_excel. ENDIF.
                IF sy-tabix = 3. ls_header-salesorganization    = ls_excel. ENDIF.
                IF sy-tabix = 4. ls_header-distributionchannel  = ls_excel. ENDIF.
                IF sy-tabix = 5. ls_header-soldtoparty          = ls_excel. ENDIF.
                IF sy-tabix = 6. ls_item-salesorderitem         = ls_excel. ENDIF.
                IF sy-tabix = 7. ls_item-material               = ls_excel. ENDIF.
                IF sy-tabix = 8. ls_item-requestedquantity      = ls_excel. ENDIF.
                IF sy-tabix = 9. ls_item-requestedquantityunit  = ls_excel. ENDIF.
            ENDIF.
        ENDLOOP.

        ls_item-attach_id   = attach_id.
        ls_header-attach_id = attach_id.

        "Item만 추가
        IF order_div = order_div_bf.
            ls_item-item_uuid  = cl_system_uuid=>create_uuid_x16_static( ).
            ls_item-order_uuid = order_uuid.
        "오더 새로 생성
        ELSE.
            ls_item-item_uuid = cl_system_uuid=>create_uuid_x16_static( ).
            ls_item-order_uuid = cl_system_uuid=>create_uuid_x16_static( ).
            ls_header-so_uuid = ls_item-order_uuid.
        ENDIF.

        IF ls_header-salesordertype <> ''.
            APPEND ls_header TO lt_header.
        ENDIF.

        APPEND ls_item TO lt_item.

        order_div_bf = order_div.
        order_uuid   = ls_header-so_uuid.
        CLEAR : ls_item, ls_header.

    ENDLOOP.

    INSERT zheader_004 FROM TABLE @lt_header.
    INSERT zitem_004   FROM TABLE @lt_item.

    "CBO 데이터 업데이트
    MODIFY ENTITIES OF ZI_Att_004 IN LOCAL MODE
    ENTITY Attachment UPDATE SET FIELDS WITH datas
    MAPPED   DATA(lt_mapped_modify)
    FAILED   DATA(lt_failed_modify)
    REPORTED DATA(lt_reported_modify).
  ENDMETHOD.
ENDCLASS.

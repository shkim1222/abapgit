CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR Student RESULT result.

    METHODS Upload FOR MODIFY
      IMPORTING keys FOR ACTION Attachments~Upload.

    TYPES : BEGIN OF ty_excel,
      ID    TYPE string,
      NAME  TYPE string.
    TYPES : END OF ty_excel.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

*  METHOD get_global_authorizations.
*  ENDMETHOD.

    METHOD Upload.
       "CBO 데이터 조회
        READ ENTITIES OF zstudent_hdr_tab_I IN LOCAL MODE
           ENTITY Attachments
            ALL FIELDS
              "keys 값 설정
              WITH CORRESPONDING #( keys )
              RESULT DATA(lt_result)
          FAILED    DATA(lt_failed)
          REPORTED  DATA(lt_reported).

        "데이터 문자열로 변환
        DATA: lv_content TYPE zattachment1,
              lv_string  TYPE string.

        lv_content = lt_result[ 1 ]-Attachment.

        lv_string = cl_abap_conv_codepage=>create_in( )->convert( lv_content ).

        REPLACE ALL OCCURRENCES OF REGEX '\r\n' IN lv_string WITH ';'.

        DATA : lt_item TYPE STANDARD TABLE OF zitem_tab,
               ls_item TYPE                   zitem_tab,
               lt_itab TYPE TABLE OF zitem_tab.

        "테이블로 담기
        SPLIT lv_string AT ';' INTO TABLE lt_itab.

        LOOP AT lt_itab INTO DATA(ls_itab).
            ls_item = CORRESPONDING #( ls_itab ).

            "Header 라인은 넘어감.
            IF sy-tabix = 1.
                continue.
            ENDIF.

            SPLIT ls_itab AT ',' INTO ls_item-id ls_item-name.
            APPEND ls_item TO lt_item.

        ENDLOOP.

        INSERT zitem_tab FROM TABLE @lt_item.

    ENDMETHOD.
ENDCLASS.

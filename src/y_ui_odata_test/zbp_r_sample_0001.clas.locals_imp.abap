CLASS lhc_zr_sample_0001 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_sample_0001 RESULT result.

    METHODS action1 FOR MODIFY
      IMPORTING keys FOR ACTION zr_sample_0001~action1.

    METHODS action2 FOR MODIFY
      IMPORTING keys FOR ACTION zr_sample_0001~action2 RESULT result.

    METHODS action3 FOR MODIFY
      IMPORTING keys FOR ACTION zr_sample_0001~action3 RESULT result.

    METHODS onVali FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_sample_0001~onVali.

    TYPES:
        "스탠다드 API Response Information
        BEGIN OF post_result,
            post_body      TYPE string,
            post_status    TYPE string,
        END OF post_result,

        BEGIN OF ty_result,
            PurchaseOrder TYPE string,
            uuid TYPE sysuuid_x16,
        END OF ty_result,

        "cbo에 넣을 구조체 생성
        BEGIN OF ty_data,
            BEGIN OF d,
*                results TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY,
                results TYPE STANDARD TABLE OF zpogettheader001 WITH EMPTY KEY,
            END OF d,
        END OF ty_data.

    "API 통신을 위해 생성한 함수
    METHODS:
        GET_CONNECTION
            IMPORTING url           TYPE string
            RETURNING VALUE(result) TYPE REF TO if_web_http_client
            RAISING   cx_static_check,

        GET_PO
            "IMPORTING params          TYPE sysuuid_x16
            RETURNING VALUE(result)   TYPE post_result
            RAISING   cx_static_check.

    "상수
    CONSTANTS:
        content_type TYPE string VALUE 'Content-type',
        json_content TYPE string VALUE 'application/json; charset=UTF-8'.

ENDCLASS.

CLASS lhc_zr_sample_0001 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD action1.
  ENDMETHOD.

  METHOD action2.

    DATA :  lt_data TYPE ty_data,
*            ls_final TYPE ty_result,
*            lt_final TYPE TABLE OF ty_result,

            ls_final TYPE zpogettheader001 ,
            lt_final TYPE TABLE OF zpogettheader001.

    FIELD-SYMBOLS:  <l_postab_ref> TYPE any,
                    <lt_postab> TYPE ANY TABLE,
                    <field> TYPE any.

    DATA(A) = 1.
    DATA(po_result) = GET_PO( ).


    DATA : lt_update_0001 TYPE TABLE FOR UPDATE ZR_SAMPLE_0001,
           ls_update_0001 TYPE STRUCTURE FOR UPDATE ZR_SAMPLE_0001.

    TRY.
        "성공하면 cbo에 저장
        CALL METHOD /ui2/cl_json=>deserialize
        EXPORTING
        json = po_result-post_body
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
        CHANGING
        data = lt_data.

        "parsing 한 데이터 LOOP 돌리기 위해 필요한 데이터 파싱
        ASSIGN COMPONENT 'd' OF STRUCTURE lt_data TO <l_postab_ref>.
        ASSIGN COMPONENT 'results' OF STRUCTURE <l_postab_ref> TO <lt_postab>.

        "Loop돌면서 필드 값 읽어서 table에 넣음.
        LOOP AT <lt_postab> ASSIGNING FIELD-SYMBOL(<l_posref>).
            ASSIGN COMPONENT `PurchaseOrder` OF STRUCTURE <l_posref> TO <field>.
            IF <field> IS ASSIGNED.
            ls_final-purchaseorder = <field>.
            ls_update_0001-OrderId = <field>.
            ENDIF.
            UNASSIGN: <field>.

            DATA: system_uuid TYPE REF TO if_system_uuid,
                  uuid TYPE sysuuid_x16.

            system_uuid = cl_uuid_factory=>create_system_uuid( ).

            TRY.
                uuid = system_uuid->create_uuid_x16( ).
                ls_final-uuid = uuid.
              CATCH cx_uuid_error.
            ENDTRY.

            APPEND ls_final TO lt_final.
            APPEND ls_update_0001 TO lt_update_0001.
            CLEAR : ls_final, ls_update_0001.
        ENDLOOP.

        CATCH cx_http_dest_provider_error.
        "handle exception here

        CATCH cx_web_http_client_error.
        "handle exception here
    ENDTRY.

    " CBO 데이터 업데이트
*    MODIFY ENTITIES OF zr_sample_0001 IN LOCAL MODE
*           ENTITY zr_sample_0001 UPDATE fields ( OrderId ) with lt_update_0001
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           MAPPED   DATA(ls_mapped_modify)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED   DATA(lt_failed_modify)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           REPORTED DATA(lt_reported_modify).

    MODIFY ENTITIES OF zr_sample_0001 IN LOCAL MODE
           ENTITY zr_sample_0001 CREATE SET FIELDS WITH VALUE #( ( %cid = '0001' OrderId = lt_final[ 1 ]-purchaseorder Uuid = lt_final[ 1 ]-uuid ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED   DATA(ls_mapped_modify)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(lt_failed_modify)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(lt_reported_modify).

  ENDMETHOD.

  "HTTP 통신을 위한 셋팅
  METHOD GET_CONNECTION.
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD.

   "POST
  METHOD GET_PO.

    "시나리오 이름으로 통신이 존재하는지 확인
    DATA: lr_cscn type if_com_scenario_factory=>ty_query-cscn_id_range.
    lr_cscn = value #( ( sign = 'I' option = 'EQ' low = 'ZCS_UI_SAMPLE_0001' ) ).

    DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).
    lo_factory->query_ca(
          EXPORTING
            is_query           = value #( cscn_id_range = lr_cscn )
          IMPORTING
            et_com_arrangement = data(lt_ca)
        ).

    "해당 시나리오가 존재 하지 않으면 종료
    IF lt_ca is initial.
      EXIT.
    ENDIF.

    "조회 한 값 중 1번째 값
    DATA(lo_ca) = lt_ca[ 1 ].

    "GET
    TRY.
        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = 'ZCS_UI_SAMPLE_0001'
            service_id     = 'ZAPI_PO_SAMPLE_0001_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_uri_path( EXPORTING i_uri_path = '?$top=1&$format=json' ).
*        lo_request->set_header_field( i_name = 'x-csrf-token' i_value = 'fetch' ).
        DATA(lo_response) = lo_http_client->execute( if_web_http_client=>get ).

        DATA(body)   = lo_response->get_text( ).
        DATA(status) = lo_response->get_status( )-code.
        "get 해서, token이랑 cookie값 가져오기
*        DATA(token)   = lo_response->get_header_field( i_name = 'x-csrf-token' ).
*        DATA(cookies) = lo_response->get_cookies( ).

      CATCH cx_http_dest_provider_error.
        " handle exception here

      CATCH cx_web_http_client_error.
        " handle exception here
    ENDTRY.

    result-post_body    = body.
    result-post_status  = status.

  ENDMETHOD.

  METHOD action3.

    DATA(a) = keys.
    DATA(b) = sy-uname.

    DATA :  lt_data TYPE ty_data,
            ls_final TYPE ty_result,
            lt_final TYPE TABLE OF ty_result.

    FIELD-SYMBOLS:  <l_postab_ref> TYPE any,
                    <lt_postab> TYPE ANY TABLE,
                    <field> TYPE any.

    DATA(po_result) = GET_PO( ).

    DATA : lt_update_0001 TYPE TABLE FOR UPDATE ZR_SAMPLE_0001,
           ls_update_0001 TYPE STRUCTURE FOR UPDATE ZR_SAMPLE_0001.

    TRY.
        "성공하면 cbo에 저장
        CALL METHOD /ui2/cl_json=>deserialize
        EXPORTING
        json = po_result-post_body
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
        CHANGING
        data = lt_data.

        "parsing 한 데이터 LOOP 돌리기 위해 필요한 데이터 파싱
        ASSIGN COMPONENT 'd' OF STRUCTURE lt_data TO <l_postab_ref>.
        ASSIGN COMPONENT 'results' OF STRUCTURE <l_postab_ref> TO <lt_postab>.

        "Loop돌면서 필드 값 읽어서 table에 넣음.
        LOOP AT <lt_postab> ASSIGNING FIELD-SYMBOL(<l_posref>).
*            ASSIGN COMPONENT `PurchaseOrder` OF STRUCTURE <l_posref> TO <field>.
*            IF <field> IS ASSIGNED.
*            ls_final-purchaseorder = <field>.
*            ls_update_0001-OrderId = <field>.
*            ENDIF.
*            UNASSIGN: <field>.
            ls_final = CORRESPONDING #( <l_posref> ).
            DATA: system_uuid TYPE REF TO if_system_uuid,
                  uuid TYPE sysuuid_x16.

            system_uuid = cl_uuid_factory=>create_system_uuid( ).

            TRY.
                uuid = system_uuid->create_uuid_x16( ).
                ls_final-uuid = uuid.
              CATCH cx_uuid_error.
            ENDTRY.

            APPEND ls_final TO lt_final.
            APPEND ls_update_0001 TO lt_update_0001.
            CLEAR : ls_final, ls_update_0001.
        ENDLOOP.

        "Loop돌면서 필드 값 읽어서 table에 넣음.
*        LOOP AT <lt_postab> ASSIGNING FIELD-SYMBOL(<l_posref>).
*            ASSIGN COMPONENT `PurchaseOrder` OF STRUCTURE <l_posref> TO <field>.
*            IF <field> IS ASSIGNED.
*            ls_final-purchaseorder = <field>.
*            ls_update_0001-OrderId = <field>.
*            ENDIF.
*            UNASSIGN: <field>.
*
*            DATA: system_uuid TYPE REF TO if_system_uuid,
*                  uuid TYPE sysuuid_x16.
*
*            system_uuid = cl_uuid_factory=>create_system_uuid( ).
*
*            TRY.
*                uuid = system_uuid->create_uuid_x16( ).
*                ls_final-uuid = uuid.
*              CATCH cx_uuid_error.
*            ENDTRY.
*
*            APPEND ls_final TO lt_final.
*            APPEND ls_update_0001 TO lt_update_0001.
*            CLEAR : ls_final, ls_update_0001.
*        ENDLOOP.

        CATCH cx_http_dest_provider_error.
        "handle exception here

        CATCH cx_web_http_client_error.
        "handle exception here
    ENDTRY.

    " CBO 데이터 업데이트
*    MODIFY ENTITIES OF zr_sample_0001 IN LOCAL MODE
*           ENTITY zr_sample_0001 UPDATE fields ( OrderId ) with lt_update_0001
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           MAPPED   DATA(ls_mapped_modify)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED   DATA(lt_failed_modify)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           REPORTED DATA(lt_reported_modify).

    MODIFY ENTITIES OF zr_sample_0001 IN LOCAL MODE
           ENTITY zr_sample_0001 CREATE SET FIELDS WITH VALUE #( ( %cid = '0001' OrderId = lt_final[ 1 ]-purchaseorder Uuid = lt_final[ 1 ]-uuid ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED   DATA(ls_mapped_modify)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(lt_failed_modify)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(lt_reported_modify).
  ENDMETHOD.

  METHOD onvali.

    DATA(a) = 1.
  ENDMETHOD.

ENDCLASS.

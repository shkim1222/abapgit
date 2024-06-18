CLASS lhc_salesorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    "Standard 생성 함수
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR salesorder RESULT result.

    METHODS calculate_order_id FOR DETERMINE ON SAVE
      IMPORTING keys FOR salesorder~calculate_order_id.

    TYPES:
        "스탠다드 API Response Information
        BEGIN OF post_result,
            post_body      TYPE string,
            post_status    TYPE string,
        END OF post_result.

    "API 통신을 위해 생성한 함수
    METHODS:
        GET_CONNECTION
            IMPORTING url           TYPE string
            RETURNING VALUE(result) TYPE REF TO if_web_http_client
            RAISING   cx_static_check,

        CREATE_ORDER
            IMPORTING params TYPE sysuuid_x16
            RETURNING VALUE(result)   TYPE post_result
            RAISING   cx_static_check.

    "상수
    CONSTANTS:
        content_type TYPE string VALUE 'Content-type',
        json_content TYPE string VALUE 'application/json; charset=UTF-8'.

ENDCLASS.

CLASS lhc_salesorder IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD calculate_order_id.
    DATA : sales_orders TYPE TABLE FOR UPDATE zr_sd_so_header,
           sales_order  TYPE STRUCTURE FOR UPDATE zr_sd_so_header.

    " CBO 데이터 조회
    READ ENTITIES OF zr_sd_so_header IN LOCAL MODE
         ENTITY SalesOrder
         ALL FIELDS
           " keys 값 설정
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_sales_order_result)
      " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED    DATA(lt_failed)
         " TODO: variable is assigned but never used (ABAP cleaner)
         REPORTED  DATA(lt_reported).

    " Standard API 호출
    DATA(key) = keys[ 1 ].

    " cbo에서 조회한 데이터로 standard api 호출
    DATA(result) = create_order( key-orderUuid ).

    " 호출 후 결과 값 확인
    DATA result_msg    TYPE string.
    DATA order_id      TYPE string.
    DATA result_status TYPE string.

    result_status = result-post_status.
    result_msg    = result-post_body.

    " en,value뒤에 오는 문자열 조회 -> "앞에 있는 문자열 가져오기 = 오류 메시지
    " en,value를 포함한 문자열 일때만 parsing
    IF ( result_msg CS '"en","value":"' ).
      result_msg = substring_before( val = substring_after( val = result-post_body
                                                            sub = '"en","value":"' )
                                     sub = '"' ).
    ENDIF.

    ""SalesOrder": 를 포함한 문자열 일때만 parsing
    IF ( result_msg CS '"SalesOrder":' ).
      " SalesOrder"뒤에 오는 문자열 조회
      order_id   = substring_before( val = substring_after( val = result-post_body
                                                            sub = '"SalesOrder":' )
                                     sub = ',"' ).

      " 찾은 order id에서 " -> 공백으로 replace, occ = 전체 변경
      order_id   = replace( val  = order_id
                            sub  = '"'
                            with = ''
                            occ  = 0 ).
      result_msg = ''.
    ENDIF.

    " API 호출 결과 값 할당
    LOOP AT lt_sales_order_result INTO DATA(sales_order_read).
      sales_order             = CORRESPONDING #( sales_order_read ).
      sales_order-ZSalesOrder = order_id.
      sales_order-IFMsg       = result_msg.
      sales_order-IFStatus    = result_status.

      APPEND sales_order TO sales_orders.
    ENDLOOP.

    " CBO 데이터 업데이트
    MODIFY ENTITIES OF zr_sd_so_header IN LOCAL MODE
           ENTITY zr_sd_so_header UPDATE SET FIELDS WITH sales_orders
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
  METHOD CREATE_ORDER.

    "시나리오 이름으로 통신이 존재하는지 확인
    DATA: lr_cscn type if_com_scenario_factory=>ty_query-cscn_id_range.
    lr_cscn = value #( ( sign = 'I' option = 'EQ' low = 'ZCS_SD_SO' ) ).

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

    "Order UUID 기준으로 데이터 조회
    READ ENTITIES OF zr_sd_so_header IN LOCAL MODE
        ENTITY SalesOrder
        ALL FIELDS WITH VALUE #( ( OrderUuid = params ) )
        RESULT DATA(lt_sales_order_result)
        "Item 조회
        ENTITY SalesOrder BY \_Item
        ALL FIELDS WITH VALUE #( ( OrderUuid = params ) )
        RESULT DATA(lt_sales_order_item_result)
        "partner 조회
        ENTITY SalesOrder BY \_Partner
        ALL FIELDS WITH VALUE #( ( OrderUuid = params ) )
        RESULT DATA(lt_sales_order_partner_result).

    "Item Body
    DATA : item_json TYPE string.
    LOOP AT lt_sales_order_item_result INTO DATA(sales_order_item).
      IF ( item_json <> '' ).
        item_json = item_json && ',{'.
      ENDIF.

      item_json = item_json && '"SalesOrderItem":"' && sales_order_item-SalesOrderItem && '",' &&
                               '"Material":"' && sales_order_item-Material && '",' &&
                               '"RequestedQuantity":"' && sales_order_item-RequestedQuantity && '",' &&
                               '"RequestedQuantityUnit":"' && sales_order_item-RequestedQuantityUnit && '"' &&
                               '}'.
    ENDLOOP.

    "Partner Body
    DATA : partner_json TYPE string.
    LOOP AT lt_sales_order_partner_result INTO DATA(sales_order_partner).
      IF ( partner_json <> '' ).
        partner_json = partner_json && ',{'.
      ENDIF.

        partner_json = partner_json && '"PartnerFunction":"' && sales_order_partner-Partnerfunction && '",' &&
                                       '"Customer":"' && sales_order_partner-Customer && '"' &&
                                       '}'.
    ENDLOOP.

    "날짜 Type을 YYYY-MM-DD로 바꿔야 해서 가공
    DATA(sales_order_header) = lt_sales_order_result[ 1 ].

    "Pricing Body
    DATA : pricing_json TYPE string.
    pricing_json = pricing_json && '"ConditionType":"' && sales_order_header-ConditionType && '",' &&
                                   '"ConditionRateValue":"' && sales_order_header-ConditionRateValue && '",' &&
                                   '"ConditionCurrency":"' && sales_order_header-ConditionCurrency && '"' &&
                                   '}'.

    DATA(DeliveryYear)  = substring( val = sales_order_header-Requesteddeliverydate len = 4 ).
    DATA(DeliveryMonth) = substring( val = sales_order_header-Requesteddeliverydate off = 4 len = 2 ).
    DATA(DeliveryDay)   = substring( val = sales_order_header-Requesteddeliverydate off = 6 len = 2 ).

    DATA(OrderYear)  = substring( val = sales_order_header-Customerpurchaseorderdate len = 4 ).
    DATA(OrderMonth) = substring( val = sales_order_header-Customerpurchaseorderdate off = 4 len = 2 ).
    DATA(OrderDday)  = substring( val = sales_order_header-Customerpurchaseorderdate off = 6 len = 2 ).

    DATA(SalesYear)  = substring( val = sales_order_header-Salesorderdate len = 4 ).
    DATA(SalesMonth) = substring( val = sales_order_header-Salesorderdate off = 4 len = 2 ).
    DATA(SalesDay)   = substring( val = sales_order_header-Salesorderdate off = 6 len = 2 ).

    " post할 데이터 가공
     DATA(json) =
         '{' &&
         ' "SenderBusinessSystemName":"' && sales_order_header-Senderbusinesssystemname && '",' &&
         ' "PurchaseOrderByCustomer":"' && sales_order_header-Purchaseorderbycustomer && '",' &&
         ' "SalesOrderType":"' && sales_order_header-Salesordertype && '",' &&
         ' "SalesOrganization":"' && sales_order_header-Salesorganization && '",' &&
         ' "DistributionChannel":"' && sales_order_header-Distributionchannel && '",' &&
         ' "SoldToParty":"' && sales_order_header-Soldtoparty && '",' &&
         "' "RequestedDeliveryDate":"' && DeliveryYear && '-' && Deliverymonth && '-' && Deliveryday && '",' && "오류용 주석
         ' "RequestedDeliveryDate":"' && DeliveryYear && '-' && Deliverymonth && '-' && Deliveryday && 'T00:00:00' && '",' &&
         ' "CustomerPurchaseOrderDate":"' && orderyear && '-' && ordermonth && '-' && orderdday && 'T00:00:00' && '",' &&
         ' "SalesOrderDate":"' && salesyear && '-' && salesmonth && '-' && salesday && 'T00:00:00'  && '",' &&
         ' "to_Item":{' &&
         '  "results":[{' &&
         '  ' && item_json &&
         '  ]' &&
         ' },' &&
         ' "to_Partner":{' &&
         '  "results":[{' &&
         '  ' && partner_json &&
         '  ]' &&
         ' },' &&
         ' "to_PricingElement":{' &&
         '  "results":[{' &&
         '  ' && pricing_json &&
         '  ]' &&
         ' }' &&
         '}'.

    "GET
    TRY.
        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = 'ZCS_SD_SO'
            service_id     = 'ZAPI_SALES_CREATE_OUT_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_uri_path( EXPORTING i_uri_path = '?$top=1' ).
        lo_request->set_header_field( i_name = 'x-csrf-token' i_value = 'fetch' ).
        DATA(lo_response) = lo_http_client->execute( if_web_http_client=>get ).

        "get 해서, token이랑 cookie값 가져오기
        DATA(token)   = lo_response->get_header_field( i_name = 'x-csrf-token' ).
        DATA(cookies) = lo_response->get_cookies( ).

      CATCH cx_http_dest_provider_error.
        " handle exception here

      CATCH cx_web_http_client_error.
        " handle exception here
    ENDTRY.

    "POST
    TRY.
        lo_dest = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = 'ZCS_SD_SO'
            service_id     = 'ZAPI_SALES_CREATE_OUT_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
        lo_request  = lo_http_client->get_http_request( ).

        "json body 설정
        lo_request->set_text( json ).
        "GET에서 가져왔던 cookie, token값 셋팅
        LOOP AT cookies INTO DATA(cookie).
            lo_request->set_cookie( i_name = cookie-name i_value = cookie-value ).
        ENDLOOP.

        lo_request->set_header_field( i_name = content_type   i_value = json_content ).
        lo_request->set_header_field( i_name = 'Accept' i_value = 'application/json' ).
        lo_request->set_header_field( i_name = 'x-csrf-token' i_value = token ).
        lo_response = lo_http_client->execute( if_web_http_client=>post ).

        DATA(body)   = lo_response->get_text( ).
        DATA(status) = lo_response->get_status( )-code.

      CATCH cx_http_dest_provider_error.
        " handle exception here

      CATCH cx_web_http_client_error.
        " handle exception here
    ENDTRY.

    result-post_body    = body.
    result-post_status  = status.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_sd_so_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_sd_so_header IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

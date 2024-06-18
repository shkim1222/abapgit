CLASS zcl_abap_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
*    CONSTANTS:
*      c_scenario TYPE string VALUE 'YY1_WBS_API',
*      c_service  TYPE string VALUE 'YY1_WBS_API_REST'.
*
    DATA: http_client TYPE REF TO zcl_if_common_001.

    "수출입 은행에서 환율 데이터 가져와서 사용. 추후 날짜는 Importing을 통해 처리해야함.
    CONSTANTS:
        URL TYPE string VALUE 'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=iOmhP9gTtCM5SE9Unm7HBLPSnyCtBSUt&data=AP01'.
   CLASS-DATA g_exchange_rates TYPE cl_exchange_rates=>ty_exchange_rates.
   CLASS-DATA g_result TYPE cl_exchange_rates=>ty_messages.
   CLASS-METHODS get_rates RETURNING VALUE(exchangerates) TYPE string.
   CLASS-METHODS store_rates IMPORTING exchangerates TYPE string.

ENDCLASS.

CLASS ZCL_ABAP_001 IMPLEMENTATION.

  METHOD get_rates.
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = url ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).
        exchangerates = lo_response->get_text( ).
      CATCH cx_root INTO DATA(lx_exception).

        APPEND VALUE #( type = 'E' message = 'http error' ) TO g_result.
    ENDTRY.
  ENDMETHOD.

  METHOD store_rates.

    CONSTANTS: gc_rate_type TYPE cl_exchange_rates=>ty_exchange_rate-rate_type VALUE 'M'.

    DATA: lr_data           TYPE REF TO data,
          base              TYPE string,
          date              TYPE string,
          exchange_rate     TYPE cl_exchange_rates=>ty_exchange_rate,
          rate(16)          TYPE p DECIMALS 10,
          rate_to_store(16) TYPE p DECIMALS 5,
          factor            TYPE i_exchangeratefactorsrawdata,
          l_result          TYPE cl_exchange_rates=>ty_messages.

    FIELD-SYMBOLS: <data>  TYPE data,
                   <data2> TYPE data,
                   <v>     TYPE data,
                   <r>     TYPE data,
                   <b>     TYPE string,
                   <d>     TYPE string,
                   <f>     TYPE f.

    "JSON 파싱
    lr_data = /ui2/cl_json=>generate( EXPORTING json = exchangerates ).
    ASSIGN lr_data->* TO <data>.
*    ASSIGN <data>->* TO <data2>.
*
*    "통화
*    ASSIGN COMPONENT 'cur_unit' OF STRUCTURE <data> TO <v>.
*    ASSIGN <v>->* TO <b>. " the base currency
*    base = <b>.
*
*    "환율
*    ASSIGN COMPONENT 'ttb' OF STRUCTURE <data> TO <v>.
*    ASSIGN <v>->* TO <r>. " the rates
**
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA(struct_descr) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( <data> ) ).
*
    DATA(a) = 1.
*    LOOP AT struct_descr->components ASSIGNING FIELD-SYMBOL(<comp_descr>).
**     assign the retrieved values
*      ASSIGN COMPONENT <comp_descr>-name OF STRUCTURE <r> TO <v>.
*      ASSIGN <v>->* TO <f>.
*      rate = <f>.
*
*      SELECT SINGLE
*       exchangeratetype,
*       sourcecurrency,
*       targetcurrency,
*       validitystartdate,
*       numberofsourcecurrencyunits,
*       numberoftargetcurrencyunits,
*       alternativeexchangeratetype,
*       altvexchangeratetypevaldtydate
*        FROM i_exchangeratefactorsrawdata
*       WHERE exchangeratetype = @gc_rate_type
*         AND sourcecurrency = @base
*         AND targetcurrency = @<comp_descr>-name
*         AND validitystartdate <= @date
*      INTO @factor.
*      IF sy-subrc <> 0.
**       no rate is an error, skip.
*        APPEND VALUE #( type = 'E' message = 'No factor found for' message_v1 = gc_rate_type message_v2 = base message_v3 = <comp_descr>-name ) TO g_result.
*        CONTINUE.
*      ENDIF.
*
*      CLEAR exchange_rate.
*
*      exchange_rate-rate_type = factor-exchangeratetype.
*      exchange_rate-from_curr = factor-sourcecurrency.
*      exchange_rate-to_currncy = factor-targetcurrency.
*      exchange_rate-valid_from = date.
*      rate_to_store = rate * factor-numberofsourcecurrencyunits / factor-numberoftargetcurrencyunits.
*      exchange_rate-from_factor = factor-numberofsourcecurrencyunits.
*      exchange_rate-to_factor = factor-numberoftargetcurrencyunits.
*      exchange_rate-exch_rate = rate_to_store.
*      APPEND exchange_rate TO g_exchange_rates.
*
*      SELECT SINGLE
*       exchangeratetype,
*       sourcecurrency,
*       targetcurrency,
*       validitystartdate,
*       numberofsourcecurrencyunits,
*       numberoftargetcurrencyunits,
*       alternativeexchangeratetype,
*       altvexchangeratetypevaldtydate
*        FROM i_exchangeratefactorsrawdata
*       WHERE exchangeratetype = @gc_rate_type
*         AND sourcecurrency = @<comp_descr>-name
*         AND targetcurrency = @base
*         AND validitystartdate <= @date
*      INTO @factor.
*      IF sy-subrc <> 0.
**       no rate is an error, skip.
*        APPEND VALUE #( type = 'E' message = 'No factor found for' message_v1 = gc_rate_type message_v2 = base message_v3 = <comp_descr>-name ) TO g_result.
*        CONTINUE.
*      ENDIF.
*
*      CLEAR exchange_rate.
*
*      exchange_rate-rate_type = factor-exchangeratetype.
*      exchange_rate-from_curr = factor-sourcecurrency.
*      exchange_rate-to_currncy = factor-targetcurrency.
*      exchange_rate-valid_from = date.
**     use volume notation to rely on retrieved exchange rates
*      exchange_rate-from_factor_v = factor-numberofsourcecurrencyunits.
*      exchange_rate-to_factor_v = factor-numberoftargetcurrencyunits.
*      rate_to_store = exchange_rate-to_factor_v * rate / exchange_rate-from_factor_v.
*      exchange_rate-exch_rate_v = rate_to_store.
*      APPEND exchange_rate TO g_exchange_rates.
*
*    ENDLOOP.
*
*    "데이터 저장
*    l_result = cl_exchange_rates=>put( EXPORTING exchange_rates = g_exchange_rates ).
*    APPEND LINES OF l_result TO g_result.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( 'hello' ).

  DATA(lt_result) = get_rates(  ).
  out->write( lt_result ).
  out->write( g_result ).

  IF lt_result IS NOT INITIAL.
    store_rates( lt_result ).
  ENDIF.

    "통신 규약 존재 확인
*    CREATE OBJECT me->http_client
*      EXPORTING
*        i_scenario     = c_scenario
*        i_service      = c_service
*      EXCEPTIONS
*        no_arrangement = 1.
*
*    CHECK sy-subrc <> 1.
*
*    DATA(response) = me->http_client->get(
*      EXPORTING
*        uri     = '$format=json'
*    ).
*
*    out->write( response ).
    "Analytical Cube
    "SELECT * FROM YY1_DeliveryNote( p_displaycurrency = 'KRW', p_exchangeratetype = '' ) INTO TABLE @DATA(lt_data).

    "Analytical Dimension
    "SELECT * FROM YY1_I_SalesOrderCubeCreati INTO TABLE @DATA(lt_data).

    "Data Extraction
    "SELECT * FROM YY1_TETS_DE_001 INTO TABLE @DATA(lt_data).

    "External API
    "SELECT * FROM YY1_API_001 INTO TABLE @DATA(lt_data).

    "Standard CDS View
    "SELECT * FROM YY1_WBS_002 INTO TABLE @DATA(lt_data).

    "Value Help
    "SELECT * FROM YY1_TEST_VH_001 INTO TABLE @DATA(lt_data).

*    SELECT * FROM I_SALESORDERTP INTO TABLE @DATA(lt_data).
*
*    MODIFY ENTITIES OF i_salesordertp
*     ENTITY salesorder
*     CREATE
*        FIELDS ( salesordertype
*         salesorganization
*         distributionchannel
*         organizationdivision
*         soldtoparty )
*     WITH VALUE #( ( %cid = 'H001'
*     %data = VALUE #( salesordertype = 'TA'
*     salesorganization = '4310'
*     distributionchannel = '10'
*     organizationdivision = '00'
*     soldtoparty = '0043100001' ) ) )
*
*     MAPPED DATA(ls_mapped)
*     FAILED DATA(ls_failed)
*     REPORTED DATA(ls_reported).
*
*     READ ENTITIES OF i_salesordertp
*     ENTITY salesorder
*     FROM VALUE #( ( salesorder = space ) )
*     RESULT DATA(lt_so_head)
*     REPORTED DATA(ls_reported_read).
*
*
*    COMMIT ENTITIES.

  ENDMETHOD.
ENDCLASS.

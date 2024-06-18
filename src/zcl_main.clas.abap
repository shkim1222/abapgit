CLASS zcl_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
      CONSTANTS:
        URL TYPE string VALUE 'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=iOmhP9gTtCM5SE9Unm7HBLPSnyCtBSUt&data=AP01&searchdate=20240603'.
   CLASS-DATA g_exchange_rates TYPE cl_exchange_rates=>ty_exchange_rates.
   CLASS-DATA g_result TYPE cl_exchange_rates=>ty_messages.
   CLASS-METHODS get_rates RETURNING VALUE(exchangerates) TYPE string.
   CLASS-METHODS store_rates IMPORTING exchangerates TYPE string.
ENDCLASS.

CLASS zcl_main IMPLEMENTATION.

  METHOD get_rates.
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = URL ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).
        exchangerates = lo_response->get_text( ).
      CATCH cx_root INTO DATA(lx_exception).

        APPEND VALUE #( type = 'E' message = 'http error' ) TO g_result.
    ENDTRY.
  ENDMETHOD.

  METHOD store_rates.

    CONSTANTS: gc_rate_type TYPE cl_exchange_rates=>ty_exchange_rate-rate_type VALUE 'M',
               gc_target_unit TYPE string VALUE 'KRW',
               gc_date TYPE string VALUE '20240603'.

    DATA: lr_data           TYPE REF TO data,
          source_unit       TYPE string,
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

    LOOP AT <data> ASSIGNING FIELD-SYMBOL(<data_row>).

      ASSIGN COMPONENT 'CUR_UNIT' OF STRUCTURE <data_row>->* TO <v>.
      source_unit = replace( val = <v>->* sub = '(100)'  with = '' ).

      ASSIGN COMPONENT 'TTB' OF STRUCTURE <data_row>->* TO <r>.
      rate = replace( val = <r>->* sub = ','  with = '' ).

      "조회한 날짜의 환율값이 이미 존재하는지 조회
      SELECT SINGLE
       exchangeratetype,
       sourcecurrency,
       targetcurrency,
       validitystartdate,
       numberofsourcecurrencyunits,
       numberoftargetcurrencyunits,
       alternativeexchangeratetype,
       altvexchangeratetypevaldtydate
        FROM i_exchangeratefactorsrawdata
       WHERE exchangeratetype = @gc_rate_type
         AND sourcecurrency = @source_unit
         AND targetcurrency = @gc_target_unit
         AND validitystartdate <= @gc_date
      INTO @factor.

      IF sy-subrc <> 0.
        APPEND VALUE #( type = 'E' message = 'No factor found for' message_v1 = gc_rate_type message_v2 = gc_target_unit message_v3 = source_unit ) TO g_result.
        CONTINUE.
      ENDIF.

      CLEAR exchange_rate.

      exchange_rate-rate_type = factor-exchangeratetype.
      exchange_rate-from_curr = factor-sourcecurrency.
      exchange_rate-to_currncy = factor-targetcurrency.
      exchange_rate-valid_from = gc_date.
      rate_to_store = rate * factor-numberofsourcecurrencyunits / factor-numberoftargetcurrencyunits.
      exchange_rate-from_factor = factor-numberofsourcecurrencyunits.
      exchange_rate-to_factor = factor-numberoftargetcurrencyunits.
      exchange_rate-exch_rate = rate_to_store.
      APPEND exchange_rate TO g_exchange_rates.

    ENDLOOP.
*
*    "데이터 저장
    l_result = cl_exchange_rates=>put( EXPORTING exchange_rates = g_exchange_rates ).
    APPEND LINES OF l_result TO g_result.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( 'hello' ).

    DATA(lt_result) = get_rates( ).

    IF lt_result IS NOT INITIAL.
        store_rates( lt_result ).
    ELSE.
        out->write( '수출입은행에서 환율 정보를 가져오지 못했습니다.' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.

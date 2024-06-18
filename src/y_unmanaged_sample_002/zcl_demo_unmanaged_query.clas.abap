CLASS zcl_demo_unmanaged_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.
      METHODS get_data_from_request
          IMPORTING io_request       TYPE REF TO if_rap_query_request
          RETURNING VALUE(rt_result) TYPE zif_unmanaged_002_qry=>tt_data
          RAISING   cx_rap_query_filter_no_range.

      METHODS get_total
        IMPORTING io_request      TYPE REF TO if_rap_query_request
        RETURNING VALUE(rt_result) TYPE zif_unmanaged_002_qry=>tt_data.
ENDCLASS.



CLASS ZCL_DEMO_UNMANAGED_QUERY IMPLEMENTATION.


  METHOD get_data_from_request.
*    DATA lt_r_key  TYPE zif_unmanaged_002_qry=>tt_r_uuid.
*    DATA lt_r_text TYPE zif_unmanaged_002_qry=>tt_r_text.
*    DATA lt_r_date TYPE zif_unmanaged_002_qry=>tt_r_date.

*    DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
    DATA(ld_offset) = io_request->get_paging( )->get_offset( ).
    DATA(ld_pagesize) = io_request->get_paging( )->get_page_size( ).

*    LOOP AT lt_filter INTO DATA(ls_filter).
*      CASE ls_filter-name.
*        WHEN 'TABLEKEY'.
*          lt_r_key = CORRESPONDING #( ls_filter-range ).
*        WHEN 'DESCRIPTION'.
*          lt_r_text = CORRESPONDING #( ls_filter-range ).
*        WHEN 'CREATIONDATE'.
*          lt_r_date = CORRESPONDING #( ls_filter-range ).
*      ENDCASE.
*    ENDLOOP.

   " rt_result = zcl_unmanaged_002_qry=>create_instance( )->query( ).

      SELECT *
        FROM zunmanaged_002
       ORDER BY uuid
        INTO TABLE @rt_result
          UP TO @ld_pagesize ROWS
      OFFSET @ld_offset.

  ENDMETHOD.


  METHOD get_total.

     SELECT *
        FROM zunmanaged_002
        INTO TABLE @rt_result.

  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_output TYPE STANDARD TABLE OF zunmanaged_002.

    DATA(lt_database) = get_data_from_request( io_request ).
    DATA(lt_count) = get_total( io_request ).
    lt_output = CORRESPONDING #( lt_database MAPPING uuid = uuid text = text cdate = cdate ).

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_output ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      "io_response->set_total_number_of_records( lines( lt_output ) ).
        io_response->set_total_number_of_records( LINES( lt_count ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

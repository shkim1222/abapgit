CLASS zcl_unmanaged_api_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES : tt_create TYPE TABLE FOR CREATE zr_unmanaged_001,
            tt_mapped TYPE RESPONSE FOR MAPPED EARLY zr_unmanaged_001,
            tt_failed TYPE RESPONSE FOR FAILED EARLY zr_unmanaged_001,
            tt_reported TYPE RESPONSE FOR REPORTED EARLY zr_unmanaged_001,
            tt_reported_late TYPE RESPONSE FOR REPORTED LATE zr_unmanaged_001,

            ts_data   TYPE zr_unmanaged_001,
            tt_data   TYPE STANDARD TABLE OF ts_data WITH EMPTY KEY.

    CLASS-METHODS : get_instance
        RETURNING VALUE(ro_instance) TYPE REF TO zcl_unmanaged_api_class.

    METHODS :
        create_table
            IMPORTING entities TYPE tt_create
            CHANGING    mapped TYPE tt_mapped
                        failed TYPE tt_failed
                        reported type tt_reported,

        get_uuid
            RETURNING VALUE(result) TYPE sysuuid_x16,

        save_data
            CHANGING reported type tt_reported_late,
        query
          RETURNING VALUE(rt_result) TYPE tt_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA : mo_instance TYPE REF TO zcl_unmanaged_api_class,
                 gt_table TYPE STANDARD TABLE OF zunmanaged_001,
                 gs_mapped TYPE tt_mapped,
                 gt_results TYPE STANDARD TABLE OF tt_reported.

   METHODS get_data_from_request
      IMPORTING io_request       TYPE REF TO if_rap_query_request
      RETURNING VALUE(rt_result) TYPE tt_data
      RAISING   cx_rap_query_filter_no_range.
ENDCLASS.



CLASS ZCL_UNMANAGED_API_CLASS IMPLEMENTATION.


  METHOD create_table.
    gt_table = CORRESPONDING #( entities MAPPING FROM ENTITY ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>).
        IF gt_table IS NOT INITIAL.
            gt_table[ 1 ]-uuid = get_uuid( ).
            gt_table[ 1 ]-age = 'age'.
            gt_table[ 1 ]-name = 'name'.

            mapped-zr_unmanaged_001 = VALUE #( (
                                                    %cid = <lfs_entities>-%cid
                                                    %key = <lfs_entities>-%key
                                             ) ).
        ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_data_from_request.

    DATA(ld_offset) = io_request->get_paging( )->get_offset( ).
    DATA(ld_pagesize) = io_request->get_paging( )->get_page_size( ).

    rt_result = zcl_unmanaged_api_class=>get_instance( )->query( ).


  ENDMETHOD.


  METHOD get_instance.
    mo_instance = ro_instance = COND #( WHEN mo_instance IS BOUND
                                        THEN mo_instance
                                        ELSE NEW #( ) ).

  ENDMETHOD.


  METHOD get_uuid.
    DATA: system_uuid TYPE REF TO if_system_uuid.

    system_uuid = cl_uuid_factory=>create_system_uuid( ).

    TRY.
        result = system_uuid->create_uuid_x16( ).
    CATCH cx_uuid_error.
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_output TYPE STANDARD TABLE OF zunmanaged_001.

    DATA(lt_database) = get_data_from_request( io_request ).
    lt_output = CORRESPONDING #( lt_database ).

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_output ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
  ENDMETHOD.


  METHOD query.
    SELECT FROM zr_unmanaged_001
      FIELDS *
      INTO TABLE @rt_result.
  ENDMETHOD.


  METHOD save_data.
    IF gt_table IS NOT INITIAL.
        MODIFY zunmanaged_001 FROM TABLE @gt_table.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

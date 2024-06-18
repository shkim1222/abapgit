CLASS zcl_unmanaged_002_qry DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
     INTERFACES zif_unmanaged_002_qry.

     CLASS-METHODS create_instance
        RETURNING VALUE(ro_result) TYPE REF TO zif_unmanaged_002_qry.

     CLASS-DATA : gt_create TYPE STANDARD TABLE OF zunmanaged_002,
                  gt_update TYPE STANDARD TABLE OF zunmanaged_002,
                  gt_delete TYPE STANDARD TABLE OF zunmanaged_002.

ENDCLASS.



CLASS ZCL_UNMANAGED_002_QRY IMPLEMENTATION.


  METHOD create_instance.
     ro_result = NEW zcl_unmanaged_002_qry( ).
  ENDMETHOD.


  METHOD zif_unmanaged_002_qry~delete.
    DELETE FROM zunmanaged_002 WHERE uuid = @id_uuid.
    rd_result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


  METHOD zif_unmanaged_002_qry~modify.
    DATA ls_data TYPE zunmanaged_002.
    ls_data = CORRESPONDING #( is_data ).

    IF ls_data-uuid IS INITIAL.
      TRY.
          ls_data-uuid = cl_system_uuid=>create_uuid_x16_static( ).

          IF ls_data-cdate IS INITIAL.
            ls_data-cdate = cl_abap_context_info=>get_system_date( ).
          ENDIF.

        CATCH cx_uuid_error.
          rd_result = abap_false.
          RETURN.
      ENDTRY.

      INSERT zunmanaged_002 FROM @ls_data.

    ELSE.
      UPDATE zunmanaged_002 FROM @ls_data.

    ENDIF.

    rd_result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


  METHOD zif_unmanaged_002_qry~query.

    SELECT FROM zunmanaged_002
      FIELDS *
      WHERE uuid IN @it_r_uuid
        AND text IN @it_r_text
        AND cdate IN @it_r_date
      INTO TABLE @rt_result.

  ENDMETHOD.


  METHOD zif_unmanaged_002_qry~read.

    SELECT SINGLE FROM zunmanaged_002
      FIELDS *
      WHERE uuid = @id_uuid
      INTO @rs_result.

  ENDMETHOD.
ENDCLASS.

CLASS lhc_zr_unmanaged_001 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_unmanaged_001 RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zr_unmanaged_001.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zr_unmanaged_001.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zr_unmanaged_001.

    METHODS read FOR READ
      IMPORTING keys FOR READ zr_unmanaged_001 RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zr_unmanaged_001.

    METHODS getData FOR MODIFY
      IMPORTING keys for ACTION zr_unmanaged_001~getData.

    DATA : gs_table TYPE zunmanaged_001,
           gt_table TYPE TABLE OF zunmanaged_001.

ENDCLASS.

CLASS lhc_zr_unmanaged_001 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    zcl_unmanaged_api_class=>get_instance( )->create_table(
        EXPORTING
            entities = entities
        CHANGING
            mapped = mapped
            failed = failed
            reported = reported
    ).


  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD getData.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_unmanaged_001 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_unmanaged_001 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    zcl_unmanaged_api_class=>get_instance( )->save_data(
        CHANGING
            reported = reported
    ).

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.


ENDCLASS.

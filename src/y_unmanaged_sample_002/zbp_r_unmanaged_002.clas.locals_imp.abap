CLASS lhc_zr_unmanaged_002 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_unmanaged_002 RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zr_unmanaged_002.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zr_unmanaged_002.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zr_unmanaged_002.

    METHODS read FOR READ
      IMPORTING keys FOR READ zr_unmanaged_002 RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zr_unmanaged_002.


ENDCLASS.

CLASS lhc_zr_unmanaged_002 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
   INSERT LINES OF
         CORRESPONDING zif_unmanaged_002_qry=>tt_data( entities MAPPING cdate = cdate text = text )
         INTO TABLE zcl_unmanaged_002_qry=>gt_create.
  ENDMETHOD.

  METHOD update.
    DATA(lo_data_handler) = zcl_unmanaged_002_qry=>create_instance( ).

    LOOP AT entities INTO DATA(ls_entity).
      DATA(ls_original) = lo_data_handler->read( ls_entity-uuid ).

      IF ls_entity-%control-text = if_abap_behv=>mk-on.
        ls_original-text = ls_entity-text.
      ENDIF.

      IF ls_entity-%control-cdate = if_abap_behv=>mk-on.
        ls_original-cdate = ls_entity-cdate.
      ENDIF.

      INSERT ls_original INTO TABLE zcl_unmanaged_002_qry=>gt_update.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    INSERT LINES OF
           CORRESPONDING zif_unmanaged_002_qry=>tt_data( keys MAPPING uuid = uuid )
           INTO TABLE zcl_unmanaged_002_qry=>gt_delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_unmanaged_002 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_unmanaged_002 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

      DATA(lo_data_handler) = zcl_unmanaged_002_qry=>create_instance( ).

      LOOP AT zcl_unmanaged_002_qry=>gt_create INTO DATA(ls_create).
        lo_data_handler->modify( ls_create ).
      ENDLOOP.

      LOOP AT zcl_unmanaged_002_qry=>gt_update INTO DATA(ls_update).
        lo_data_handler->modify( ls_update ).
      ENDLOOP.

      LOOP AT zcl_unmanaged_002_qry=>gt_delete INTO DATA(ls_delete).
        lo_data_handler->delete( ls_delete-uuid ).
      ENDLOOP.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

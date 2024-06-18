CLASS y_batch_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_jt_check_20 .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_apj_rt_job_notif_exit .
    INTERFACES if_apj_rt_value_help_exit .
    INTERFACES if_apj_types .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS y_batch_class IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    DATA(a) = 1.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~adjust_hidden.
    DATA(a) = 2.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~adjust_read_only.
    DATA(a) = 3.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~check_and_adjust.
    DATA(a) = 4.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~check_and_adjust_parameter.
    DATA(a) = 5.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~check_authorizations.
    DATA(a) = 6.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~check_start_condition.
    DATA(a) = 7.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~get_dynamic_properties.
    DATA(a) = 8.
  ENDMETHOD.

  METHOD if_apj_jt_check_20~initialize.
    DATA(a) = 9.
  ENDMETHOD.

  METHOD if_apj_rt_exec_object~execute.

    DATA : ls_batch TYPE ztable_batch_001.
    DATA : lt_batch TYPE TABLE OF ztable_batch_001.

    SELECT * FROM I_PurchaseOrderAPI01 INTO TABLE @DATA(lt_data).
    LOOP AT lt_data INTO DATA(ls_data).

        ls_batch-poid = ls_data-PurchaseOrder.
        APPEND ls_batch TO lt_batch.
        CLEAR : ls_batch.

    ENDLOOP.

    INSERT ztable_batch_001 FROM TABLE @lt_batch.

  ENDMETHOD.

  METHOD if_apj_rt_job_notif_exit~notify_jt_end.
    DATA(a) = 11.
  ENDMETHOD.

  METHOD if_apj_rt_job_notif_exit~notify_jt_start.
    DATA(a) = 12.
  ENDMETHOD.

  METHOD if_apj_rt_value_help_exit~adjust.
    DATA(a) = 13.
  ENDMETHOD.
ENDCLASS.

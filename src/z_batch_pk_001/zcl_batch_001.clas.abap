CLASS zcl_batch_001 DEFINITION
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



CLASS zcl_batch_001 IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~adjust_hidden.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~adjust_read_only.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~check_and_adjust.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~check_and_adjust_parameter.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~check_authorizations.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~check_start_condition.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~get_dynamic_properties.
  ENDMETHOD.


  METHOD if_apj_jt_check_20~initialize.
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
  ENDMETHOD.


  METHOD if_apj_rt_job_notif_exit~notify_jt_end.
  ENDMETHOD.


  METHOD if_apj_rt_job_notif_exit~notify_jt_start.
  ENDMETHOD.


  METHOD if_apj_rt_value_help_exit~adjust.
  ENDMETHOD.
ENDCLASS.

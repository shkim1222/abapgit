CLASS zcl_exchange_rate_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_exchange_rate_001 IMPLEMENTATION.

  METHOD if_apj_dt_exec_object~get_parameters.

  DATA a TYPE d.

    et_parameter_def = VALUE #(
      ( selname = 'P_DATE'
        kind = if_apj_dt_exec_object=>parameter
        datatype = 'd'
        param_text = '환율 조회 날짜'
        changeable_ind = abap_true
        mandatory_ind = abap_true
      )
    ).

    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'P_DATE'
        kind = if_apj_dt_exec_object=>parameter
        sign = 'I'
        option = 'EQ'
      )
    ).

  ENDMETHOD.

  METHOD if_apj_rt_exec_object~execute.
    DATA P_DATE TYPE d.

    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_DATE'. p_date = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

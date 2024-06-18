CLASS z_sd_so_batch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_SD_SO_BATCH IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
*    et_parameter_def = VALUE #(
*      ( selname = 'P_DATE'    kind = if_apj_dt_exec_object=>parameter datatype = 'DATE' param_text = '판매 오더 생성일' changeable_ind = abap_true )
*    ).
*
*    " Return the default parameters values here
*    et_parameter_val = VALUE #(
*      ( selname = 'P_DATE'    kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = sy-datum )
*    ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA : P_DATE TYPE datum.

    DATA: jobname   type cl_apj_rt_api=>TY_JOBNAME.
    DATA: jobcount  type cl_apj_rt_api=>TY_JOBCOUNT.
    DATA: catalog   type cl_apj_rt_api=>TY_CATALOG_NAME.
    DATA: template  type cl_apj_rt_api=>TY_TEMPLATE_NAME.

    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_DESCR'. P_DATE = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    try.
*     read own runtime info catalog
       cl_apj_rt_api=>GET_JOB_RUNTIME_INFO(
                        importing
                          ev_jobname        = jobname
                          ev_jobcount       = jobcount
                          ev_catalog_name   = catalog
                          ev_template_name  = template ).

       catch cx_apj_rt.

    endtry.


    DATA :
          lt_source_data TYPE TABLE OF I_SalesOrder,
          ls_source_data TYPE I_SalesOrder.
*          ls_target_data TYPE STRUCTURE FOR CREATE zi_so_01,
*          lt_target_data TYPE TABLE FOR CREATE zi_so_01.

    "오더 정보가 160인 데이터 조회
    SELECT * FROM I_SalesOrder WHERE SalesOrder = '00' INTO TABLE @lt_source_data.
    LOOP AT lt_source_data INTO DATA(sales_order_result).
      "CLEAR ls_target_data.
*
*      ls_source_data                       = CORRESPONDING #( sales_order_result ).
*
*      ls_target_data-SalesOrganization     = ls_source_data-SalesOrganization.
*      ls_target_data-DistributionChannel   = ls_source_data-DistributionChannel.
*      "ls_target_data-OrganizationDivision  = ls_source_data-OrganizationDivision.
*      ls_target_data-OrganizationDivision  = 'D2'.
*      ls_target_data-SoldToParty           = ls_source_data-SoldToParty.
*
*      APPEND ls_target_data TO lt_target_data.
    ENDLOOP.
*
*    MODIFY ENTITIES OF zi_so_01
*    ENTITY SalesOrder CREATE FIELDS ( SalesOrganization DistributionChannel OrganizationDivision SoldToParty )
*    WITH lt_target_data
*    MAPPED   DATA(ls_mapped_modify)
*    FAILED   DATA(lt_failed_modify)
*    REPORTED DATA(lt_reported_modify).
*
*    COMMIT ENTITIES.

  ENDMETHOD.
ENDCLASS.

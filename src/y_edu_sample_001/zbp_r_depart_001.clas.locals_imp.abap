CLASS lhc_depart DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR depart RESULT result.

    METHODS init_code FOR DETERMINE ON SAVE
      IMPORTING keys FOR Depart~init_code.

    METHODS check_value FOR VALIDATE ON SAVE
      IMPORTING keys FOR Depart~check_value.

ENDCLASS.

CLASS lhc_depart IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD init_code.

    READ ENTITIES OF zr_depart_001 IN LOCAL MODE
    ENTITY Depart
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT      DATA(lt_result)
    FAILED      DATA(lt_failed)
    REPORTED    DATA(lt_reported).

    DATA(ls_result) = lt_result[ 1 ].

    SELECT MAX( DeptCode ) FROM zr_depart_001 INTO @DATA(max_dept).

    DATA : ls_update TYPE STRUCTURE FOR UPDATE zr_depart_001,
           lt_update TYPE TABLE FOR UPDATE zr_depart_001.

    ls_update = CORRESPONDING #( ls_result ).
    ls_update-DeptCode = max_dept + 1.
    IF ls_update-EndDate IS INITIAL.
        ls_update-EndDate = '99991231'.
    ENDIF.
    APPEND ls_update TO lt_update.

     " CBO 데이터 업데이트
    MODIFY ENTITIES OF zr_depart_001 IN LOCAL MODE
    ENTITY Depart UPDATE SET FIELDS WITH lt_update
    MAPPED   DATA(ls_mapped_modify)
    FAILED   DATA(lt_failed_modify)
    REPORTED DATA(lt_reported_modify).

  ENDMETHOD.

  METHOD check_value.

    READ ENTITIES OF zr_depart_001 IN LOCAL MODE
    ENTITY Depart
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT      DATA(lt_result)
    FAILED      DATA(lt_failed)
    REPORTED    DATA(lt_reported).

    DATA : lv_msg_v1 TYPE string.
    LOOP AT lt_result INTO DATA(ls_result).
        IF ls_result-DeptDesc IS INITIAL.
            lv_msg_v1 = '학과명칭'.
        ENDIF.

        IF ls_result-StrDate IS INITIAL.
            IF lv_msg_v1 IS NOT INITIAL.
                lv_msg_v1 = lv_msg_v1 && ', '.
            ENDIF.
            lv_msg_v1 = lv_msg_v1 && '시작년월'.
        ENDIF.

        IF lv_msg_v1 IS NOT INITIAL.
            APPEND VALUE #( %tky = ls_result-%tky ) TO failed-depart.
            APPEND VALUE #( %tky = ls_result-%tky %state_area = 'check_value' %msg = new_message( id = 'ZEDU_SAMPLE_001' number = 001 severity = if_abap_behv_message=>severity-error v1 = lv_msg_v1 ) ) TO reported-depart.
        ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

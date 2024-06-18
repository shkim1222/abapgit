CLASS lhc_student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR student RESULT result.

    METHODS init_code FOR DETERMINE ON SAVE
      IMPORTING keys FOR Student~init_code.

    METHODS check_value FOR VALIDATE ON SAVE
      IMPORTING keys FOR Student~check_value.

ENDCLASS.

CLASS lhc_student IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD init_code.

    READ ENTITIES OF zr_student_001 IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT      DATA(lt_result)
    FAILED      DATA(lt_failed)
    REPORTED    DATA(lt_reported).

    DATA(ls_result) = lt_result[ 1 ].
    DATA(lv_year) = substring( val = ls_result-StrDate len = 4 ).

    SELECT MAX( StudNumb ) FROM zr_student_001 WHERE LEFT( StrDate, 4 ) = @lv_year INTO @DATA(max_numb).

    DATA : ls_update TYPE STRUCTURE FOR UPDATE zr_student_001,
           lt_update TYPE TABLE FOR UPDATE zr_student_001.

    ls_update = CORRESPONDING #( ls_result ).
    max_numb = max_numb + 1.
    ls_update-StudCode = lv_year && max_numb.
    ls_update-StudNumb = max_numb.

    APPEND ls_update TO lt_update.

     " CBO 데이터 업데이트
    MODIFY ENTITIES OF zr_student_001 IN LOCAL MODE
    ENTITY Student UPDATE SET FIELDS WITH lt_update
    MAPPED   DATA(ls_mapped_modify)
    FAILED   DATA(lt_failed_modify)
    REPORTED DATA(lt_reported_modify).

  ENDMETHOD.

  METHOD check_value.

    READ ENTITIES OF zr_student_001 IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT      DATA(lt_result)
    FAILED      DATA(lt_failed)
    REPORTED    DATA(lt_reported).

    DATA : lv_msg_v1 TYPE string.
    LOOP AT lt_result INTO DATA(ls_result).
        IF ls_result-StudDesc IS INITIAL.
            lv_msg_v1 = '이름'.
        ENDIF.

        IF ls_result-StrDate IS INITIAL.
            IF lv_msg_v1 IS NOT INITIAL.
                lv_msg_v1 = lv_msg_v1 && ', '.
            ENDIF.
            lv_msg_v1 = lv_msg_v1 && '입학년월'.
        ENDIF.

        IF ls_result-StudDeptCode IS INITIAL.
            IF lv_msg_v1 IS NOT INITIAL.
                lv_msg_v1 = lv_msg_v1 && ', '.
            ENDIF.
            lv_msg_v1 = lv_msg_v1 && '학과'.
        ENDIF.

        IF lv_msg_v1 IS NOT INITIAL.
            APPEND VALUE #( %tky = ls_result-%tky ) TO failed-student.
            APPEND VALUE #( %tky = ls_result-%tky %msg = new_message( id = 'ZEDU_SAMPLE_001' number = 001 severity = if_abap_behv_message=>severity-error v1 = lv_msg_v1 ) ) TO reported-student.
        ENDIF.

        "선택한 학과의 값이 입학년월, 졸업년월에 폐지된 학과가 아니어야 함.
        "입학일보다 종료일이 더 후인경우,
        SELECT EndDate FROM zr_depart_001 WHERE EndDate < @ls_result-StrDate AND DeptCode = @ls_result-StudDeptCode INTO TABLE @DATA(lt_depart).

        IF lines( lt_depart ) > 0.
            DATA(year) = SUBSTRING( val = lt_depart[ 1 ]-EndDate len = 4 ).
            DATA(month) = SUBSTRING( val = lt_depart[ 1 ]-EndDate off = 4 len = 2 ).
            DATA(day) = SUBSTRING( val = lt_depart[ 1 ]-EndDate off = 6 len = 2 ).
            CONCATENATE year month day INTO DATA(date) SEPARATED BY '-'.

            APPEND VALUE #( %tky = ls_result-%tky ) TO failed-student.
            APPEND VALUE #( %tky = ls_result-%tky %msg = new_message( id = 'ZEDU_SAMPLE_001' number = 002 severity = if_abap_behv_message=>severity-error v1 = ls_result-StudDeptDesc v2 = date ) ) TO reported-student.
        ENDIF.

        IF ( ls_result-EndDate IS NOT INITIAL ) AND  ( ls_result-StrDate >= ls_result-EndDate ).
            APPEND VALUE #( %tky = ls_result-%tky ) TO failed-student.
            APPEND VALUE #( %tky = ls_result-%tky %msg = new_message( id = 'ZEDU_SAMPLE_001' number = 003 severity = if_abap_behv_message=>severity-error ) ) TO reported-student.
        ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

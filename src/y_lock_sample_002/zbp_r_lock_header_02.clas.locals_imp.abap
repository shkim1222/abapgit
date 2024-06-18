CLASS lhc_lockobject DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR lockobject RESULT result.

*    METHODS lock FOR MODIFY
*      IMPORTING keys FOR ACTION lockobject~lock RESULT result.


ENDCLASS.

CLASS lhc_lockobject IMPLEMENTATION.

    METHOD get_instance_authorizations.

    ENDMETHOD.

*    METHOD lock.
*
*        DATA : lt_lock TYPE TABLE FOR UPDATE zr_lock_header_02 ,
*               ls_lock TYPE STRUCTURE FOR UPDATE zr_lock_header_02.
*
*        "데이터 조회
*        READ ENTITIES OF zr_lock_header_02 in LOCAL MODE
*        ENTITY lockobject
*        FIELDS ( flag )
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_result)
*        FAILED DATA(lt_failed)
*        REPORTED DATA(lt_reported).
*
*        " API 호출 결과 값 할당
*        LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<ls_result>).
*            DATA(flag) = <ls_result>-flag.
*
*            APPEND VALUE #( %tky       = <ls_result>-%tky
*                            flag       = flag
*                          ) TO lt_lock.
*        ENDLOOP.
*
*        MODIFY ENTITIES OF zr_lock_header_02 IN LOCAL MODE
*        ENTITY lockobject
*        UPDATE FIELDS ( flag )
*        WITH lt_lock
*        MAPPED   DATA(ls_mapped_modify)
*        FAILED   DATA(lt_failed_modify)
*        REPORTED DATA(lt_reported_modify).
*
*    ENDMETHOD.

ENDCLASS.

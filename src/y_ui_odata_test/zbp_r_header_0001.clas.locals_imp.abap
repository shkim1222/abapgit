CLASS lhc_zr_header_0001 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_header_0001 RESULT result.

    METHODS test001 FOR MODIFY
      IMPORTING keys FOR ACTION zr_header_0001~test001 RESULT result.

ENDCLASS.

CLASS lhc_zr_header_0001 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD test001.

    DATA : lt_header TYPE TABLE FOR CREATE zr_header_0001,
           ls_header TYPE STRUCTURE FOR CREATE zr_header_0001.

    ls_header-Name = '김서현'.
    ls_header-Age = '26'.

    SELECT COMPANYCODE, FISCALYEAR, ACCOUNTINGDOCUMENT, ACCOUNTINGDOCUMENTTYPE, DOCUMENTDATE, POSTINGDATE FROM I_JournalEntry INTO TABLE @DATA(lv_posting) UP TO 1 rows.

    lt_header = CORRESPONDING #( lv_posting ).

    MODIFY ENTITIES OF zr_header_0001 IN LOCAL MODE
    ENTITY zr_header_0001 CREATE SET FIELDS WITH lt_header
    MAPPED   DATA(ls_mapped_modify)
    FAILED   DATA(lt_failed_modify)
    REPORTED DATA(lt_reported_modify).

  ENDMETHOD.

ENDCLASS.

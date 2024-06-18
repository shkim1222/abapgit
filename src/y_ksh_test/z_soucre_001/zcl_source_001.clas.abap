CLASS zcl_source_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_source_001 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA ls_result TYPE string.

    TRY.
      "  CALL FUNCTION 'ZFM_01' EXPORTING im_p1 = '안녕' im_p2 = 1 IMPORTING ex_p1 = ls_result.
        CALL FUNCTION 'ZFM_01'.
        out->write( ls_result ).
    CATCH CX_ROOT INTO DATA(lt_error).
        out->write( lt_error ).
    ENDTRY.
  ENDMETHOD.


ENDCLASS.

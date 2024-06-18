CLASS zcl_edu_header_insert_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_edu_header_insert_01 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA : ls_data TYPE ZEDU_HEADER_01.

    ls_data-name = '김서현'.
    ls_data-age = 5.

    INSERT zedu_header_01 FROM @ls_data.

  ENDMETHOD.
ENDCLASS.

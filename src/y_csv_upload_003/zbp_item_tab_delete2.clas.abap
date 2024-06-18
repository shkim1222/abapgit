CLASS zbp_item_tab_delete2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBP_ITEM_TAB_DELETE2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "DELETE FROM zitem.
    DATA: lt_values TYPE TABLE OF char100,
          ls_value TYPE char100.

    lt_values = VALUE #( ( '51273E16A2301EEE90E096F05829DFD8' )
                         ( '51273E16A2301EDE90E1D3923AF67453' ) ).


    LOOP AT lt_values INTO ls_value.
      DELETE FROM zitem WHERE order_uuid = @ls_value.
    ENDLOOP.

ENDMETHOD.
ENDCLASS.

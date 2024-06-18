CLASS zcl_call_function DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CALL_FUNCTION IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*     CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
*            EXPORTING
*              documentheader = '1'.

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
    lv_cid TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
    CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).

    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
            companycode = '4310' " Success
            documentreferenceid = 'BKPFF'
            createdbyuser = 'TESTER'
            businesstransactiontype = 'RFBU'
            accountingdocumenttype = 'SA'
            documentdate = sy-datlo
            postingdate = sy-datlo
            accountingdocumentheadertext = 'RAP rules'
            _glitems = VALUE #( ( glaccountlineitem = |001| glaccount = '0000400000' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-100.55' currency = 'JPY' ) ) )
            ( glaccountlineitem = |002| glaccount = '0000400000' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '100.55' currency = 'JPY' ) ) ) )
        ).

    MODIFY ENTITIES OF i_journalentrytp
    ENTITY journalentry
    EXECUTE post FROM lt_je_deep
    FAILED DATA(ls_failed_deep)
    REPORTED DATA(ls_reported_deep)
    MAPPED DATA(ls_mapped_deep).

  ENDMETHOD.
ENDCLASS.

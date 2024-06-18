CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS create_je FOR DETERMINE ON SAVE
      IMPORTING keys FOR Header~create_je.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create_je.

    DATA :  req_journal_item   TYPE zjournal_entry_create_request9,
            req_journal_itemT  TYPE TABLE OF zjournal_entry_create_request9,

            req_credi_item     TYPE zjournal_entry_create_reques16,
            req_credi_itemT    TYPE TABLE OF zjournal_entry_create_reques16,

            req_journal_entry  TYPE zjournal_entry_create_reques18,
            req_create_reqitem TYPE  zjournal_entry_create_request,
            req_create_request TYPE TABLE OF zjournal_entry_create_request.

    TRY.
        "시나리오 이름으로 통신이 존재하는지 확인
        DATA: lr_cscn type if_com_scenario_factory=>ty_query-cscn_id_range.
        lr_cscn = value #( ( sign = 'I' option = 'EQ' low = 'ZCS_FI_JE_SAMPLE_001' ) ).

        DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).
        lo_factory->query_ca(
              EXPORTING
                is_query           = value #( cscn_id_range = lr_cscn )
              IMPORTING
                et_com_arrangement = data(lt_ca)
            ).

        "해당 시나리오가 존재 하지 않으면 종료
        IF lt_ca is initial.
          EXIT.
        ENDIF.

        "조회 한 값 중 1번째 값
        DATA(lo_ca) = lt_ca[ 1 ].

        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = 'ZCS_FI_JE_SAMPLE_001'
            service_id     = 'ZOS_FI_JE_SAMPLE_001_SPRX'
            comm_system_id = lo_ca->get_comm_system_id( ) ).

        DATA(proxy) = NEW ZCO_JOURNAL_ENTRY_CREATE_REQUE(
                        destination = destination
                      ).

*        " Header
*        req_journal_entry-original_reference_document_ty = 'BKPFF'.
*        req_journal_entry-business_transaction_type = 'RFBU'.
*        req_journal_entry-accounting_document_type = 'SA'.
*        req_journal_entry-company_code = '4310'.
*        req_journal_entry-document_date = '20231031'.
*        req_journal_entry-posting_date = '20231031'.
*        req_journal_entry-created_by_user = 'CC0000000008'.
*
*        " item Structure
*        req_journal_item-glaccount-content = '10010001'.
*        req_journal_item-amount_in_transaction_currency-currency_code = 'KRW'.
*        req_journal_item-amount_in_transaction_currency-content = '100'.
*        req_journal_item-debit_credit_code = 'S'.
*        req_journal_item-account_assignment-cost_center = '43101101'.
*        APPEND req_journal_item TO req_journal_itemT.
*        req_journal_entry-item = req_journal_itemT.
*
*        req_journal_item-glaccount-content = '10010001'.
*        req_journal_item-amount_in_transaction_currency-currency_code = 'KRW'.
*        req_journal_item-amount_in_transaction_currency-content = '-100'.
*        req_journal_item-debit_credit_code = 'H'.
*        req_journal_item-account_assignment-cost_center = '43101101'.
*        APPEND req_journal_item TO req_journal_itemT.
*        req_journal_entry-item = req_journal_itemT.

        READ ENTITIES OF zr_fi_je_header IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH VALUE #( ( Uuid = keys[ 1 ]-Uuid ) )
        RESULT DATA(lt_result)
        "Item 조회
        ENTITY Header BY \_Item
        ALL FIELDS WITH VALUE #( ( Uuid = keys[ 1 ]-Uuid ) )
        RESULT DATA(lt_result_item).

        " Header
        req_journal_entry-original_reference_document_ty = lt_result[ 1 ]-ReferenceDocumentType.
        req_journal_entry-business_transaction_type = lt_result[ 1 ]-BusinessTransactionType.
        req_journal_entry-accounting_document_type = lt_result[ 1 ]-AccountingDocumentType.
        req_journal_entry-company_code = lt_result[ 1 ]-CompanyCode.
        req_journal_entry-document_date = lt_result[ 1 ]-DocumentDate.
        req_journal_entry-posting_date = lt_result[ 1 ]-PostingDate.
        req_journal_entry-created_by_user = 'CC0000000008'.

        DATA : number_string TYPE string.
        LOOP AT lt_result_item INTO DATA(ls_result_item).
            " item Structure
            req_journal_item-glaccount-content = ls_result_item-Glaccount.
            req_journal_item-amount_in_transaction_currency-currency_code = ls_result_item-AmountCurrency.

            number_string = ls_result_item-Amountintransactioncurrency.
            REPLACE FIRST OCCURRENCE OF '.' IN number_string WITH ''.

            req_journal_item-amount_in_transaction_currency-content = number_string.

            req_journal_item-debit_credit_code = ls_result_item-Debitcreditcode.
            req_journal_item-account_assignment-cost_center = ls_result_item-Costcenter.
            APPEND req_journal_item TO req_journal_itemT.
            CLEAR : req_journal_item.
        ENDLOOP.

        req_journal_entry-item = req_journal_itemT.
        req_create_reqitem-journal_entry = req_journal_entry.
        APPEND req_create_reqitem TO req_create_request.

        DATA(request) = VALUE zjournal_entry_bulk_create_req( journal_entry_bulk_create_requ-journal_entry_create_request = req_create_request  ).
        proxy->journal_entry_create_request_c(
          EXPORTING
            input = request
          IMPORTING
            output = DATA(response)
        ).

        DATA : zheaderT TYPE TABLE FOR UPDATE zr_fi_je_header,
               zheader TYPE STRUCTURE FOR UPDATE zr_fi_je_header.

        DATA(lv_doc) = response-journal_entry_bulk_create_conf-journal_entry_create_confirmat[ 1 ]-journal_entry_create_confirmat-accounting_document.
        "분개 생성 되지 않았으면
        IF lv_doc EQ '0000000000'.
            zheader = CORRESPONDING #( lt_result[ 1 ] ).
            zheader-IFMsg = response-journal_entry_bulk_create_conf-journal_entry_create_confirmat[ 1 ]-log-item[ 1 ]-note.
            zheader-IFStatus = 'FAIL'.
        ELSE.
            zheader = CORRESPONDING #( lt_result[ 1 ] ).
            zheader-IFStatus = 'SUCCESS'.
            zheader-Document = lv_doc.
        ENDIF.

        APPEND zheader TO zheadert.

        MODIFY ENTITIES OF zr_fi_je_header IN LOCAL MODE
        ENTITY Header UPDATE SET FIELDS WITH zheaderT
        MAPPED   DATA(ls_mapped_modify)
        FAILED   DATA(lt_failed_modify)
        REPORTED DATA(lt_reported_modify).

        "handle response
      CATCH cx_soap_destination_error INTO DATA(soap_destination_error).
        DATA(error_message) = soap_destination_error->get_text(  ).

      CATCH cx_ai_system_fault INTO DATA(ai_system_fault).
        error_message = | code: { ai_system_fault->code  } codetext: { ai_system_fault->codecontext  }  |.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.

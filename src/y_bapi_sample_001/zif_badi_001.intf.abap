INTERFACE zif_badi_001
  PUBLIC .


  INTERFACES if_badi_interface.

*  TYPES :
*    BEGIN OF tx_contract,
*      MODIFY_FIELDCONTROLS TYPE if_abap_tx_functional=>ty,
*    END OF tx_contract.

  methods MODIFY_FIELDCONTROLS
   importing
      !DOCUMENTPROCESSINGMODE type SD_DOCUMENT_PROCESSING_MODE
      !SALESDOCUMENT type TDS_BD_SLS_HEAD
      !SALESDOCUMENT_EXTENSION type SDSALESDOC_INCL_EEW_PS
      !SALESDOCUMENTPARTNERS type TDT_BD_SLS_PARTNER optional
    changing
      !FIELD_PROPERTIES type TDT_BD_SLS_FIELD_PROPERTIES
    raising
      CX_BLE_RUNTIME_ERROR .

ENDINTERFACE.

FUNCTION zfm_001.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(IM_PARAM_1) TYPE  STRING OPTIONAL
*"     VALUE(IM_PARAM_2) TYPE  I DEFAULT 42
*"     REFERENCE(IM_PARAM_3) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(EX_PARAM_1) TYPE REF TO  STRING
*"     REFERENCE(EX_PARAM_2) TYPE  ANY
*"     VALUE(EX_PARAM_3) TYPE  ANY
*"     VALUE(EX_PARAM_4) TYPE  ANY
*"  CHANGING
*"     REFERENCE(CH_PARAM_1) TYPE  STRING
*"     VALUE(CH_PARAM_2) TYPE  I_CUSTABAPOBJDIRECTORYENTRY
*"  EXCEPTIONS
*"      EXCEPTIONS_1
*"----------------------------------------------------------------------
IF sy-subrc EQ 0.
    im_param_1  = 1.
ENDIF.

ENDFUNCTION.

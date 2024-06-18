@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] Header CDS View'
define root view entity ZR_FI_JE_HEADER
  as select from zfi_je_header
  composition [0..*] of ZR_FI_JE_ITEM as _Item
{
  key uuid                    as Uuid,
      referencedocumenttype   as ReferenceDocumentType,
      businesstransactiontype as BusinessTransactionType,
      accountingdocumenttype  as AccountingDocumentType,
      companycode             as CompanyCode,
      documentdate            as DocumentDate,
      postingdate             as PostingDate,
      document                as Document,
      ifmsg                   as IFMsg,
      ifstatus                as IFStatus,
      _Item
}

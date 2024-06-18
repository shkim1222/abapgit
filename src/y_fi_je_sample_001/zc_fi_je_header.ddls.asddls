@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] Header Projection View'
define root view entity ZC_FI_JE_HEADER provider contract transactional_query as projection on ZR_FI_JE_HEADER
{
    key Uuid,
    ReferenceDocumentType,
    BusinessTransactionType,
    AccountingDocumentType,
    CompanyCode,
    DocumentDate,
    PostingDate
}

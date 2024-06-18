@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] Item CDS View'
define view entity ZR_FI_JE_ITEM
  as select from zfi_je_item
  association to parent ZR_FI_JE_HEADER as _Header on _Header.Uuid = $projection.Uuid
{
  key itemuuid                    as Itemuuid,
      uuid                        as Uuid,
      glaccount                   as Glaccount,
      debitcreditcode             as Debitcreditcode,
      amountcurrency              as AmountCurrency,
      amountintransactioncurrency as Amountintransactioncurrency,
      documentitemtext            as Documentitemtext,
      costcenter                  as Costcenter,
      _Header
}

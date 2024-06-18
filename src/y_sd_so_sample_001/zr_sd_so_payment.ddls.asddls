@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[SD] Payment CDS View'
define view entity ZR_SD_SO_PAYMENT
  as select from zsd_so_payment
  association to parent ZR_SD_SO_HEADER as _Header on $projection.OrderUUID = _Header.OrderUUID
{
  key paymentuuid    as PaymentUUID,
      orderuuid      as OrderUUID,
      zsequence      as ZSequence,
      zpaymentmethod as ZPaymentMethod,
      zamount        as ZAmount,
      zcurrency      as ZCurrency,
      _Header // Make association public
}

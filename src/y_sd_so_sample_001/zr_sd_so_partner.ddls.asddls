@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[SD] Partner CDS View'
define view entity ZR_SD_SO_PARTNER
  as select from zsd_so_partner
  association to parent ZR_SD_SO_HEADER as _Header on $projection.OrderUUID = _Header.OrderUUID
{
  key partneruuid     as PartnerUUID,
      orderuuid       as OrderUUID,
      partnerfunction as PartnerFunction,
      customer        as Customer,
      _Header // Make association public
}

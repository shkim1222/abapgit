@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[SD] Item CDS View'
define view entity ZR_SD_SO_ITEM
  as select from zsd_so_item
    association to parent ZR_SD_SO_HEADER as _Header on
    $projection.OrderUUID = _Header.OrderUUID
{
  key itemuuid              as ItemUUID,
      orderuuid             as OrderUUID,
      salesorderitem        as SalesOrderItem,
      material              as Material,
      requestedquantity     as RequestedQuantity,
      requestedquantityunit as RequestedQuantityUnit,
      _Header // Make association public
}

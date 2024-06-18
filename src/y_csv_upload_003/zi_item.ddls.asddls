@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item CDS View'
define view entity Zi_Item as select from zitem
association to parent Zi_Header as _Header
    on $projection.OrderUuid = _Header.SoUuid 
{
    key item_uuid as ItemUuid,
    order_uuid as OrderUuid,
    
    @EndUserText.label: 'Item Line'
    salesorderitem as Salesorderitem,
    
    @EndUserText.label: 'Material'
    material as Material,
    
    @EndUserText.label: 'Requested Quantity'
    requestedquantity as Requestedquantity,
    
    @EndUserText.label: 'Requested Quantity Unit'
    requestedquantityunit as Requestedquantityunit,
    
    _Header.Lastchangedat as LastChangedat,
    _Header
}

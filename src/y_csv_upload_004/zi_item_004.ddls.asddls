@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item CDS View'
define view entity ZI_ITEM_004 as select from zitem_004
association to parent ZI_HEADER_004 as _Header
    on $projection.OrderUuid = _Header.SoUuid
association [0..1] to ZI_Att_004 as _Attachment on $projection.AttachId = _Attachment.AttachId
{
    key item_uuid as ItemUuid,
    order_uuid as OrderUuid,
    attach_id  as AttachId,
    
    @EndUserText.label: 'Item Line'
    salesorderitem as Salesorderitem,
    
    @EndUserText.label: 'Material'
    material as Material,
        
    @EndUserText.label: 'Requested Quantity'
    requestedquantity as Requestedquantity,
   
    @EndUserText.label: 'Requested Quantity Unit'
    requestedquantityunit as Requestedquantityunit,
    
    _Header,
    _Header.LastChangedat as Lastchangedat,
    _Attachment
}

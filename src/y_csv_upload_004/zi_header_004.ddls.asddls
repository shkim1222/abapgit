@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header CDS View'
define view entity ZI_HEADER_004 as select from zheader_004
association to parent ZI_Att_004 as _Attachment
    on $projection.AttachId = _Attachment.AttachId
composition [1..*] of ZI_ITEM_004 as _Items    
    
{
@EndUserText.label: 'Sales Order ID'
    key so_uuid as SoUuid,
    attach_id as AttachId,
    
    @EndUserText.label: 'Salesordertype'
    salesordertype as Salesordertype,
    
    @EndUserText.label: 'Salesorganization'
    salesorganization as Salesorganization,
    
    @EndUserText.label: 'Distributionchannel'
    distributionchannel as Distributionchannel,
    
    @EndUserText.label: 'Soldtoparty'
    soldtoparty as Soldtoparty,
    
    lastchangedat as Header_Lastchangedat,
    locallastchangedat as Locallastchangedat    ,
    
    _Attachment,
    _Attachment.Lastchangedat as LastChangedat,
    
    _Items
}

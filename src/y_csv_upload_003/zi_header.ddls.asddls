@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header CDS View'
define root view entity Zi_Header as select from zheader
composition [1..*] of Zi_Item as _Items 
composition [1..*] of Zi_Attachment as _Attachments
{
    @EndUserText.label: 'Sales Order ID'
    key so_uuid as SoUuid,
    
    @EndUserText.label: 'Salesordertype'
    salesordertype as Salesordertype,
    
    @EndUserText.label: 'Salesorganization'
    salesorganization as Salesorganization,
    
    @EndUserText.label: 'Distributionchannel'
    distributionchannel as Distributionchannel,
    
    @EndUserText.label: 'Soldtoparty'
    soldtoparty as Soldtoparty,
    
    lastchangedat as Lastchangedat,
    locallastchangedat as Locallastchangedat,    
    
    _Items,
    _Attachments
}

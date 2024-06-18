@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'unmanaged view'
@Metadata.allowExtensions: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_DEMO_UNMANAGED_QUERY'
define root view entity ZR_UNMANAGED_002 as select from zunmanaged_002
{
    @EndUserText.label: 'uuid'
    key uuid,
      
    @EndUserText.label: 'text'
    text,
    
    @EndUserText.label: 'cdate'
    cdate
}

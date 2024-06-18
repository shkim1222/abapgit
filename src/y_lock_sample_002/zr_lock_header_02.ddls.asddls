@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LOCK  HEADER CDS VIEW'
define root view entity ZR_LOCK_HEADER_02
  as select from zlock_header_02
{
    @EndUserText.label: 'UUID'
    key uuid as Uuid,
    @EndUserText.label: 'Name'
    name as Name,
    @EndUserText.label: 'Age'
    age as Age,
    
    @Semantics.systemDateTime.lastChangedAt: true 
    lastchangedat as Lastchangedat,
    
    @Semantics.systemDateTime.localInstanceLastChangedAt: true 
    locallastchangedat as Locallastchangedat,
    
    @EndUserText.label: 'Flag'
    flag

}

@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZTABLE_001'
define root view entity ZR_TABLE_001
  as select from ztable_001
{
  key uuid as UUID,
  name as Name,
  age as Age,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchanged as Locallastchanged,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchanged as Lastchanged
  
}

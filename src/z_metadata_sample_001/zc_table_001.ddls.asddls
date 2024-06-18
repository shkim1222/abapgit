@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TABLE_001'
define root view entity ZC_TABLE_001
  provider contract transactional_query
  as projection on ZR_TABLE_001
{
  key UUID,
  Name,
  Age,
  Locallastchanged
  
}

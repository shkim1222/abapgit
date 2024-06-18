@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'unmanaged cds view'
define root view entity ZR_UNMANAGED_001 as select from zunmanaged_001
{
    @EndUserText.label: 'uuid'
    key uuid as Uuid,
    
    @EndUserText.label: 'name'
    name as Name,
    
    @EndUserText.label: 'age'
    age as Age
}

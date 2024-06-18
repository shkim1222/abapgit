@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'header'
define root view entity ZR_HEADER_001 as select from zheader_001
{
    key uuid as Uuid,
    name as Name,
    age as Age
}

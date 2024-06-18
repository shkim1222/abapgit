@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'header cds view'
define root view entity ZR_EDU_HEADER_01 as select from zedu_header_01
{
    key uuid as Uuid,
    name as Name,
    age as Age
}

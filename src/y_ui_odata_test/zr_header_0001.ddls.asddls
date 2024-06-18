@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'header'
define root view entity ZR_HEADER_0001 as select from zheader_0001
composition [1..*] of ZR_ITEM_0001 as _Item 
{
    key uuid as Uuid,
    name as Name,
    age as Age,
    create_by_user as CreateByUser,
    create_by_date as CreateByDate,
    update_by_user as UpdateByUser,
    update_by_date as UpdateByDate,
    _Item
}

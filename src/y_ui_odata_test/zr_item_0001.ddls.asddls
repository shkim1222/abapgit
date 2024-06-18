@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'item'
define view entity ZR_ITEM_0001 as select from zitem_0001
association to parent ZR_HEADER_0001 as _Header on _Header.Uuid = $projection.HeaderUuid
{
    key uuid as Uuid,
    header_uuid as HeaderUuid,
    school as School,
    reg_date as RegDate,
    end_date as EndDate,
    _Header
}

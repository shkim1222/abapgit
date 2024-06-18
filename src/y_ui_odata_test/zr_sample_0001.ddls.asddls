@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sample'
define root view entity ZR_SAMPLE_0001 as select from ztest_001
{
    key uuid as Uuid,
    order_id as OrderId
}

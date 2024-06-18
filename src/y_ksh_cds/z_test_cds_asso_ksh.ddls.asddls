@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '테이블 연관 cds view'
define view entity Z_Test_Cds_Asso_Ksh as select from ztest_master_ksh
association [0..1] to ztest_item1_ksh as _item1 on $projection.Tkey = _item1.tkey
association [0..1] to ztest_item2_ksh as _item2 on $projection.Tkey = _item2.tkey
{
    key ztest_master_ksh.tkey as Tkey,
    ztest_master_ksh.total_name as TotalName,
    ztest_master_ksh.total_amount as TotalAmount,
    ztest_master_ksh.total_cuky as TotalCuky,
    _item1,
    _item2
  
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '학과 CDS View'
define root view entity ZR_DEPART_001 as select from zedu_depart_001
{
    @EndUserText.label: '학과 UUID'
    key uuid as Uuid,
    
    @EndUserText.label: '학과 코드'
    dept_code as DeptCode,
    
    @EndUserText.label: '학과 명칭'
    dept_desc as DeptDesc,
    
    @EndUserText.label: '시작년월'
    str_date as StrDate,
    
    @EndUserText.label: '종료년월'
    end_date as EndDate
}

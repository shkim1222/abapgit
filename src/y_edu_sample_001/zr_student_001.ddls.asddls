@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '학생 CDS View'
define root view entity ZR_STUDENT_001 as select from zedu_student_001
{
    @EndUserText.label: '학생 UUID'
    key uuid as Uuid,
    @EndUserText.label: '학번'
    stud_code as StudCode,
    stud_numb as StudNumb,
    @EndUserText.label: '이름'
    stud_desc as StudDesc,
    @EndUserText.label: '입학년월'
    str_date as StrDate,
    @EndUserText.label: '졸업년월'
    end_date as EndDate,
    @EndUserText.label: '학과'
    stud_dept_desc as StudDeptDesc,
    stud_dept_code as StudDeptCode
    
}

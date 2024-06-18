@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Entity for Student'
define root view entity zstudent_hdr_tab_I as select from zstudent_hdr_tab
composition[1..*] of zstudent_att_tab_i as _Attachments 
{
    @EndUserText.label: 'Student ID'
    key zstudent_hdr_tab.id as Id,
    @EndUserText.label: 'First Name'
    zstudent_hdr_tab.firstname as Firstname,
    @EndUserText.label: 'Last Name'
    zstudent_hdr_tab.lastname as Lastname,
    @EndUserText.label: 'Age'
    zstudent_hdr_tab.age as Age,
    @EndUserText.label: 'Course'
    zstudent_hdr_tab.course as Course,
    @EndUserText.label: 'Course Duration'
    zstudent_hdr_tab.courseduration as Courseduration,
    @EndUserText.label: 'Status'
    zstudent_hdr_tab.status as Status,
    @EndUserText.label: 'Gender'
    zstudent_hdr_tab.gender as Gender,
    @EndUserText.label: 'DOB'
    
    zstudent_hdr_tab.dob as Dob,
    zstudent_hdr_tab.lastchangedat as Lastchangedat,
    zstudent_hdr_tab.locallastchangedat as Locallastchangedat,
    
    
    _Attachments // Make association public
}

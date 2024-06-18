@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '학생 Projection View'
define root view entity ZC_STUDENT_001 as projection on ZR_STUDENT_001
{
    @UI.facet: 
    [
        {
           id: 'Student_Info',
           purpose: #STANDARD,
           label: '학생 마스터',
           type: #IDENTIFICATION_REFERENCE,
           position: 10
        }
    ]
      
    @UI: {
       lineItem: [{position: 10 }]
    } 
    key Uuid,
    @UI: {
       lineItem: [{position: 20 }]
    }
    StudCode,
    @UI: {
       lineItem: [{position: 30 }],
       identification: [{ position: 10 }]
    }
    StudDesc,
    @UI: {
       lineItem: [{position: 40 }],
       identification: [{ position: 20 }]
    }
    StrDate,
    @UI: {
       lineItem: [{position: 50 }],
       identification: [{ position: 30 }]
    }
    EndDate,
    StudDeptCode,
    @UI: {
       lineItem: [{position: 60 }],
       identification: [{ position: 40 }]
    }
    @Consumption.valueHelpDefinition: [{ entity:{ name : 'ZC_DEPART_001', element : 'DeptDesc'} ,additionalBinding: [{ element : 'DeptCode', localElement: 'StudDeptCode' }] 
    }]
    StudDeptDesc
}

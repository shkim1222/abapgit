@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '학과 Projection VIew'
define root view entity ZC_DEPART_001
  as projection on ZR_DEPART_001
{

      @UI.facet: 
      [
          {
               id: 'Department_Info',
               purpose: #STANDARD,
               label: '학과 마스터',
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
      DeptCode,
      @UI: {
             lineItem: [{position: 30 }],
               identification: [{ position: 10 }]   
      }
      DeptDesc,
      @UI: {
             lineItem: [{position: 40 }],
               identification: [{ position: 20 }]   
      }
      StrDate,
      @UI: {
        lineItem: [{position: 50 }],
               identification: [{ position: 30 }]   
      }
      EndDate
}

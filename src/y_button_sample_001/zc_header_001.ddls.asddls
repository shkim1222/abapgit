@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'header'
define root view entity ZC_HEADER_001 provider contract transactional_query as projection on ZR_HEADER_001
{
       @UI: {
          selectionField: [{ position: 10 }],
          lineItem: [{ position: 10 }, { type: #FOR_ACTION, dataAction: 'Upload', label: '파일 업로드' }]
       }
    key Uuid,
    
     @UI: {
        lineItem: [{position: 20 }]
       }
       Name,
     @UI: {
        lineItem: [{position: 30 }]
       }
       
    Age
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LOCK HEADER Projection View'
define root view entity ZC_LOCK_HEADER_02
  provider contract transactional_query
  as projection on ZR_LOCK_HEADER_02
{
 @UI.facet: [{
         id: 'HeaderData',
         purpose: #STANDARD,
         label: 'Item Information',
         type: #IDENTIFICATION_REFERENCE,
         position: 10
    }]
     
         @UI: {
        lineItem: [{position: 10 }],
        identification: [{position: 10 }]
    }  
      key Uuid,

    @UI: {
        lineItem: [{position: 20 }],
        identification: [{position: 20 }]
    }  
      Name,

    @UI: {
        lineItem: [{position: 30 }],
        identification: [{position: 30 }]
    }  
      Age,
      
    @UI: {
        lineItem: [{position: 40 }],
        identification: [{position: 40 }]
    }  
      Lastchangedat,
      
      
    @UI: {
        lineItem: [{position: 50 }],
        identification: [{position: 50 }]
    }  
      Locallastchangedat,
      
    @UI: {
        lineItem: [{position: 60 }],
        identification: [{position: 60 }]
    }   
    flag
}

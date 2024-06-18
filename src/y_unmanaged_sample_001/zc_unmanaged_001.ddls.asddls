@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'unmanaged projection view'
@Metadata.allowExtensions: true
define root view entity ZC_UNMANAGED_001 provider contract transactional_query as projection on ZR_UNMANAGED_001
{

   @UI: {
        lineItem: [{position: 10 }]
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

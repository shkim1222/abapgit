@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds view'
@Metadata.allowExtensions: true

@ObjectModel.query.implementedBy: 'ABAP:ZCL_DEMO_UNMANAGED_QUERY'
//define root view entity ZC_UNMANAGED_002 provider contract transactional_query as projection on ZR_UNMANAGED_002
define root view entity ZC_UNMANAGED_002 as projection on ZR_UNMANAGED_002
{
     @UI: {
        lineItem: [{position: 10 }]
    }  
    key uuid,     
   
    @UI: {
        lineItem: [{position: 20 }]
    }  
     text,    
    
     @UI: {
        lineItem: [{position: 30 }]
    }  
     cdate
}

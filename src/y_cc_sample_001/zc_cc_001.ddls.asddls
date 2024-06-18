@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cc projection view'
define root view entity ZC_CC_001 provider contract transactional_query as projection on ZI_CC_001
{
    key Uuid,
    
    //@Semantics.systemDateTime.createdAt: true       
    Createdat,
    
    //@Semantics.systemDateTime.localInstanceLastChangedAt: true
    Localinstancelastchangedat
}

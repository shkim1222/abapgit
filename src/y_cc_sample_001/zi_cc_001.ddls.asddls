
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cc cds view'
define root view entity ZI_CC_001 as select from zcc_001
{
    key uuid as Uuid,
    
    //@Semantics.user.createdBy: true 
    //createby as Createby,
    
    @Semantics.systemDateTime.createdAt: true       
    createdat as Createdat,
    
    //@Semantics.user.lastChangedBy: true    
    //lastchangedby as Lastchangedby,
    
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    localinstancelastchangedat as Localinstancelastchangedat
}

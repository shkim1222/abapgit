@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Projection View'
define view entity ZC_ITEM_004  as projection on  ZI_ITEM_004
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
    key ItemUuid,
    
    @UI: {
        lineItem: [{position: 20 }],
        identification: [{position: 20 }]
    }
    OrderUuid,
    
    @UI: {
        lineItem: [{position: 30 }],
        identification: [{position: 30 }]
    }
    AttachId,
    
    @UI: {
        lineItem: [{position: 40 }],
        identification: [{position: 40 }]
    }
    Salesorderitem,
    
    @UI: {
        lineItem: [{position: 50 }],
        identification: [{position: 50 }]
    }
    Material,
    
    @UI: {
        lineItem: [{position: 60 }],
        identification: [{position: 60 }]
    }
    Requestedquantity,
    
    @UI: {
        lineItem: [{position: 60 }],
        identification: [{position: 60 }]
    }
    Requestedquantityunit,
    
    @UI: {
        lineItem: [{position: 70 }],
        identification: [{position: 70 }]
    }
    Lastchangedat,
       
    /* Associations */
    _Header :  redirected to parent ZC_HEADER_004,
    _Attachment : redirected to ZC_ATT_004
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'header projection View'
define view entity ZC_HEADER_004 as projection on ZI_HEADER_004
{
    @UI.facet: 
    [
        {
             id: 'Attachment',
             purpose: #STANDARD,
             label: 'Item Information',
             type: #IDENTIFICATION_REFERENCE,
             position: 10
        },
        {
             id: 'Items',
             purpose: #STANDARD,
             label: 'Items',
             type: #LINEITEM_REFERENCE,
             position: 20,
             targetElement: '_Items'
        }
    ]
    @UI: {
            lineItem: [{position: 10 }],
            identification: [{position: 10 }]
    }
    key SoUuid,
    
    @UI: {
            lineItem: [{position: 20 }],
            identification: [{position: 20 }]
    }
    AttachId,
    
    @UI: {
            lineItem: [{position: 30 }],
            identification: [{position: 30 }]
    }
    Salesordertype,
    
    @UI: {
            lineItem: [{position: 40 }],
            identification: [{position: 40 }]
    }
    Salesorganization,
    
    @UI: {
            lineItem: [{position: 50 }],
            identification: [{position: 50 }]
    }
    Distributionchannel,
    Soldtoparty,
    
    @UI: {
            lineItem: [{position: 60 }],
            identification: [{position: 60 }]
    }
    LastChangedat,
    
    @UI: {
            lineItem: [{position: 70 }],
            identification: [{position: 70 }]
    }
    Locallastchangedat,
    
    /* Associations */
    _Attachment : redirected to parent ZC_ATT_004,    
    _Items : redirected to composition child ZC_ITEM_004
}

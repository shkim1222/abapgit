@EndUserText.label: 'Projection for Attachment'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity zc_item
  as projection on Zi_Item
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
        Salesorderitem,
        
        @UI: {
            lineItem: [{position: 40 }],
            identification: [{position: 40 }]
        }
        Material,
        
        @UI: {
            lineItem: [{position: 50 }],
            identification: [{position: 50 }]
        }
        Requestedquantity,
        
        @UI: {
            lineItem: [{position: 60 }],
            identification: [{position: 60 }]
        }
        Requestedquantityunit,        

         /* Associations */
         _Header : redirected to parent zc_header

}

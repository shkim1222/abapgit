@EndUserText.label: 'Projection view for Header table'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity zc_header
  provider contract transactional_query
  as projection on Zi_Header
{
      @UI.facet: [{
           id: 'HeaderData',
           purpose: #STANDARD,
           label: 'Header Data',
           type: #IDENTIFICATION_REFERENCE,
           position: 10
       }
       ,
       {
           id: 'Items',
           purpose: #STANDARD,
           label: 'Items',
           type: #LINEITEM_REFERENCE,
           position: 20,
           targetElement: '_Items'
       }
       ,
       {
           id: 'Atts',
           purpose: #STANDARD,
           label: 'Attachments',
           type: #LINEITEM_REFERENCE,
           position: 30,
           targetElement: '_Attachments'
       }
       ]
       
       @UI: {
          selectionField: [{ position: 10 }],
          lineItem: [{ position: 10 }],
          identification: [{ position: 10 }]   
       }
       key SoUuid,
       
       @UI: {
        lineItem: [{position: 20 }],
        identification: [{position: 20 }]
       }
       Salesordertype,
       
       @UI: {
        lineItem: [{position: 30 }],
        identification: [{position: 30 }]
       }       
       Salesorganization,
       
       @UI: {
        lineItem: [{position: 40 }],
        identification: [{position: 40 }]
       }
       Distributionchannel,
              
       @UI: {
        lineItem: [{position: 50 }],
        identification: [{position: 50 }]
       }
       Soldtoparty,    
       
       Lastchangedat,
       Locallastchangedat,
       
       /* Associations */
       _Items : redirected to composition child zc_item,
       _Attachments : redirected to composition child zc_attachment
}

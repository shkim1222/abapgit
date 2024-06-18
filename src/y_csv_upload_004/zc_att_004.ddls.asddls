@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment Projection View'
define root view entity ZC_ATT_004 provider contract transactional_query
  as projection on ZI_Att_004
{
      @UI.facet: 
      [
          {
               id: 'Attachment',
               purpose: #STANDARD,
               label: 'Attachment Info',
               type: #IDENTIFICATION_REFERENCE,
               position: 10
           }
           ,
           {
               id: 'Header',
               purpose: #STANDARD,
               label: 'Headers',
               type: #LINEITEM_REFERENCE,
               position: 20,
               targetElement: '_Header'
           }
       ]
    
       @UI: {
          selectionField: [{ position: 10 }],
          lineItem: [{ position: 10 }, { type: #FOR_ACTION, dataAction: 'Upload', label: '파일 업로드' }],
          identification: [{ position: 10 }]   
       }
       key AttachId,
       
       @UI: {
        lineItem: [{position: 20 }],
        identification: [{position: 20 }]
       }
       Comments,
       
       @UI: {
        lineItem: [{position: 30 }],
        identification: [{position: 30 }]
       }
       Attachment,
       
       @UI: {
        lineItem: [{position: 40 }],
        identification: [{position: 40 }]
       }
       Mimetype,
       
       @UI: {
        lineItem: [{position: 50 }],
        identification: [{position: 50 }]
       }
       Filename,
       
       @UI: {
        lineItem: [{position: 60 }],
        identification: [{position: 60 }]
       }
       Lastchangedat,
       
       @UI: {
        lineItem: [{position: 70 }],
        identification: [{position: 70 }]
       }
       Locallastchangedat,
       
       @UI: {
        lineItem: [{position: 80 }],
        identification: [{position: 80 }]
       }
       Status,
        
       /* Associations */
       _Header : redirected to composition child ZC_HEADER_004
}

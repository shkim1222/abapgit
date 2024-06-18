@EndUserText.label: 'Projection for Attachment'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity zc_attachment
  as projection on Zi_Attachment
{

        @UI.facet: [{
             id: 'HeaderData',
             purpose: #STANDARD,
             label: 'Attachments Information',
             type: #IDENTIFICATION_REFERENCE,
             position: 10
         }]
         
         @UI: {
            lineItem: [{position: 10 }, { type: #FOR_ACTION, dataAction: 'Upload', label: '파일 업로드' }],
            identification: [{position: 10 }]
         }
         key AttachId,
        
         @UI: {
            lineItem: [{position: 10 }],
            identification: [{position: 10 }]
         }
         OrderUuid,
        
         @UI: {
            lineItem: [{position: 10 }],
            identification: [{position: 10 }]
         }
         Comments,
        
         @UI: {
            lineItem: [{position: 10 }],
            identification: [{position: 10 }]
         }
         Attachment,
        
         @UI: {
            lineItem: [{position: 10 }],
            identification: [{position: 10 }]
         }
         Mimetype,
        
         @UI: {
            lineItem: [{position: 10 }],
            identification: [{position: 10 }]
         }
         Filename,

         /* Associations */
         _Header : redirected to parent zc_header
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment CDS View'
define root view entity ZI_Att_004 as select from zatt_004
composition [1..*] of ZI_HEADER_004 as _Header
{
    key attach_id as AttachId,
    
    @EndUserText.label: 'Comments'
    comments as Comments,
    
    @EndUserText.label: 'Attachments'
    @Semantics.largeObject:{
        mimeType: 'Mimetype',
        fileName: 'Filename',
        contentDispositionPreference: #INLINE
    }
    attachment as Attachment,
    
    @EndUserText.label: 'File Type'
    mimetype as Mimetype,
    
    @EndUserText.label: 'File Name'
    filename as Filename,
    
    lastchangedat as Lastchangedat,
    locallastchangedat as Locallastchangedat,
    
    @EndUserText.label: 'Upload Status'
    status as Status,
    
    _Header
}

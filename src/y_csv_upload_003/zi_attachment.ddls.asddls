@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment CDS View'
define view entity Zi_Attachment as select from zattachment2
association to parent Zi_Header as _Header
    on $projection.OrderUuid = _Header.SoUuid 
{
    key zattachment2.attach_id as AttachId,
    zattachment2.order_uuid as OrderUuid,
    
    @EndUserText.label: 'Comments'
    zattachment2.comments as Comments,
    
    @EndUserText.label: 'Attachments'
    @Semantics.largeObject:{
        mimeType: 'Mimetype',
        fileName: 'Filename',
        contentDispositionPreference: #INLINE
    }
    zattachment2.attachment as Attachment,
    
    @EndUserText.label: 'File Type'
    zattachment2.mimetype as Mimetype,
    
    @EndUserText.label: 'File Name'
    zattachment2.filename as Filename,
    
    _Header.Lastchangedat as LastChangedat,
    _Header
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Attachment'
define view entity zstudent_att_tab_i as select from zstudent_att_tab
association to parent zstudent_hdr_tab_I as _Student
    on $projection.Id = _Student.Id 
{
    
    key zstudent_att_tab.attach_id as AttachId,
    zstudent_att_tab.id as Id,
    @EndUserText.label: 'Comments'
    zstudent_att_tab.comments as Comments,
    
    @EndUserText.label: 'Attachments'
    @Semantics.largeObject:{
        mimeType: 'Mimetype',
        fileName: 'Filename',
        contentDispositionPreference: #INLINE
    }
    zstudent_att_tab.attachment as Attachment,
    @EndUserText.label: 'File Type'
    zstudent_att_tab.mimetype as Mimetype,
    @EndUserText.label: 'File Name'
    zstudent_att_tab.filename as Filename,
    
    _Student.Lastchangedat as LastChangedat,
    _Student // Make association publi
}

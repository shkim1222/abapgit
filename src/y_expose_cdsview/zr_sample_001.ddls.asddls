@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'dd'
@AbapCatalog.extensibility: {
  extensible: true,
  elementSuffix: 'YYY',
  allowNewDatasources: false,
  dataSources: ['Persistence'],
  quota: {
    maximumFields: 250,
    maximumBytes: 2500
  }
}

define root view entity Zr_Sample_001 as select from ztsample_001 as Persistence
{
key uuid as Uuid,
name as Name,
age as Age
}

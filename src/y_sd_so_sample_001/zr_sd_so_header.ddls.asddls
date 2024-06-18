@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[SD] Header CDS View'
define root view entity ZR_SD_SO_HEADER
  as select from zsd_so_header
  composition [0..*] of ZR_SD_SO_ITEM    as _Item
  composition [0..*] of ZR_SD_SO_PARTNER as _Partner
  composition [0..*] of ZR_SD_SO_PAYMENT as _Payment
{
  key orderuuid                 as OrderUUID,
      senderbusinesssystemname  as SenderBusinessSystemName,
      purchaseorderbycustomer   as PurchaseOrderByCustomer,
      salesordertype            as SalesOrderType,
      salesorganization         as SalesOrganization,
      distributionchannel       as DistributionChannel,
      soldtoparty               as SoldToParty,
      requesteddeliverydate     as RequestedDeliveryDate,
      customerpurchaseorderdate as CustomerPurchaseOrderDate,
      salesorderdate            as SalesOrderDate,
      conditiontype             as ConditionType,
      conditionratevalue        as ConditionRateValue,
      conditioncurrency         as ConditionCurrency,
      ifstatus                  as IFStatus,
      zsalesorder               as ZSalesOrder,
      ifmsg                     as IFMsg,
      _Item,
      _Partner,
      _Payment
}

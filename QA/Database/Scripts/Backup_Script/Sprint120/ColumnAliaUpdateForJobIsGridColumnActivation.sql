 Update [dbo].[SYSTM000ColumnsAlias] set IsGridColumn = 1
  where ColTableName = 'job' and ColColumnName in (
  'Id',
  'JobCarrierContract',
  'JobCustomerPurchaseOrder'
  )
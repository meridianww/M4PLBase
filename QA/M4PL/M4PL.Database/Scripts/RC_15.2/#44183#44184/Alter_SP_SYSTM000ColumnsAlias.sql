 UPDATE [dbo].[SYSTM000ColumnsAlias]
  SET ColAliasName = 'Vendor Role', ColCaption = 'Vendor Role', ColIsVisible = 1
  WHERE ColTableName = 'VendDcLocationContact' and ColColumnName = 'ConCodeId'

   UPDATE [dbo].[SYSTM000ColumnsAlias]
  SET ColIsVisible = 0
  WHERE ColTableName = 'VendDcLocationContact' and ColColumnName = 'ConTableTypeId'
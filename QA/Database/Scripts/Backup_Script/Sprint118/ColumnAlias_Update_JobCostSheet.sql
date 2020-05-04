
  update [M4PL_DEV].[dbo].[SYSTM000ColumnsAlias] set ColAliasName='Price', ColCaption = 'price' where ColTableName like 'JobCostSheet' and ColAliasName = 'Cost'
  
  update [M4PL_DEV].[dbo].[SYSTM000ColumnsAlias] set ColAliasName='Billable Rate', ColCaption = 'Billable Rate' where ColTableName like 'JobCostSheet' and ColAliasName = 'Cost Rate'
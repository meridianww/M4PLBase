UPDATE SYSTM000ColumnsAlias SET ColIsVisible = 0 Where ColTableName='JobBillableSheet' AND ColColumnName IN ('PrcSurchargeOrder',
'PrcSurchargePercent',
'PrcNumberUsed',
'PrcDuration',
'PrcAmount',
'PrcMarkupPercent')

UPDATE SYSTM000ColumnsAlias SET ColIsVisible = 0 Where ColTableName='JobCostSheet' AND ColColumnName IN (
'CstSurchargeOrder',
'CstSurchargePercent',
'CstNumberUsed',
'CstDuration',
'CstAmount',
'CstMarkupPercent'
)

 UPDATE [dbo].[SYSTM000Ref_Options] SET SysDefault = 0 Where SysLookupCode='RateType' AND SysOptionName='Expression(Delivery)'

UPDATE SYSTM000ColumnsAlias SET ColIsReadOnly = 1 Where ColTableName='JobBillableSheet' AND ColColumnName <> 'PrcQuantity'
UPDATE SYSTM000ColumnsAlias SET ColIsReadOnly = 1 Where ColTableName='JobCostSheet' AND ColColumnName <> 'CstQuantity'

UPDATE SYSTM000ColumnsAlias SET ColAliasName = 'Billable Rate', ColCaption = 'Billable Rate' Where ColTableName='JobBillableSheet' AND ColColumnName='PrcRate'
UPDATE SYSTM000ColumnsAlias SET ColLookupId = 46, ColLookupCode = 'UnitType', ColAliasName = 'Unit Type', ColCaption = 'Unit Type' Where ColTableName='JobBillableSheet' AND ColColumnName='PrcUnitId'
UPDATE SYSTM000ColumnsAlias SET ColLookupId = 46, ColLookupCode = 'UnitType', ColAliasName = 'Unit Type', ColCaption = 'Unit Type' Where ColTableName='JobCostSheet' AND ColColumnName='CstUnitId'

ALTER TABLE [dbo].[JOBDL061BillableSheet] DROP CONSTRAINT [FK_BillableSheet_JobMaster]
GO

ALTER TABLE [dbo].[JOBDL062CostSheet] DROP CONSTRAINT [FK_CostSheet_JobMaster]
GO

ALTER TABLE [dbo].[JOBDL061BillableSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL061BillableSheet_PrcUnitId] FOREIGN KEY([PrcUnitId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] CHECK CONSTRAINT [FK_JOBDL061BillableSheet_PrcUnitId]
GO

ALTER TABLE [dbo].[JOBDL062CostSheet]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL062CostSheet_CstUnitId] FOREIGN KEY([CstUnitId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL062CostSheet] CHECK CONSTRAINT [FK_JOBDL062CostSheet_CstUnitId]
GO

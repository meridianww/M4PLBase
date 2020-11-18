ALTER TABLE dbo.NAV000JobPurchaseOrderMapping ADD [JobId] [bigint]
ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping]  WITH CHECK ADD  CONSTRAINT [FK_NAV000JobPurchaseOrderMapping_JOBDL000Master] FOREIGN KEY([JobId])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO

ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping] CHECK CONSTRAINT [FK_NAV000JobPurchaseOrderMapping_JOBDL000Master]
GO

ALTER TABLE NAV000JobPurchaseOrderMapping
ALTER COLUMN JobSalesOrderMappingId BIGINT NULL


UPDATE PO
SET PO.JobId = SO.JobId
FROM [dbo].[NAV000JobPurchaseOrderMapping] PO
INNER JOIN dbo.NAV000JobSalesOrderMapping SO ON SO.JobSalesOrderMappingId = PO.JobSalesOrderMappingId


ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping] DROP CONSTRAINT [FK_NAV000JobPurchaseOrderMapping_NAV000JobSalesOrderMapping]
GO

ALTER TABLE NAV000JobSalesOrderMapping ADD IsParentOrder BIT
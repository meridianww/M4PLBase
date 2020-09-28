ALTER TABLE dbo.NAV000JobPurchaseOrderMapping ADD [JobId] [bigint]
ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping]  WITH CHECK ADD  CONSTRAINT [FK_NAV000JobPurchaseOrderMapping_JOBDL000Master] FOREIGN KEY([JobId])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO

ALTER TABLE [dbo].[NAV000JobPurchaseOrderMapping] CHECK CONSTRAINT [FK_NAV000JobPurchaseOrderMapping_JOBDL000Master]
GO

CREATE NONCLUSTERED INDEX IX_JOBDL000Master_JobCustomerSalesOrder
ON [dbo].[JOBDL000Master] ([JobCustomerSalesOrder])
INCLUDE ([Id])
GO


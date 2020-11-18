
CREATE NONCLUSTERED INDEX IX_JobId_StatusId
ON [dbo].[JOBDL070ElectronicDataTransactions] ([JobId])
INCLUDE ([StatusId])

CREATE NONCLUSTERED INDEX IX_JobId_EdtCode_EdtTitle_StatusId_EdtDate_EdtTypeId_TransactionDate
ON [dbo].[JOBDL070ElectronicDataTransactions] ([JobId])
INCLUDE ([EdtCode],[EdtTitle],[StatusId],[EdtData],[EdtTypeId],[TransactionDate])

CREATE NONCLUSTERED INDEX IX_JOBDL061BillableSheet_JobId_StatusId
ON [dbo].[JOBDL061BillableSheet] ([JobID],[StatusId])

CREATE NONCLUSTERED INDEX IX_JOBDL062CostSheet_JobId_StatusId
ON [dbo].[JOBDL062CostSheet] ([JobID],[StatusId])


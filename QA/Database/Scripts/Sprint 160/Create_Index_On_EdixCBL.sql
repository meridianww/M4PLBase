
CREATE NONCLUSTERED INDEX IX_JobId_StatusId
ON [dbo].[JOBDL070ElectronicDataTransactions] ([JobId])
INCLUDE ([StatusId])

CREATE NONCLUSTERED INDEX IX_JobId_EdtCode_EdtTitle_StatusId_EdtDate_EdtTypeId_TransactionDate
ON [dbo].[JOBDL070ElectronicDataTransactions] ([JobId])
INCLUDE ([EdtCode],[EdtTitle],[StatusId],[EdtData],[EdtTypeId],[TransactionDate])



CREATE NONCLUSTERED INDEX IX_JOBDL020Gateways_GwyGatewayCode
ON [dbo].[JOBDL020Gateways] ([GwyGatewayCode])
INCLUDE ([JobID],[GwyGatewayACD])

CREATE NONCLUSTERED INDEX IX_JOBDL010Cargo_JobId_StatusId
ON [dbo].[JOBDL010Cargo] ([JobID],[StatusId])
INCLUDE ([CgoQtyOnHand],[CgoPackagingTypeId],[CgoQtyUnitsId])

CREATE NONCLUSTERED INDEX IX_JOBDL000Master_JobSiteCode
ON [dbo].[JOBDL000Master] ([JobSiteCode])
INCLUDE ([Id],[ProgramID],[IsCancelled])
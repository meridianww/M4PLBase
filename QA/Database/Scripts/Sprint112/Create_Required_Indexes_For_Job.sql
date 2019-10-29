CREATE NONCLUSTERED INDEX IX_JOBDL000Master_StatusId
ON [dbo].[JOBDL000Master] ([StatusId])
INCLUDE ([ProgramID])
GO

CREATE NONCLUSTERED INDEX IX_JOBDL010Cargo_CgoQtyUnits_StatusId
ON [dbo].[JOBDL010Cargo] ([CgoQtyUnits],[StatusId])
INCLUDE ([JobID])
GO

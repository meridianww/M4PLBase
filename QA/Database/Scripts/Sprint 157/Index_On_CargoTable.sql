
CREATE NONCLUSTERED INDEX IX_Cargo_CgoQtyUnitsId
ON [dbo].[JOBDL010Cargo] ([CgoQtyUnitsId])
INCLUDE ([JobID],[CgoSerialNumber],[CgoQtyExpected],[CgoQtyOnHand],[CgoQtyOnHold],[CgoQtyOrdered])
GO

CREATE NONCLUSTERED INDEX IX_JobID_StatusId
ON [dbo].[JOBDL010Cargo] ([JobID],[StatusId])
INCLUDE ([CgoSerialNumber],[CgoQtyExpected],[CgoQtyOnHand],[CgoQtyOnHold],[CgoQtyOrdered],[CgoQtyUnitsId])
GO

CREATE NONCLUSTERED INDEX IX_JOBDL010Cargo_JobId_StatusId_UnitsId
ON [dbo].[JOBDL010Cargo] ([JobID],[StatusId],[CgoQtyUnitsId])
INCLUDE ([CgoSerialNumber],[CgoQtyExpected],[CgoQtyOnHand],[CgoQtyOnHold],[CgoQtyOrdered])
GO


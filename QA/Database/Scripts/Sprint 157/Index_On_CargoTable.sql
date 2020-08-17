
CREATE NONCLUSTERED INDEX IX_Cargo_CgoQtyUnitsId
ON [dbo].[JOBDL010Cargo] ([CgoQtyUnitsId])
INCLUDE ([JobID],[CgoSerialNumber],[CgoQtyExpected],[CgoQtyOnHand],[CgoQtyOnHold],[CgoQtyOrdered])
GO


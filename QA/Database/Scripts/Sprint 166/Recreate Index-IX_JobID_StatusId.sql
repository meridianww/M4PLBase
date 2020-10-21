USE [M4PL_Test]
GO

/****** Object:  Index [IX_JobID_StatusId]    Script Date: 10/20/2020 3:17:37 PM ******/
DROP INDEX [IX_JobID_StatusId] ON [dbo].[JOBDL010Cargo]
GO

/****** Object:  Index [IX_JobID_StatusId]    Script Date: 10/20/2020 3:17:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_JobID_StatusId] ON [dbo].[JOBDL010Cargo]
(
	[JobID] ASC,
	[StatusId] ASC
)
INCLUDE([CgoSerialNumber],[CgoQtyExpected],[CgoQtyOnHand],[CgoQtyOnHold],[CgoQtyOrdered],[CgoQtyUnitsId],[CgoQtyDamaged],[CgoQtyShortOver],[CgoQtyOver]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



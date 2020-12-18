CREATE VIEW [dbo].[vwVendorJobSecurity]
WITH SCHEMABINDING
AS
SELECT JOB.ID, PM.PrgCustID, PVL.PvlProgramID, PVL.VendDCLocationId, PVL.PvlVendorID
FROM dbo.PRGRM000Master PM
INNER JOIN dbo.PRGRM051VendorLocations PVL ON PM.Id = PVL.PvlProgramID
INNER JOIN dbo.JOBDL000Master JOB ON JOB.ProgramID = PVL.PvlProgramID
	AND PVL.PvlLocationCode = JOB.JobSiteCode
	AND PVL.StatusId IN (1, 2)
GO

CREATE UNIQUE CLUSTERED INDEX [IX_vwVendorJobSecurity_Id] ON [dbo].[vwVendorJobSecurity] (Id)

CREATE NONCLUSTERED INDEX [IX_vwVendorJobSecurity_VendDCLocationId] ON [dbo].[vwVendorJobSecurity] (VendDCLocationId)

CREATE NONCLUSTERED INDEX [IX_vwVendorJobSecurity_PvlVendorID] ON [dbo].[vwVendorJobSecurity] (PvlVendorID)
GO

CREATE NONCLUSTERED INDEX [IX_vwVendorJobSecurity_PrgCustId] ON [dbo].[vwVendorJobSecurity] (PrgCustId)
GO


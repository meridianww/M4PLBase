SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwVendorJobSecurity]
WITH SCHEMABINDING
AS

SELECT  JOB.ID, PM.PrgCustID,PVL.PvlProgramID, PVL.VendDCLocationId,PVL.PvlVendorID
					FROM dbo.PRGRM000Master PM
					INNER JOIN dbo.PRGRM051VendorLocations PVL ON PM.Id = PVL.PvlProgramID
					--INNER JOIN dbo.CONTC010Bridge CBR ON (
					--		CBR.ConPrimaryRecordId = PVL.VendDCLocationId
					--		OR CBR.ConPrimaryRecordId = PVL.PvlVendorID
					--		)
					--	AND CBR.ConTableName IN ('VendContact', 'VendDcLocationContact', 'VendDcLocation')
					--	AND CBR.StatusId IN (1, 2)
					INNER JOIN dbo.JOBDL000Master JOB ON JOB.ProgramID = PVL.PvlProgramID
						AND PVL.PvlLocationCode = JOB.JobSiteCode
						AND PVL.StatusId IN (1, 2)
GO

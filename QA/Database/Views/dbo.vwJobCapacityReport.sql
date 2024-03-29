SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJobCapacityReport]
AS
SELECT Job.Id Id
	,CASE 
		WHEN (Job.JobGatewayStatus = 'On Hand' OR JOB.JobGatewayStatus ='Onhand')
			THEN CASE 
					WHEN JOb.CustomerId = 20047
						THEN CASE 
								WHEN Cargo.CgoPackagingTypeId = 3270
									THEN ISNULL(Cargo.CgoQtyOnHand, 0)
								ELSE 0
								END
					ELSE CASE 
							WHEN Cargo.CgoQtyUnitsId IN (198,2233)
								THEN ISNULL(Cargo.CgoQtyOnHand, 0)
							ELSE 0
							END
					END
		ELSE 0
		END Cabinets
FROM [dbo].[vwJobMasterData] Job WITH(NOEXPAND)
INNER JOIN [dbo].[vwJobCargoData] Cargo WITH(NOEXPAND) ON Cargo.JobID = Job.Id AND JOB.StatusId = 1 AND Cargo.StatusId = 1 AND 
(Job.JobGatewayStatus = 'On Hand' OR JOB.JobGatewayStatus ='Onhand')
GO


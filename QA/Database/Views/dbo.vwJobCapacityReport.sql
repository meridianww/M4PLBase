ALTER VIEW dbo.vwJobCapacityReport
AS
SELECT Job.Id Id
	,CASE 
		WHEN (Job.JobGatewayStatus = 'On Hand' OR JOB.JobGatewayStatus ='Onhand')
			THEN CASE 
					WHEN Prg.PrgCustId = 20047
						THEN CASE 
								WHEN Package.SysOptionName = 'Appliance'
									THEN ISNULL(Cargo.CgoQtyOnHand, 0)
								ELSE 0
								END
					ELSE CASE 
							WHEN Options.SysOptionName IN ('CAB', 'CABINET')
								THEN ISNULL(Cargo.CgoQtyOnHand, 0)
							ELSE 0
							END
					END
		ELSE 0
		END Cabinets
FROM dbo.Prgrm000Master Prg 
INNER JOIN JobDL000Master Job ON Job.ProgramId = Prg.Id AND Prg.StatusId=1
INNER JOIN dbo.JobDL010Cargo Cargo ON Cargo.JobID = Job.Id AND JOB.StatusId = 1 AND Cargo.StatusId = 1 AND 
(Job.JobGatewayStatus = 'On Hand' OR JOB.JobGatewayStatus ='Onhand')
LEFT JOIN dbo.SYSTM000Ref_Options Options ON Options.Id = Cargo.CgoQtyUnitsId
LEFT JOIN dbo.SYSTM000Ref_Options Package ON Package.Id = Cargo.CgoPackagingTypeId
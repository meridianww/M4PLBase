ALTER VIEW dbo.vwJobCapacityReport
AS
SELECT Job.Id Id
	,CASE 
		WHEN DATEADD(day, (DATEDIFF(day, '19800104', CURRENT_TIMESTAMP) / 7) * 7, '19800104') > OnHandGateway.GwyGatewayACD
			AND DATEADD(day, (DATEDIFF(day, '19800104', CURRENT_TIMESTAMP) / 7) * 7, '19800104') < OnTruckGateway.GwyGatewayACD
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
FROM JobDL000Master Job
INNER JOIN dbo.Prgrm000Master Prg ON Prg.Id = Job.ProgramId
LEFT JOIN dbo.JobDL010Cargo Cargo ON Cargo.JobID = Job.Id
	AND Cargo.StatusId = 1
LEFT JOIN dbo.SYSTM000Ref_Options Options ON Options.Id = Cargo.CgoQtyUnitsId
LEFT JOIN dbo.SYSTM000Ref_Options Package ON Package.Id = Cargo.CgoPackagingTypeId
LEFT JOIN dbo.JOBDL020Gateways OnHandGateway ON OnHandGateway.JobId = Job.Id
	AND OnHandGateway.GwyGatewayCode IN ('On Hand', 'Onhand')
LEFT JOIN dbo.JOBDL020Gateways OnTruckGateway ON OnTruckGateway.JobId = Job.Id
	AND OnTruckGateway.GwyGatewayCode IN ('Loaded on Truck', 'On Truck')
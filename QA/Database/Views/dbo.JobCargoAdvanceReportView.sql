CREATE VIEW dbo.JobCargoAdvanceReportView
AS 
SELECT Cargo.JobId
	,SUM(CASE 
			WHEN ISNULL(Cargo.CgoSerialNumber, '') = ''
				THEN 0
			ELSE CgoQtyOrdered
			END) Labels
	,SUM(CASE 
			WHEN ISNULL(Cargo.CgoSerialNumber, '') <> ''
				THEN ISNULL(Cargo.CgoQtyOnHand, 0)
			ELSE 0
			END) Inbound
	,SUM(CASE 
			WHEN ISNULL(Cargo.CgoSerialNumber, '') <> ''
				THEN ISNULL(Cargo.CgoQtyExpected, 0)
			ELSE 0
			END) Outbound
	,SUM(CASE 
			WHEN ISNULL(Cargo.CgoSerialNumber, '') <> ''
				THEN ISNULL(Cargo.CgoQtyOnHold, 0)
			ELSE 0
			END) Delivered
	,CASE 
		WHEN Prg.PrgCustID = 20047
			THEN SUM(CASE 
						WHEN Package.SysOptionName = 'Appliance'
							THEN ISNULL(Cargo.CgoQtyOrdered, 0)
						ELSE 0
						END)
		ELSE SUM(CASE 
					WHEN Options.SysOptionName IN ('CAB', 'CABINET')
						THEN ISNULL(Cargo.CgoQtyOrdered, 0)
					ELSE 0
					END)
		END Cabinets
	,CASE 
		WHEN Prg.PrgCustID = 20047
			THEN SUM(CASE 
						WHEN Package.SysOptionName = 'Accessory'
							THEN ISNULL(Cargo.CgoQtyOrdered, 0)
						ELSE 0
						END)
		ELSE SUM(CASE 
					WHEN Options.SysOptionName = 'CABPART'
						THEN ISNULL(Cargo.CgoQtyOrdered, 0)
					ELSE 0
					END)
		END Parts
FROM dbo.JobDL010Cargo Cargo
INNER JOIN dbo.JOBDL000Master Job ON Job.Id = Cargo.JobID
INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = Job.ProgramID
LEFT JOIN dbo.SYSTM000Ref_Options Options ON Options.Id = Cargo.CgoQtyUnitsId
LEFT JOIN dbo.SYSTM000Ref_Options Package ON Package.Id = Cargo.CgoPackagingTypeId
WHERE Cargo.StatusId = 1
GROUP BY JobId
	,PrgCustID
GO
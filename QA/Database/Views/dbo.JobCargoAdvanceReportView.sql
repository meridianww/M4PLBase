CREATE VIEW dbo.JobCargoAdvanceReportView
AS 
SELECT Cargo.JobId
	,SUM(CASE 
			WHEN ISNULL(Cargo.CgoSerialNumber, '') = ''
				THEN 0
			ELSE 1
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
	,SUM(CASE 
			WHEN Options.SysOptionName IN ('CAB', 'CABINET')
				THEN ISNULL(Cargo.CgoQtyOrdered, 0)
			ELSE 0
			END) Cabinets
	,SUM(CASE 
			WHEN Options.SysOptionName = 'CABPART'
				THEN ISNULL(Cargo.CgoQtyOrdered, 0)
			ELSE 0
			END) Parts
FROM dbo.JobDL010Cargo Cargo
INNER JOIN dbo.SYSTM000Ref_Options Options ON Options.Id = Cargo.CgoQtyUnitsId
Where Cargo.StatusId=1
GROUP BY JobId
GO

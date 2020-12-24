IF COL_LENGTH('dbo.AWCDriverScrubReport', 'JobId') IS NOT NULL
BEGIN
ALTER TABLE dbo.AWCDriverScrubReport DROP COLUMN JobId
END

IF COL_LENGTH('dbo.AWCDriverScrubReport', 'ShipDate') IS NOT NULL
BEGIN
ALTER TABLE dbo.AWCDriverScrubReport DROP COLUMN ShipDate
END

IF COL_LENGTH('dbo.CommonDriverScrubReport', 'JobId') IS NOT NULL
BEGIN
ALTER TABLE dbo.CommonDriverScrubReport DROP COLUMN JobId
END

IF COL_LENGTH('dbo.CommonDriverScrubReport', 'ShipDate') IS NOT NULL
BEGIN
ALTER TABLE dbo.CommonDriverScrubReport DROP COLUMN ShipDate
END

ALTER TABLE dbo.AWCDriverScrubReport ADD JobId BIGINT
ALTER TABLE dbo.AWCDriverScrubReport ADD ShipDate DateTime2(7)
ALTER TABLE dbo.CommonDriverScrubReport ADD JobId BIGINT
ALTER TABLE dbo.CommonDriverScrubReport ADD ShipDate DateTime2(7)

UPDATE AWC
SET AWC.JobId = Job.Id
From dbo.AWCDriverScrubReport AWC
INNER JOIN JobDL000Master Job ON dbo.udf_GetNumeric(JobCustomerSalesOrder) = AWC.ActualControlId

UPDATE dbo.AWCDriverScrubReport
SET ShipDate = CONVERT([datetime],[dbo].[trimChar](replace(replace(replace(replace(replace(replace(replace([QMSShippedOn],'Sunday',''),'Monday',''),'Tuesday',''),'Wednesday',''),'Thursday',''),'Friday',''),'Saturday',''),','),(102))
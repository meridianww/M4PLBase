

UPDATE SYSTM000ColumnsAlias SET ColAliasName = '3PL Arrival Time' , ColCaption = '3PL Arrival Time' ,ColGridAliasName = '3PL Arrival Time'
WHERE ColTableName = 'Program' AND ColColumnName = 'PrgPickUpTimeDefault'

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL020Gateways' AND COLUMN_NAME = 'StatusCode')
BEGIN
	ALTER TABLE JOBDL020Gateways
	ADD StatusCode NVARCHAR(50) NULL
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'JobIsSchedule')
BEGIN
	ALTER TABLE JOBDL000Master
	ADD JobIsSchedule BIT
END

DECLARE @CountofSortOrder int
SELECT @CountofSortOrder = COUNT(Id) + 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JOB'
IF NOT EXISTS(SELECT 1 FROM SYSTM000ColumnsAlias WHERE ColTableName ='JOB' AND ColColumnName = 'JobIsSchedule')
         BEGIN
		    INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
			ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
			VALUES ('EN', 'JOB', NULL, 'JobIsSchedule', 'Job Schedule', 'Job Schedule', 'Job Schedule', NULL, NULL, '', @CountofSortOrder, 1, 1, 1, 1, NULL, 0, 0, NULL, 1)
		 END
GO

UPDATE JOBDL000Master 
 SET JobIsSchedule = 0 WHERE JobIsSchedule IS NULL

UPDATE JOB
 SET JOB.JobIsSchedule = 1
FROM JOBDL000Master JOB
WHERE ID IS NOT NULL AND 
ID IN 
(
SELECT DISTINCT JOBID FROM JOBDL020Gateways WHERE GwyGatewayCode = 'Schedule' )




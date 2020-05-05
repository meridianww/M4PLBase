UPDATE [dbo].[SYSTM000ColumnsAlias]
SET ColIsReadOnly = 1
WHERE ColTableName = 'Job'
	AND (
		ColColumnName = 'JobLatitude'
		OR ColColumnName = 'JobLongitude'
		)
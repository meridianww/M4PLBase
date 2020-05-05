IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[SVYUSER000Master]')
			AND name = 'CustName'
		)
BEGIN
	ALTER TABLE [SVYUSER000Master] ADD CustName nvarchar(100) null
END
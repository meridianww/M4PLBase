IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[JOBDL020Gateways]')
			AND name = 'isActionAdded'
		)
BEGIN
	ALTER TABLE [JOBDL020Gateways] ADD isActionAdded BIT NOT NULL DEFAULT(0)
END
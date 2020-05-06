IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL023GatewayInstallStatusMaster' AND COLUMN_NAME = 'CompanyId')
	BEGIN
		ALTER TABLE JOBDL023GatewayInstallStatusMaster
		ADD CompanyId BIGINT NULL
	END
GO

DECLARE @CompanyId BIGINT
SELECT @CompanyId = ID FROM dbo.COMP000Master WHERE CompTableName = 'Customer' AND CompPrimaryRecordId = 20047
UPDATE JOBDL023GatewayInstallStatusMaster SET CompanyId = @CompanyId




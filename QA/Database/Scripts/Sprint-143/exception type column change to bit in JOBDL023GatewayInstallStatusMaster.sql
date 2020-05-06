
UPDATE JOBDL023GatewayInstallStatusMaster SET ExceptionType = 1 WHERE ExceptionType = 'exception 1'
UPDATE JOBDL023GatewayInstallStatusMaster SET ExceptionType = 0 WHERE ExceptionType = 'exception 0'

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL023GatewayInstallStatusMaster' AND COLUMN_NAME = 'ExceptionType')
	BEGIN
		ALTER TABLE JOBDL023GatewayInstallStatusMaster
		ALTER COLUMN ExceptionType BIT NULL;
	END
GO





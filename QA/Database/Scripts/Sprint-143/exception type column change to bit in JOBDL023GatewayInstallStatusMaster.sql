
UPDATE JOBDL023GatewayInstallStatusMaster SET ExceptionType = 1 WHERE ExceptionType = 'exception 1'
UPDATE JOBDL023GatewayInstallStatusMaster SET ExceptionType = 0 WHERE ExceptionType = 'exception 0'

ALTER TABLE JOBDL023GatewayInstallStatusMaster
ALTER COLUMN ExceptionType BIT NULL;





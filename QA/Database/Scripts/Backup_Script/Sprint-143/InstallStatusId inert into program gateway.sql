IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRGRM010Ref_GatewayDefaults' AND COLUMN_NAME = 'InstallStatusId')
BEGIN
	ALTER TABLE PRGRM010Ref_GatewayDefaults
	ADD InstallStatusId BIGINT NULL
END


IF NOT EXISTS(SELECT 1 FROM SYSTM000Master WHERE SysMessageCode='ImportJobData')
BEGIN
	INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('EN', 'ImportJobData', 41, 'Job Import', 'Job Import', 'Jobs uploaded successfully from CSV File.', NULL, 'Ok', 1,  GETUTCDATE(), 'nfujimoto', GETUTCDATE(), 'nfujimoto')
END

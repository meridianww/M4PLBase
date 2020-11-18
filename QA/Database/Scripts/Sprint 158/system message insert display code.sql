
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000Master WHERE SysMessageCode ='DriverScrubReport')
BEGIN
INSERT INTO  dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'DriverScrubReport', 41, 'Info', 'Business Rule', '', NULL, 'Ok', 1, '2020-07-16 06:47:16.8', 'nfujimoto', NULL, NULL)
END
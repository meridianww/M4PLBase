
IF NOT EXISTS(SELECT 1 FROM SYSTM000MenuDriver WHERE MnuBreakDownStructure='01.07.03')
BEGIN
	INSERT INTO dbo.SYSTM000MenuDriver (LangCode, MnuModuleId, MnuTableName, MnuBreakDownStructure, MnuTitle, MnuDescription, MnuTabOver, MnuMenuItem, MnuRibbon, MnuRibbonTabName, MnuIconVerySmall, MnuIconSmall, MnuIconMedium, MnuIconLarge, MnuExecuteProgram, MnuClassificationId, MnuProgramTypeId, MnuOptionLevelId, MnuAccessLevelId, MnuHelpFile, MnuHelpBookMark, MnuHelpPageNumber, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('EN', 9, NULL, '01.07.03', 'User Guide', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 176, NULL, 27, 21, NULL, NULL, NULL, 1, GETUTCDATE(), NULL, NULL, NULL)
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000MenuDriver WHERE MnuBreakDownStructure='01.07.03.01')
BEGIN
	INSERT INTO dbo.SYSTM000MenuDriver (LangCode, MnuModuleId, MnuTableName, MnuBreakDownStructure, MnuTitle, MnuDescription, MnuTabOver, MnuMenuItem, MnuRibbon, MnuRibbonTabName, MnuIconVerySmall, MnuIconSmall, MnuIconMedium, MnuIconLarge, MnuExecuteProgram, MnuClassificationId, MnuProgramTypeId, MnuOptionLevelId, MnuAccessLevelId, MnuHelpFile, MnuHelpBookMark, MnuHelpPageNumber, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('EN', 9, 'SysSetting', '01.07.03.01', 'Upload', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 53, 50, 27, 21, NULL, NULL, NULL, 1, GETUTCDATE(), NULL, NULL, NULL)
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000Master WHERE SysMessageCode = 'UserGuidePDFDocument')
BEGIN
	INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES ('EN', 'UserGuidePDFDocument', 41, 'Info', 'Data Updated', 'File Uploaded successfully.', NULL, 'Ok', 1, GETUTCDATE(), 'SimonDekker', NULL, NULL)
END


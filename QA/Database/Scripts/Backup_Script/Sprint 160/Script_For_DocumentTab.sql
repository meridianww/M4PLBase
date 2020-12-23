Delete From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference'
UPDATE [dbo].[SYSTM030Ref_TabPageName] SET TabPageTitle = 'Documents'  Where TabTableName = 'JobDocReference' AND TabPageTitle = 'Document'
IF NOT EXISTS(Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference' AND TabTableName = 'All')
BEGIN
INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'JobDocReference', 1, 'JobDocReference', 'All', 'DocumentDataView', NULL, 1, GetDate(), 'System', NULL, NULL)
END
IF NOT EXISTS(Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference' AND TabTableName = 'Approvals')
BEGIN
INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'JobDocReference', 2, 'JobDocReference', 'Approvals', 'DocApprovalsDataView', NULL, 1, GetDate(), 'System', NULL, NULL)
END
IF NOT EXISTS(Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference' AND TabTableName = 'DocDamagedDataView')
BEGIN
INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'JobDocReference', 3, 'JobDocReference', 'Damaged', 'DocDamagedDataView', NULL, 1, GetDate(), 'System', NULL, NULL)
END
IF NOT EXISTS(Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference' AND TabTableName = 'Document')
BEGIN
INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'JobDocReference', 4, 'JobDocReference', 'Document', 'DocDocumentDataView', NULL, 1, GetDate(), 'System', NULL, NULL)
END
IF NOT EXISTS(Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference' AND TabTableName = 'Image')
BEGIN
INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'JobDocReference', 5, 'JobDocReference', 'Image', 'DocImageDataView', NULL, 1, GetDate(), 'System', NULL, NULL)
END
IF NOT EXISTS(Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference' AND TabTableName = 'DocDeliveryPodDataView')
BEGIN
INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'JobDocReference', 6, 'JobDocReference', 'POD', 'DocDeliveryPodDataView', NULL, 1, GetDate(), 'System', NULL, NULL)
END
IF NOT EXISTS(Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where RefTableName = 'JobDocReference' AND TabTableName = 'Signature')
BEGIN
INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'JobDocReference', 7, 'JobDocReference', 'Signature', 'DocSignatureDataView', NULL, 1, GetDate(), 'System', NULL, NULL)
END
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'VocAllStar' AND Object_ID = Object_ID(N'dbo.MVOC000Program'))
BEGIN
ALTER TABLE [dbo].[MVOC000Program] ADD VocAllStar BIT NOT NULL DEFAULT(0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'PrgMvoc' AND ColColumnName = 'VocAllStar')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'PrgMvoc', NULL, 'VocAllStar', 'All Star', 'All Star', NULL, NULL, '', 14, 0, 1, 1, 1, NULL, 0, 0, NULL)
END

UPDATE [dbo].[SYSTM000Ref_Table]  SET [TblLangName] = 'Program VOC' Where [TblLangName] = 'Program Customer Journey'
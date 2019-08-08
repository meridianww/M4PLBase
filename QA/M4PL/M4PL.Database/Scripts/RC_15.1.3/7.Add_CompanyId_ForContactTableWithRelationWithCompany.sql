ALTER TABLE [dbo].[CONTC000Master] ADD [ConCompanyId] [bigint] NULL

ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_ConCompanyId] FOREIGN KEY([ConCompanyId])
REFERENCES [dbo].[COMP000Master] ([Id])
GO

ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_ConCompanyId]
GO

INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Contact', 'CONTC000Master', 'ConCompanyId', 'Company', 'Company', NULL, NULL, NULL, NULL, 0, 1, 0, 1, NULL, NULL, 0, NULL)
GO

 INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CustDcLocationContact', 'Contact', 'ConCompanyId', 'Company', 'Company', NULL, NULL, NULL, NULL, 0, 1, 0, 1, NULL, NULL, 0, NULL)
GO
INSERT INTO [dbo].[SYSTM000ColumnsAlias] (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'VendDcLocationContact', 'Contact', 'ConCompanyId', 'Company', 'Company', NULL, NULL, NULL, NULL, 0, 1, 0, 1, NULL, NULL, 0, NULL)
GO

Update dbo.SYSTM000ColumnsAlias SET ColIsVisible=0 Where ColTableName='Contact' AND ColColumnName='ConCompanyName'
GO

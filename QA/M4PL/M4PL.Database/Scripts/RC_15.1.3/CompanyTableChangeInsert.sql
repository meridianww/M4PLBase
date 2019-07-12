SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[COMP000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CompOrgId] [bigint] NOT NULL,
	[CompTableName] [nvarchar](100) NOT NULL,
	[CompPrimaryRecordId] [bigint] NOT NULL,
	[CompCode] [nvarchar](50) NOT NULL,
	[CompTitle] [nvarchar](50) NOT NULL,
	[StatusId] [int] NOT NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [COMP000MasterDF_DateEntered]  DEFAULT (getutcdate()),
	[EnteredBy] [nvarchar](50) NOT NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_COMP000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[COMP000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMP000Master_CompOrgId_ORGAN000Master] FOREIGN KEY([CompOrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO

ALTER TABLE [dbo].[COMP000Master] CHECK CONSTRAINT [FK_COMP000Master_CompOrgId_ORGAN000Master]
GO

ALTER TABLE [dbo].[COMP000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMP000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[COMP000Master] CHECK CONSTRAINT [FK_COMP000Master_Status_SYSTM000Ref_Options]
GO

--------------Scripts to insert Data---------------------------------------------

INSERT INTO dbo.SYSTM000Ref_Table (SysRefName, LangCode, TblLangName, TblTableName, TblMainModuleId, TblIcon, TblTypeId, TblPrimaryKeyName, TblParentIdFieldName, TblItemNumberFieldName, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('Company', 'EN', 'Company', 'COMP000Master', 10, NULL, NULL, 'Id', NULL, NULL, getutcdate(), NULL, NULL, NULL)
GO

------------Insert Data In Column Alias---------------------------------------

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'Id', 'Id', 'Id Caption', NULL, NULL, 'Id Desc', 1, 1, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'CompOrgId', 'Comp Org Id', 'Comp Org Id Caption', NULL, NULL, 'Comp Org Id Desc', 2, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'CompTableName', 'Comp Table Name', 'Comp Table Name Caption', NULL, NULL, 'Comp Table Name Desc', 3, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'CompPrimaryRecordId', 'Comp Primary Record Id', 'Comp Primary Record Id Caption', NULL, NULL, 'Comp Primary Record Id Desc', 4, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'CompCode', 'Comp Code', 'Comp Code Caption', NULL, NULL, 'Comp Code Desc', 5, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'CompTitle', 'Comp Title', 'Comp Title Caption', NULL, NULL, 'Comp Title Desc', 6, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'StatusId', 'Status Id', 'Status Id Caption', NULL, NULL, 'Status Id Desc', 7, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'DateEntered', 'Date Entered', 'Date Entered Caption', NULL, NULL, 'Date Entered Desc', 8, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'EnteredBy', 'Entered By', 'Entered By Caption', NULL, NULL, 'Entered By Desc', 9, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'DateChanged', 'Date Changed', 'Date Changed Caption', NULL, NULL, 'Date Changed Desc', 10, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Company', NULL, 'ChangedBy', 'Changed By', 'Changed By Caption', NULL, NULL, 'Changed By Desc', 11, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO

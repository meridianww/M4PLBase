SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[COMPADD000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AddCompId] [bigint] NOT NULL,
	[AddItemNumber] [int] NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](150) NULL,
	[City] [nvarchar](25) NULL,
	[StateId] [int] NULL,
	[ZipPostal] [nvarchar](20) NULL,
	[CountryId] [int] NULL,
	[AddTypeId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [COMPADD000MasterDF_DateEntered]  DEFAULT (getutcdate()),
	[EnteredBy] [nvarchar](50) NOT NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_COMPADD000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[COMPADD000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMPADD000Master_AddCompId_COMP000Master] FOREIGN KEY([AddCompId])
REFERENCES [dbo].[COMP000Master] ([Id])
GO

ALTER TABLE [dbo].[COMPADD000Master] CHECK CONSTRAINT [FK_COMPADD000Master_AddCompId_COMP000Master]
GO

ALTER TABLE [dbo].[COMPADD000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMPADD000Master_Type_SYSTM000Ref_Options] FOREIGN KEY([AddTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[COMPADD000Master] CHECK CONSTRAINT [FK_COMPADD000Master_Type_SYSTM000Ref_Options]
GO

--------------Scripts to insert Data---------------------------------------------

INSERT INTO dbo.SYSTM000Ref_Table (SysRefName, LangCode, TblLangName, TblTableName, TblMainModuleId, TblIcon, TblTypeId, TblPrimaryKeyName, TblParentIdFieldName, TblItemNumberFieldName, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('CompanyAddress', 'EN', 'CompanyAddress', 'COMPADD000Master', 10, NULL, NULL, 'Id', NULL, NULL, getutcdate(), NULL, NULL, NULL)
GO

INSERT INTO dbo.SYSTM000Ref_Lookup (LkupCode, LkupTableName)
VALUES ('CompanyAddress', 'Global')
GO

Declare @SysLookupId INT
Select @SysLookupId = ID From dbo.SYSTM000Ref_Lookup Where LkupCode='CompanyAddress'

INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (@SysLookupId, 'AddressType', 'Business', 0, 1, 0, 1, GETUTCDATE(), NULL, NULL, NULL)


INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (@SysLookupId, 'AddressType', 'Corporate', 1, 0, 0, 1, GETUTCDATE(), NULL, NULL, NULL)


INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (@SysLookupId, 'AddressType', 'Work', 2, 0, 0, 1, GETUTCDATE(), NULL, NULL, NULL)






------------Insert Data In Column Alias---------------------------------------

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'Id', 'Id', 'Id Caption', NULL, NULL, 'Id Desc', 1, 1, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'AddCompId', 'Add Comp Id', 'Add Comp Id Caption', NULL, NULL, 'Add Comp Id Desc', 2, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'AddItemNumber', 'Add Item Number', 'Add Item Number Caption', NULL, NULL, 'Add Item Number Desc', 3, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'Address1', 'Address1', 'Address1 Caption', NULL, NULL, 'Address1 Desc', 4, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'Address2', 'Address2', 'Address2 Caption', NULL, NULL, 'Address2 Desc', 5, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'City', 'City', 'City Caption', NULL, NULL, 'City Desc', 6, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'StateId', 'State Id', 'State Id Caption', NULL, NULL, 'State Id Desc', 7, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'ZipPostal', 'Zip Postal', 'Zip Postal Caption', NULL, NULL, 'Zip Postal Desc', 8, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'CountryId', 'Country Id', 'Country Id Caption', NULL, NULL, 'Country Id Desc', 9, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'AddTypeId', 'Add Type Id', 'Add Type Id Caption', NULL, NULL, 'Add Type Id Desc', 10, 0, 1, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'DateEntered', 'Date Entered', 'Date Entered Caption', NULL, NULL, 'Date Entered Desc', 11, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'EnteredBy', 'Entered By', 'Entered By Caption', NULL, NULL, 'Entered By Desc', 12, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'DateChanged', 'Date Changed', 'Date Changed Caption', NULL, NULL, 'Date Changed Desc', 13, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'CompanyAddress', NULL, 'ChangedBy', 'Changed By', 'Changed By Caption', NULL, NULL, 'Changed By Desc', 14, 1, 0, 1, NULL, NULL, NULL, 0, NULL)
GO



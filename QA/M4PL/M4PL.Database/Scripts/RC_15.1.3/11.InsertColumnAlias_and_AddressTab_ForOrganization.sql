IF NOT EXISTS (Select 1 From [dbo].[SYSTM030Ref_TabPageName] Where [RefTableName] = 'Organization' AND [TabPageTitle] = 'Address')
BEGIN
 INSERT INTO [dbo].[SYSTM030Ref_TabPageName] (LangCode, RefTableName, TabSortOrder, TabTableName, TabPageTitle, TabExecuteProgram, TabPageIcon, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'Organization', 5, 'Organization', 'Address', 'AddressFormView', NULL, 1, '2017-12-22 10:37:24.82', 'SimonDekker', NULL, 'Bharath')
END
ELSE
BEGIN
  UPDATE [dbo].[SYSTM030Ref_TabPageName] SET [TabTableName] = 'Organization',
  TabExecuteProgram = 'AddressFormView', StatusId = 1 
   Where [RefTableName]='Organization' AND [TabPageTitle] ='Address'
END

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'OrgBusinessAddressId', 'Business Address', 'Business Address', NULL, NULL, '', 9, 0, 1, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'OrgCorporateAddressId', 'Corporate Address', 'Corporate Address', NULL, NULL, '', 10, 0, 1, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'OrgWorkAddressId', 'Work Address', 'Work Address', NULL, NULL, '', 8, 0, 1, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'BusinessAddress1', 'Business Address Line 1', 'Business Address Line 1', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'BusinessAddress2', 'Business Address Line 2', 'Business Address Line 2', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'BusinessCity', 'Business City', 'Business City', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'BusinessStateId', 'Business State Province', 'Business State Province', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'BusinessZipPostal', 'Business Zip Postal', 'Business Zip Postal', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', 'ADDRESS000Master', 'BusinessCountryId', 'Business Country Region', 'Business Country Region', 51, 'Countries', '', 28, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'CorporateAddress1', 'Corporate Address Line 1', 'Corporate Address Line 1', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'CorporateAddress2', 'Corporate Address Line 2', 'Corporate Address Line 2', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'CorporateCity', 'Corporate City', 'Corporate City', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'CorporateStateId', 'Corporate State Province', 'Corporate State Province', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'CorporateZipPostal', 'Corporate Zip Postal', 'Corporate Zip Postal', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', 'ADDRESS000Master', 'CorporateCountryId', 'Corporate Country Region', 'Corporate Country Region', 51, 'Countries', '', 28, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'WorkAddress1', 'Work Address Line 1', 'Work Address Line 1', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'WorkAddress2', 'Work Address Line 2', 'Work Address Line 2', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'WorkCity', 'Work City', 'Work City', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'WorkStateId', 'Work State Province', 'Work State Province', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', NULL, 'WorkZipPostal', 'Work Zip Postal', 'Work Zip Postal', NULL, NULL, '', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask)
VALUES ('EN', 'Organization', 'ADDRESS000Master', 'WorkCountryId', 'Work Country Region', 'Work Country Region', 51, 'Countries', '', 28, 0, 0, 1, 1, NULL, 0, 0, NULL)
GO


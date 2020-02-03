
 update SYSTM000ColumnsAlias set ColAliasName='Quantity Actual',ColCaption='Quantity Actual',ColGridAliasName='Quantity Actual'
 WHERE ColTableName ='JobAdvanceReport' and ColColumnName ='TotalQuantity'

INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Destination', 'Destination', 'Destination', 'Destination', NULL, NULL, '', 31, 0, 1, 1, 1, NULL, 0, 0, NULL, 1)
GO


UPDATE SYSTM000ColumnsAlias SET IsGridColumn=0 WHERE ColTableName='JobAdvanceReport' AND ColAliasName='Destination'
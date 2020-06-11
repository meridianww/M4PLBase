UPDATE SYSTM000Ref_Options SET SysDefault = 0 Where SysLookupCode='JobDocReferenceType'
UPDATE SYSTM000Ref_Options SET SysDefault = 1 Where SysLookupCode='JobDocReferenceType' AND SysOptionName = 'POD'

UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColAliasName = 'Document Type', ColCaption = 'Document Type', 
ColGridAliasName = 'Document Type' where ColTableName = 'JobDocReference' AND ColColumnName = 'DocTypeId'
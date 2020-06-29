UPDATE SYSTM000Ref_Options SET SysDefault = 0 Where SysLookupCode='JobDocReferenceType'
UPDATE SYSTM000Ref_Options SET SysDefault = 1 Where SysLookupCode='JobDocReferenceType' AND SysOptionName = 'POD'

UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColAliasName = 'Doc Type', ColCaption = 'Doc Type', 
ColGridAliasName = 'Doc Type' where ColTableName = 'JobDocReference' AND ColColumnName = 'DocTypeId'
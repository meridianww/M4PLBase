UPDATE [dbo].[SYSTM000ColumnsAlias] SET 
ColAliasName = 'Weight', ColCaption = 'Weight', ColGridAliasName = 'Weight', ColIsVisible = 1
WHERE ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobTotalWeight'

UPDATE [dbo].[SYSTM000ColumnsAlias] SET 
ColIsVisible = 1
WHERE ColTableName = 'JobAdvanceReport' AND ColColumnName = 'CgoPartCode'

UPDATE [dbo].[SYSTM000ColumnSettingsByUser] SET ColNotVisible = 'JobBOL,CustTitle,JobManifestNo,PlantIDCode,JobSiteCode'
where ColUserId = -1 and ColTableName = 'JobAdvanceReport'


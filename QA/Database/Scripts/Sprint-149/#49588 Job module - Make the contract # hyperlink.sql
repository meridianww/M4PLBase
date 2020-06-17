
UPDATE SYSTM000ColumnsAlias SET ColIsVisible=0 WHERE ColTableName = 'JobCard' AND ColColumnName = 'Id'
UPDATE SYSTM000ColumnSettingsByUser set ColNotVisible = 
'Id,JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
WHERE ColTableName = 'JobCard'

UPDATE SYSTM000ColumnsAlias SET ColIsVisible=0 WHERE ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Id'
UPDATE SYSTM000ColumnSettingsByUser set ColNotVisible = 
'Id,JobTotalWeight,CgoPartCode,JobBOL,CustTitle,JobManifestNo,PlantIDCode,JobSiteCode'
WHERE ColTableName = 'JobAdvanceReport' AND ColUserId = -1

UPDATE SYSTM000ColumnsAlias SET ColIsVisible=0 WHERE ColTableName = 'Job' AND ColColumnName = 'Id'
UPDATE SYSTM000ColumnSettingsByUser set ColNotVisible = 
'Id,JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
WHERE ColTableName = 'Job' AND ColUserId = -1
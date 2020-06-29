
UPDATE SYSTM000ColumnsAlias SET ColIsVisible=1 WHERE ColTableName = 'JobCard' AND ColColumnName = 'Id'
UPDATE SYSTM000ColumnSettingsByUser set ColNotVisible = 
'JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
WHERE ColTableName = 'JobCard' AND ColUserId = -1

UPDATE SYSTM000ColumnsAlias SET ColIsVisible=1 WHERE ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Id'
UPDATE SYSTM000ColumnSettingsByUser set ColNotVisible = 
'JobTotalWeight,CgoPartCode,JobBOL,CustTitle,JobManifestNo,PlantIDCode,JobSiteCode'
WHERE ColTableName = 'JobAdvanceReport' AND ColUserId = -1

UPDATE SYSTM000ColumnsAlias SET ColIsVisible=1 WHERE ColTableName = 'Job' AND ColColumnName = 'Id'
UPDATE SYSTM000ColumnSettingsByUser set ColNotVisible = 
'JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
WHERE ColTableName = 'Job' AND ColUserId = -1
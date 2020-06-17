UPDATE [dbo].[SYSTM000ColumnsAlias] SET IsGridColumn = 1 WHERE ColTableName = 'Job' AND ColColumnName IN
 ('JobSiteCode','PlantIDCode','JobTotalWeight','JobTotalCubes','JobOriginSiteName','JobDeliveryDateTimeActual','JobOriginDateTimeActual')



UPDATE [dbo].[SYSTM000ColumnsAlias] SET IsGridColumn = 1 WHERE ColTableName = 'JobCard' AND ColColumnName IN
 ('JobSiteCode','PlantIDCode','JobTotalWeight','JobTotalCubes','JobOriginSiteName','JobDeliveryDateTimeActual','JobOriginDateTimeActual')

 
UPDATE [dbo].[SYSTM000ColumnsAlias] SET IsGridColumn = 1 WHERE ColTableName = 'JobAdvanceReport' AND ColColumnName IN
 ('JobSiteCode','PlantIDCode','JobTotalWeight','JobTotalCubes','JobDeliveryDateTimeActual','JobOriginDateTimeActual')



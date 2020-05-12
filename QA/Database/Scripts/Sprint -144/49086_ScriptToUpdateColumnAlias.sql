 
 If EXISTS(SELECT 1 from [SYSTM000ColumnsAlias] WHERE ColTableName= 'JOb' and ColColumnName= 'IsJobVocSurvey' )
 BEGIN
 UPDATE [SYSTM000ColumnsAlias] SET ColAliasName='Delivery Survey' ,ColCaption = 'Delivery Survey' ,ColGridAliasName = 'Delivery Survey' WHERE  ColTableName= 'JOb' AND ColColumnName= 'IsJobVocSurvey'
 END
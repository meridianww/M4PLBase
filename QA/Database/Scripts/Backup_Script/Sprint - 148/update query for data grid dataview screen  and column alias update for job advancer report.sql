UPDATE SYSTM000MenuDriver SET MnuTitle = 'Data Grid'
WHERE MnuTitle = 'Data View Screen'

UPDATE SYSTM000MenuDriver SET MnuTitle = 'Grid View'
WHERE MnuTitle = 'DataSheet View'


UPDATE SYSTM000ColumnsAlias SET ColColumnName ='JobTotalWeight' 
WHERE ColTableName = 'JobAdvanceReport' and ColColumnName = 'CgoWeight'




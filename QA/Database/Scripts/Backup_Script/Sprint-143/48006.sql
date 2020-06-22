

UPDATE SYSTM000ColumnsAlias SET ColIsReadOnly=1 
WHERE ColTableName = 'JOBGATEWAY' AND ColColumnName IN ( 'CancelOrder' ,'DateCancelled')
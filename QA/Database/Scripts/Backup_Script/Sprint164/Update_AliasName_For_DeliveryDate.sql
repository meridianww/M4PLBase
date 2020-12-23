UPDATE SYSTM000ColumnsAlias SET ColAliasName = 'Schedule Delivery Date', ColCaption='Schedule Delivery Date'
Where ColColumnName='GwyDDPCurrent' AND ColTableName ='JobGateway' 

UPDATE SYSTM000ColumnsAlias SET ColAliasName = 'Reschedule Delivery Date', ColCaption='Reschedule Delivery Date'
Where ColColumnName='GwyDDPNew' AND ColTableName ='JobGateway' 
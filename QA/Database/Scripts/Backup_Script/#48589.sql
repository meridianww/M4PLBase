
 UPDATE SYSTM000ColumnsAlias SET ColAliasName = 'Schedule Date' ,ColCaption = 'Schedule Date'
 WHERE ColTableName = 'JobGateway' AND ColColumnName = 'GwyDDPCurrent'

 UPDATE SYSTM000ColumnsAlias SET ColAliasName = 'Reschedule Date' ,ColCaption = 'Reschedule Date'
 WHERE ColTableName = 'JobGateway' AND ColColumnName = 'GwyDDPNew'

UPDATE SYSTM000ColumnsAlias SET ColAliasName = 'A C D' ,ColCaption = 'A C D',ColIsReadOnly = 1
WHERE ColTableName = 'JobGateway' and ColColumnName = 'DateComment'


 UPDATE SYSTM030Ref_TabPageName SET TabPageTitle = 'Gateways' WHERE TabTableName = 'JobGateway' AND RefTableName = 'JobGateway' AND TabPageTitle = 'Tracking'

 UPDATE SYSTM030Ref_TabPageName SET TabPageTitle = 'Tracking'  WHERE TabTableName = 'JobGateway' AND RefTableName = 'Job'
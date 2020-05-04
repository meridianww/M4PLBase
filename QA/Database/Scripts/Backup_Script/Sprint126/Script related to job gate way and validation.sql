UPDATE SYSTM000ColumnsAlias SET ColAliasName='Latest Time',ColCaption='Latest Time',ColGridAliasName='Latest Time'
WHERE ColTableName='JobGateway' AND ColColumnName='GwyUprDate'
UPDATE SYSTM000ColumnsAlias SET ColAliasName='Earliest Time',ColCaption='Earliest Time',ColGridAliasName='Earliest Time'
WHERE ColTableName='JobGateway' AND ColColumnName='GwyLwrDate'


UPDATE SYSTM000Validation SET ValRequired=0,StatusId=3 where ValTableName='JobGateway' AND ValFieldName='GwyUprWindow'
UPDATE SYSTM000Validation SET ValRequired=0,StatusId=3 where ValTableName='JobGateway' AND ValFieldName='GwyLwrWindow'
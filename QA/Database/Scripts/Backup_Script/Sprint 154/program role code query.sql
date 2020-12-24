UPDATE SYSTM000Validation SET ValRequiredMessage ='Program Role Code is required'  WHERE ValTableName = 'PrgRole' and ValFieldName = 'OrgRoleCode'
DELETE FROM SYSTM000Validation WHERE ValTableName = 'PrgRole' AND ValFieldName = 'PrgRoleId'

DELETE FROM SYSTM000ColumnsAlias WHERE ColTableName = 'PrgRole' AND ColColumnName ='PrgRoleId'
UPDATE SYSTM000ColumnsAlias SET ColAliasName ='Prg Role Code',ColCaption ='Prg Role Code'
WHERE ColTableName = 'PrgRole' AND ColColumnName ='OrgRefRoleId'



UPDATE SYSTM000ColumnsAlias SET ColIsVisible=0 WHERE  ColTableName='contact' AND ColColumnName='ConOrgId'

update SYSTM000ColumnSettingsByUser set ColNotVisible = ColNotVisible + ',ConOrgId' where ColTableName='contact'
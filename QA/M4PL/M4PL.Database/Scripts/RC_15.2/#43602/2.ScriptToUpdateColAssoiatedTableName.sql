update SYSTM000ColumnsAlias set ColAssociatedTableName = 'Contact'  where ColTableName = 'VendDclocationContact' and ColColumnName NOT IN (select name from sys.columns  where object_name(object_id) = 'CONTC010Bridge')
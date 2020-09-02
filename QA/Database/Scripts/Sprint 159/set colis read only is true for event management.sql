

update SYSTM000ColumnsAlias set colisreadonly=0 WHERE ColTableName ='PrgEventManagement'
and ColColumnName not in (
'EnteredBy'
,'DateEntered'
,'ChangedBy'
,'DateChanged'
,'Id')
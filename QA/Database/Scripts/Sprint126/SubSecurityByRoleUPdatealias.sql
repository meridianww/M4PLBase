update SYSTM000ColumnsAlias  
set ColAliasName = 'Subs Menu Option Level',
 ColCaption = 'Subs Menu Option Level'
where ColTableName= 'SubSecurityByRole'  and ColColumnName ='SubsMenuOptionLevelId'

update SYSTM000ColumnsAlias  
set ColAliasName = 'Subs Menu Access Level',
 ColCaption = 'Subs Menu Access Level'
where ColTableName= 'SubSecurityByRole'  and ColColumnName ='SubsMenuAccessLevelId'


update SYSTM000ColumnsAlias  
set ColAliasName = 'Status',
 ColCaption = 'Status'
where ColTableName= 'SubSecurityByRole'  and ColColumnName ='StatusId'
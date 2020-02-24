insert into SYSTM000ColumnSettingsByUser(ColUserId
,ColTableName
,ColSortOrder
,ColNotVisible
,ColIsFreezed
,ColIsDefault
,ColGroupBy
,ColGridLayout
,DateEntered
,EnteredBy
,DateChanged
,ChangedBy
,ColMask)

select ColUserId
,'JobCard'
,ColSortOrder
,ColNotVisible
,ColIsFreezed
,ColIsDefault
,ColGroupBy
,ColGridLayout
,DateEntered
,EnteredBy
,DateChanged
,ChangedBy
,ColMask from [dbo].[SYSTM000ColumnSettingsByUser] where ColTableName = 'Job' and ColUserId = 2




insert into SYSTM000ColumnsAlias( LangCode
,ColTableName
,ColAssociatedTableName
,ColColumnName
,ColAliasName
,ColCaption
,ColLookupId
,ColLookupCode
,ColDescription
,ColSortOrder
,ColIsReadOnly
,ColIsVisible
,ColIsDefault
,StatusId
,ColDisplayFormat
,ColAllowNegativeValue
,ColIsGroupBy
,ColMask
,IsGridColumn
,ColGridAliasName )

select LangCode
,'JobCard'
,ColAssociatedTableName
,ColColumnName
,ColAliasName
,ColCaption
,ColLookupId
,ColLookupCode
,ColDescription
,ColSortOrder
,ColIsReadOnly
,ColIsVisible
,ColIsDefault
,StatusId
,ColDisplayFormat
,ColAllowNegativeValue
,ColIsGroupBy
,ColMask
,IsGridColumn
,ColGridAliasName from SYSTM000ColumnsAlias where ColTableName = 'Job'
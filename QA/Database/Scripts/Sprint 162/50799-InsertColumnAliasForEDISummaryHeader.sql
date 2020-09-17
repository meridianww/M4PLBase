

declare @sortOrder int=0;
select @sortOrder=MAX(ColSortOrder)+1 
	from [dbo].[SYSTM000ColumnsAlias] where colTableName like 'EDISummaryHeader'

INSERT INTO [dbo].[SYSTM000ColumnsAlias]
SELECT 'EN'
	,'EDISummaryHeader'
	,NULL
	,'eshConsigneeContactEmail'
	,'Consignee Email'
	,'Consignee Email'
	,NULL
	,NULL
	,'Consignee Email'
	,@sortOrder
	,0
	,1
	,1
	,NULL
	,NULL
	,0
	,0
	,NULL
	,0
	,'Consignee Email'

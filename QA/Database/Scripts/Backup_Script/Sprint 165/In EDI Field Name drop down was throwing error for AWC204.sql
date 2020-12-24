	DECLARE @count int=0,
	@archiveStatusId int=0;
	select @count=count(1) from   [dbo].[SYSTM000ColumnsAlias] where ColTableName='EDISummaryHeader'  and colcolumnName='eshConsigneeContactEmail' AND ISNULL(StatusId,1)=1
	PRINT @count
	IF(@count>1)
	BEGIN
	
	SELECT @archiveStatusId=id from [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode='Status' AND SysOptionName='Archive'

	UPDATE [dbo].[SYSTM000ColumnsAlias] 
	SET StatusId=@archiveStatusId
	WHERE Id in (
	select Id FROM
	(SELECT ROW_NUMBER() OVER(PARTITION BY colcolumnName order by Id ASC) as 'RowNum',Id
	from   [dbo].[SYSTM000ColumnsAlias] 
	where ColTableName='EDISummaryHeader'  
	and colcolumnName='eshConsigneeContactEmail')sub 
	where sub.RowNum<>1	) 
	AND  ColTableName='EDISummaryHeader'  and colcolumnName='eshConsigneeContactEmail'

	END
	
		select* from   [dbo].[SYSTM000ColumnsAlias] 
		where ColTableName='EDISummaryHeader' 
		and colcolumnName='eshConsigneeContactEmail'
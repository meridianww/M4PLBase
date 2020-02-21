SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 26 June 2019     
-- Description   : Stored Procedure to Get Combo Box For Company
-- Execution Sample: EXEC [dbo].[GetProgramRollupBillingJob] 'EN',1,'RollUpBillingJob','RollUpBillingJob.Id,RollUpBillingJob.ColColumnName,RollUpBillingJob.ColAliasName',1,10,null,null,'',null,null,1,'Contact','Contact'
-- Modified		 : Kirty (Added condition for JobDriverContactInfo, should not include organization)
--=================================================================================                      
CREATE PROCEDURE [dbo].[GetProgramRollupBillingJob]
@langCode NVARCHAR(10)
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@fields NVARCHAR(2000)
	,@pageNo INT
	,@pageSize INT
	,@orderBy NVARCHAR(500)
	,@like NVARCHAR(500) = NULL
	,@where NVARCHAR(500) = NULL
	,@primaryKeyValue NVARCHAR(100) = NULL
	,@primaryKeyName NVARCHAR(50) = NULL
	,@parentId BIGINT = NULL
	,@entityFor NVARCHAR(50) = NULL
	,@parentEntity NVARCHAR(50) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX); 
 DECLARE @newPgNo INT

 SET @sqlCommand = '';

	 IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
		SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
						   ' From [dbo].[SYSTM000ColumnsAlias] (NOLOCK)  ' + @entity;
	
		SET @sqlCommand = @sqlCommand + ' WHERE '+  @entity +'.ColTableName ='+  'Job' + ' AND ColColumnName IN (''ProgramID'',
''JobSiteCode'',
''JobCustomerSalesOrder'',
''JobConsigneeCode'',
''JobBOLMaster'',
''JobBOLChild'',
''JobCustomerPurchaseOrder'',
''JobCarrierContract'',
''JobGatewayStatus'',
''JobBOL'',
''JobProductType'',
''JobServiceMode'',
''JobChannel'') ' + ' AND (ISNULL('+ @entity +'.StatusId, 1) In (1,2)  OR ' + @primaryKeyName + '=' + @primaryKeyValue + ')';
	    
	
		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
		print @sqlCommand
		EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
		SET @newPgNo =  @newPgNo/@pageSize + 1; 
		SET @pageSize = @newPgNo * @pageSize;
		SET @sqlCommand=''
	 END
	 
	 SET @sqlCommand += 'SELECT '+ @fields +' From [dbo].[SYSTM000ColumnsAlias] (NOLOCK) '+  @entity + ' WHERE 1=1 '  + ' AND '+ @entity +'.ColTableName =''Job''' + ' AND ColColumnName IN (''ProgramID'',
''JobSiteCode'',
''JobCustomerSalesOrder'',
''JobConsigneeCode'',
''JobBOLMaster'',
''JobBOLChild'',
''JobCustomerPurchaseOrder'',
''JobCarrierContract'',
''JobGatewayStatus'',
''JobBOL'',
''JobProductType'',
''JobServiceMode'',
''JobChannel'') ' 
	
     IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
          SET @sqlCommand = @sqlCommand + ' AND (ISNULL('+ @entity +'.StatusId, 1) = 1  OR  '+ @entity +'.' + @primaryKeyName + '=' + @primaryKeyValue + ')';
	 END
	 ELSE
	 BEGIN
	     SET @sqlCommand = @sqlCommand + ' AND ISNULL('+ @entity +'.StatusId, 1) = 1';
	 END

	 IF(ISNULL(@like, '') != '')  
	  BEGIN  
	  SET @sqlCommand = @sqlCommand + ' AND ('  
	   DECLARE @likeStmt NVARCHAR(MAX)  
  
	  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
	  SET @sqlCommand = @sqlCommand + @likeStmt + ') '  
	  END  
	 IF(ISNULL(@where, '') != '')  
	  BEGIN  
		 SET @sqlCommand = @sqlCommand + @where   
	 END  
	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   
 print @sqlCommand
	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100), @parentId BIGINT' ,  
		 @pageNo = @pageNo,   
		 @pageSize = @pageSize,  
		 @where = @where,
		 @parentId = @parentId

END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity    
 END CATCH 
GO

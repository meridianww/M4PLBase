SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Kamal
-- Date          : 04/27/2020     
-- Description   : Stored Procedure to Get Combo Box For Exception status
-- Execution Sample:  exec dbo.GetExceptionStatusDropDown @langCode=N'EN',@orgId=1,@entity=N'GwyExceptionCode',@fields=N'GwyExceptionCode.Id,GwyExceptionCode.JgeTitle,GwyExceptionCode.JgeReasonCode',@pageNo=1,@pageSize=10,@orderBy=NULL,@like=NULL,@where=N' AND GwyExceptionCode.JobID = 126881 ',@primaryKeyValue=NULL,@primaryKeyName=NULL,@parentId=126881,@currentAction=N'Exception-36'
-- Modified		 : 
--=================================================================================                      
CREATE PROCEDURE [dbo].[GetExceptionStatusDropDown]
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
	,@parentId BIGINT 
	,@currentAction NVARCHAR(100) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;
    DECLARE @sqlCommand NVARCHAR(MAX)
    , @newPgNo INT
	, @exceptionType NVARCHAR(30)
	, @companyId BIGINT = 0
	
	SELECT @companyId = ID FROM COMP000Master WHERE CompTableName ='Customer' AND CompPrimaryRecordId = @parentId AND StatusId =1

	SET @exceptionType = CASE WHEN @currentAction = 'exception'  THEN 0 ELSE 1 END;

 SET @sqlCommand = '';

	 IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
		SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
						   ' From [dbo].[JOBDL023GatewayInstallStatusMaster] (NOLOCK)  ' + @entity ;
	
		SET @sqlCommand = @sqlCommand + ' WHERE 1=1  AND '+ @entity +'.ExceptionType = '+ @exceptionType + ' AND ' + @entity +'.CompanyId = '+ CONVERT(NVARCHAR(20),@companyId) 
		 + ' AND ' + @primaryKeyName + '=' + @primaryKeyValue ;
	    
	
		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
	    
		EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
		
	 END
	 
	 SET @sqlCommand += 'SELECT DISTINCT '+ @fields +' From [dbo].[JOBDL023GatewayInstallStatusMaster] (NOLOCK) '+  @entity 
	 + ' WHERE 1=1 AND '+ @entity +'.ExceptionType = '+ @exceptionType + ' AND ' + @entity +'.CompanyId = '+ CONVERT(NVARCHAR(20),@companyId)

     IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
          SET @sqlCommand = @sqlCommand + ' AND ( '+ @entity +'.' + @primaryKeyName + '=' + @primaryKeyValue + ')';
	 END 

	 IF(ISNULL(@like, '') != '')  
	  BEGIN  
	  SET @sqlCommand = @sqlCommand + ' AND ('  
	   DECLARE @likeStmt NVARCHAR(MAX)  
  
	  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
	  SET @sqlCommand = @sqlCommand + @likeStmt + ') '  
	  END  

		
	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   
	
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

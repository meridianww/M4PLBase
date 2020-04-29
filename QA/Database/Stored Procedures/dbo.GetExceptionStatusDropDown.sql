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
-- Execution Sample: EXEC [dbo].[GetExceptionStatusDropDown] 'EN',1,'Cargo','GwyExceptionStatusCode.Id,GwyExceptionStatusCode.ExStatusDescription',1,10,null,null,null,null,null,1
-- Modified		 : 
--=================================================================================                      
ALTER PROCEDURE [dbo].[GetExceptionStatusDropDown]
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
    DECLARE @sqlCommand NVARCHAR(MAX); 
    DECLARE @newPgNo INT
	DECLARE @exceptionType NVARCHAR(30)

	SET @exceptionType = CASE WHEN @currentAction = 'exception'  THEN '''exception 0''' ELSE  '''exception 1''' END;
	 --SELECT @exceptionType = CASE WHEN COUNT(GwyExceptionCode.Id) > 0 THEN '''exception 0''' ELSE  '''exception 1''' END
	 --FROM [dbo].[JOBDL022GatewayExceptionReason] (NOLOCK) GwyExceptionCode
	 --INNER JOIN [dbo].[JOBDL021GatewayExceptionCode] (NOLOCK) JGEC ON JGEC.Id =  GwyExceptionCode.JGExceptionId
	 --WHERE JGEC.CustomerId IN (SELECT PrgCustID FROM PRGRM000Master WHERE Id IN (SELECT ProgramID FROM JOBDL000Master WHERE ID = @parentId))

 SET @sqlCommand = '';

	 IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
		SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
						   ' From [dbo].[JOBDL023GatewayInstallStatusMaster] (NOLOCK)  ' + @entity;
	
		SET @sqlCommand = @sqlCommand + ' WHERE 1=1  AND '+ @entity +'.ExceptionType = '+ @exceptionType+ '' 
		+ @primaryKeyName + '=' + @primaryKeyValue + ')';
	    
	
		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
	
		EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
		SET @newPgNo =  @newPgNo/@pageSize + 1; 
		SET @pageSize = @newPgNo * @pageSize;
		SET @sqlCommand=''
	 END
	 
	 SET @sqlCommand += 'SELECT '+ @fields +' From [dbo].[JOBDL023GatewayInstallStatusMaster] (NOLOCK) '+  @entity 
	 + ' WHERE 1=1 AND '+ @entity +'.ExceptionType = '+ @exceptionType

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
	 --IF(ISNULL(@where, '') != '')  
	 -- BEGIN  
		-- SET @sqlCommand = @sqlCommand + @where   
	 -- END  
		
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

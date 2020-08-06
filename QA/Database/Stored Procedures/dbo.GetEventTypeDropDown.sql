SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               08/06/2020    
-- Description:               Get selected Event records by table
-- Execution:                 EXEC [dbo].[GetEventTypeDropDown]   

-- =============================================                          
CREATE PROCEDURE [dbo].[GetEventTypeDropDown]
 @langCode NVARCHAR(10),
 @orgId BIGINT,  
 @entity NVARCHAR(100),
 @fields NVARCHAR(2000),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @like NVARCHAR(500) = NULL,
 @where NVARCHAR(500) = null,
 @primaryKeyValue NVARCHAR(100) = null,
 @primaryKeyName NVARCHAR(50) = null,
 @parentId BIGINT = 0
AS    
BEGIN TRY
	SET NOCOUNT ON;
    DECLARE @sqlCommand NVARCHAR(MAX)
    , @newPgNo INT

 SET @sqlCommand = '';

	 IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
		SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
						   ' From [dbo].[EventType] (NOLOCK)  ' + @entity ;
	
		SET @sqlCommand = @sqlCommand + ' WHERE 1=1  AND ' + @primaryKeyName + '=' + @primaryKeyValue ;
	    
	
		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
	    
		EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
		
	 END
	 
	 SET @sqlCommand += 'SELECT DISTINCT '+ @fields +' From [dbo].[EventType] (NOLOCK) '+  @entity 
	 
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

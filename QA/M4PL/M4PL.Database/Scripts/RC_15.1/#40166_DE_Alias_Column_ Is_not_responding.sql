
GO
PRINT N'Altering [dbo].[GetColumnAliasView]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all Column Aliases
-- Execution:                 EXEC [dbo].[GetColumnAliasView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetColumnAliasView]    
	@userId INT,    
	@roleId BIGINT,    
	@orgId BIGINT,    
	@langCode NVARCHAR(10),    
	@entity NVARCHAR(100),    
	@pageNo INT,    
	@pageSize INT,    
	@orderBy NVARCHAR(500), 
	@groupBy NVARCHAR(500), 
	@groupByWhere NVARCHAR(500),    
	@where NVARCHAR(500),    
	@parentId BIGINT,    
	@isNext BIT,    
	@isEnd BIT,    
	@recordId BIGINT,    
	@TotalCount INT OUTPUT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;      
 DECLARE @sqlCommand NVARCHAR(MAX);    
 DECLARE @TCountQuery NVARCHAR(MAX);    
    
 SET @TCountQuery = 'SELECT @TotalCount = COUNT('+ @entity + '.Id) FROM [dbo].[SYSTM000ColumnsAlias] '+ @entity;
 
 --Below for getting user specific 'Statuses'  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses]('+ CAST(@userId AS NVARCHAR(50))+') fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

 SET @TCountQuery = @TCountQuery + ' WHERE '+ @entity + '.LangCode = @langCode ' + ISNULL(@where, '') ;

 EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT',@langCode ,@TotalCount  OUTPUT;    
     
 IF(@recordId = 0)    
  BEGIN    
   SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  END    
 ELSE    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))    
   BEGIN    
     SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id '    
   END    
  ELSE IF((@isNext = 1) AND (@isEnd = 0))    
   BEGIN    
     SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id '     
   END    
  ELSE    
   BEGIN    
    SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '    
   END    
 END    
    
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) '+ @entity  
 
 --Below for getting user specific 'Statuses'  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses]('+ CAST(@userId AS NVARCHAR(50))+') hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	
	--Below to update order by clause if related to Ref_Options
	IF(ISNULL(@orderBy, '') <> '')
	BEGIN
		DECLARE @orderByJoinClause NVARCHAR(500);
		SELECT @orderBy = OrderClause, @orderByJoinClause=JoinClause FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);
		IF(ISNULL(@orderByJoinClause, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + @orderByJoinClause
		END
	END
   
 SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode '+ ISNULL(@where, '')    
    
 IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
 END    
    
 SET @sqlCommand = @sqlCommand + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id')    
    
 IF(@recordId = 0)    
 BEGIN    
	SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
 END    
 ELSE    
  BEGIN    
   IF(@orderBy IS NULL)    
    BEGIN    
     IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))    
      BEGIN    
       SET @sqlCommand = @sqlCommand + ' DESC'     
      END    
    END    
   ELSE    
    BEGIN    
     IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))    
      BEGIN    
       SET @sqlCommand = @sqlCommand + ' DESC'     
      END    
    END    
  END    
    
 EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10), @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500),@userId BIGINT' ,    
     @langCode= @langCode,    
     @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where,    
     @userId = @userId    
     
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
PRINT N'Update complete.';


GO

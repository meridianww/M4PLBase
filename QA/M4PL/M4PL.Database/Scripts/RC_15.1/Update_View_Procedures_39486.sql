/****** Object:  UserDefinedFunction [dbo].[fnGetDelSqlCmdByLvlAndEntity]    Script Date: 12/26/2018 11:11:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil
-- Create date:               12/26/2018      
-- Description:               To get updated sorting qeury for Ref_options tables
-- Modified on:  
-- ============================================= 

CREATE FUNCTION [dbo].[fnUpdateOrderByClause]  
(
	@entity NVARCHAR(100),
	@orderBy NVARCHAR(500) 
)
RETURNS @orderClauseResult TABLE (
   OrderClause NVARCHAR(500),
   JoinClause NVARCHAR(500)
)
AS
BEGIN
	DECLARE @updatedOrderByClause NVARCHAR(500)=@orderBy, @joinClause NVARCHAR(500)='';

	IF((CHARINDEX(',', @orderBy) = 0) AND (@orderBy LIKE '%'+@entity+'.%'))
	BEGIN
		DECLARE @tempOrderByTable TABLE(Item NVARCHAR(1000));
		DECLARE @currentColumnNameWithEntity NVARCHAR(500),@currentColumnName NVARCHAR(500), @currentSortOrder NVARCHAR(50), @currentLookupId INT = NULL;
		INSERT INTO @tempOrderByTable SELECT Item FROM [dbo].[fnSplitString](@orderBy, ' ');
		SELECT @currentColumnNameWithEntity = Item FROM @tempOrderByTable WHERE Item LIKE '%'+@entity+'.%';
		SELECT @currentSortOrder = Item FROM @tempOrderByTable WHERE (ISNULL(Item, '') <> '') AND ITEM NOT LIKE '%'+@entity+'.%'; 
		SELECT @currentColumnName = REPLACE(@currentColumnNameWithEntity, @entity+'.', '');
		SELECT @currentLookupId=ColLookupId FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = @entity AND ColColumnName = @currentColumnName;
		IF(ISNULL(@currentLookupId, 0) > 0)
		BEGIN
			SET @joinClause = ' LEFT JOIN [dbo].[SYSTM000Ref_Options] refOpOrderBy ON ' + @currentColumnNameWithEntity + '=refOpOrderBy.Id AND refOpOrderBy.SysLookupId=' + CAST(@currentLookupId AS NVARCHAR(100)) + ' ';
			SET @updatedOrderByClause =  ' refOpOrderBy.SysOptionName ' + @currentSortOrder + ' ';
		END
	END

	INSERT INTO @orderClauseResult(OrderClause, JoinClause) VALUES(@updatedOrderByClause, @joinClause);

	RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[GetAttachmentView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               11/10/2018      
-- Description:               Get all attachemnets for particular module and record
-- Execution:                 EXEC [dbo].[GetAttachmentView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetAttachmentView]
	 @userId BIGINT,
	 @roleId BIGINT,
	 @orgId BIGINT,
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
 SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM020Ref_Attachments] (NOLOCK) '+ @entity;
 --Below for getting user specific 'Statuses'  
 SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '; 

 SET @TCountQuery = @TCountQuery + ' WHERE '+ @entity +'.AttPrimaryRecordID= @parentId ' + ISNULL(@where, '');
  
 EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,  @TotalCount INT OUTPUT', @parentId,  @TotalCount  OUTPUT;

SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM020Ref_Attachments] (NOLOCK) '+ @entity

--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	
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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[AttPrimaryRecordID] = @parentId '+ ISNULL(@where, '') + 
	' ORDER BY '+ ISNULL(@orderBy, @entity+'.AttItemNumber') + 
	' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100)' ,
     @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
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
/****** Object:  StoredProcedure [dbo].[GetColumnAliasView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

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
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	
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
/****** Object:  StoredProcedure [dbo].[GetContactView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all contact view
-- Execution:                 EXEC [dbo].[GetContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery +' WHERE 1=1 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @TotalCount INT OUTPUT', @userId , @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , sts1.[StateAbbr] AS ConBusinessStateIdName, sts2.[StateAbbr] AS ConHomeStateIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity

--Below to get State reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts1 ON ' + @entity + '.[ConBusinessStateId]=sts1.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts2 ON ' + @entity + '.[ConHomeStateId]=sts2.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
	    BEGIN  
	 	IF(ISNULL(@orderBy, '') <> '')
	 	 BEGIN
	 		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
	 		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetCustBusinessTermView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               04/14/2018        
-- Description:               Get all customer business term  
-- Execution:                 EXEC [dbo].[GetCustBusinessTermView]  
-- Modified on:              04/25/2018
-- Modified Desc:           Removed langCode Filter 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================  
ALTER PROCEDURE [dbo].[GetCustBusinessTermView]  
 @userId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
  
SET @TCountQuery = @TCountQuery + ' WHERE [CbtOrgId] = @orgId AND [CbtCustomerId] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS CbtOrgIDName, cust.[CustCode] AS CbtCustomerIdName '  
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
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CbtOrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CbtCustomerId]=cust.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[CbtCustomerId]=@parentId AND '  
SET @sqlCommand = @sqlCommand + @entity +'.[CbtOrgId] = @orgId '+ ISNULL(@where, '')  
  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @parentId = @parentId,  
  @userId = @userId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustContactView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer contact
-- Execution:                 EXEC [dbo].[GetCustContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetCustContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--Below to get BIGINT reference key name by Id if NOT NULL
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustCustomerID]=cust.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CustContactMSTRID]=cont.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

SET @TCountQuery = @TCountQuery + ' WHERE [CustCustomerID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
 BEGIN

	IF(@recordId = 0)
		BEGIN
			SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
			SET @sqlCommand = @sqlCommand + ' , cust.[CustCode] AS CustCustomerIDName, cont.[ConFullName] AS CustContactMSTRIDName '
			SET @sqlCommand = @sqlCommand + ' , cont.[ConJobTitle] AS ConJobTitle, cont.[ConEmailAddress] AS ConEmailAddress '
			SET @sqlCommand = @sqlCommand + ' , cont.[ConMobilePhone] AS ConMobilePhone, cont.[ConBusinessPhone] AS ConBusinessPhone '
			SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1, cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
			SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessCity] AS ConBusinessCity, cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
			SET @sqlCommand = @sqlCommand + ' , sts.[StateAbbr] AS ConBusinessStateIdName, sysRef.[SysOptionName] AS ConBusinessCountryIdName '
			SET @sqlCommand = @sqlCommand + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress '
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
	
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity
	
	--Below to get BIGINT reference key name by Id if NOT NULL
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustCustomerID]=cust.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CustContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
	
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

	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CustCustomerID] = @parentId ' + ISNULL(@groupByWhere, '')  
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
		BEGIN
			IF((@isNext = 0) AND (@isEnd = 0))  
	   BEGIN  
		IF(ISNULL(@orderBy, '') <> '')
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
			SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
		 END
		ELSE
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
		 END
	   END   
		END
	
	SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id')
	
	IF(@recordId = 0)
		BEGIN
			IF(ISNULL(@groupByWhere, '') <> '')
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END
			ELSE
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END     
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

END
ELSE
 BEGIN
	
	DECLARE @SelectClauseToAdd NVARCHAR(500) = '';

	IF(@groupBy = (@entity + '.CustCustomerIDName'))
	 BEGIN
		SET @groupBy = ' cust.[CustCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cust.[CustCode] AS CustCustomerIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.CustContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS CustContactMSTRIDName ';
	 END
	 ELSE IF(@groupBy = (@entity + '.ConJobTitle'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConJobTitle] AS ConJobTitle '
	 END
	ELSE IF(@groupBy = (@entity + '.ConEmailAddress'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConEmailAddress] AS ConEmailAddress '
	 END
	 ELSE IF(@groupBy = (@entity + '.ConMobilePhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConMobilePhone] AS ConMobilePhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessPhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessPhone] AS ConBusinessPhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress1'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress2'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCity'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessCity] AS ConBusinessCity '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessZipPostal'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessStateIdName'))
	 BEGIN
		SET @groupBy = ' sts.[StateAbbr] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sts.[StateAbbr] AS ConBusinessStateIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCountryIdName'))
	 BEGIN
		SET @groupBy = ' sysRef.[SysOptionName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sysRef.[SysOptionName] AS ConBusinessCountryIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessFullAddress'))
	 BEGIN
		SET @groupBy = ' ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress ';
		SET @orderBy = REPLACE(@orderBy, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )');
	 END


	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount '
	SET @sqlCommand = @sqlCommand + @SelectClauseToAdd
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity 
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustCustomerID]=cust.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CustContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CustCustomerID] = @parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END
 END
 
 --To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CustCustomerIDName', 'cust.[CustCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CustContactMSTRIDName', 'cont.[ConFullName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConJobTitle', 'ConJobTitle')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConEmailAddress', 'ConEmailAddress')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConMobilePhone', 'ConMobilePhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessPhone', 'ConBusinessPhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress1', 'ConBusinessAddress1')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress2', 'ConBusinessAddress2')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCity', 'ConBusinessCity')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessZipPostal', 'ConBusinessZipPostal')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessStateIdName', 'sts.[StateAbbr]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCountryIdName', 'sysRef.[SysOptionName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessFullAddress', 'ConBusinessFullAddress')

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustDcLocationContactView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/25/2018        
-- Description:               Get all Customer DC Location Contact 
-- Execution:                 EXEC [dbo].[GetCustDcLocationContactView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)               
-- Modified Desc:           
-- =============================================  
ALTER PROCEDURE [dbo].[GetCustDcLocationContactView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] ' 
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ClcContactMSTRID]=cont.[Id] '  
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] '   
  
SET @TCountQuery = @TCountQuery + ' WHERE [ClcCustDcLocationId] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS ClcContactMSTRIDName, refOp.SysOptionName AS CustomerType, cont.ConBusinessPhone AS ConBusinessPhone, cont.ConBusinessPhoneExt AS ConBusinessPhoneExt, cont.ConMobilePhone AS ConMobilePhone '  
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
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ClcContactMSTRID]=cont.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[ClcCustDcLocationId]=@parentId ' + ISNULL(@where, '')  
  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
  @entity= @entity,  
  @pageNo= @pageNo,   
  @pageSize= @pageSize,  
  @orderBy = @orderBy,  
  @where = @where,  
  @orgId = @orgId,  
  @parentId = @parentId,  
  @userId = @userId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustDcLocationView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer dc location
-- Execution:                 EXEC [dbo].[GetCustDcLocationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetCustDcLocationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--Below to get BIGINT reference key name by Id if NOT NULL
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdcCustomerID]=cust.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CdcContactMSTRID]=cont.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

SET @TCountQuery = @TCountQuery + ' WHERE [CdcCustomerID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
BEGIN

	IF(@recordId = 0)
	BEGIN 
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , cust.[CustCode] AS CdcCustomerIDName, cont.[ConFullName] AS CdcContactMSTRIDName '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConJobTitle] AS ConJobTitle, cont.[ConEmailAddress] AS ConEmailAddress '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConMobilePhone] AS ConMobilePhone, cont.[ConBusinessPhone] AS ConBusinessPhone '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1, cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessCity] AS ConBusinessCity, cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
		SET @sqlCommand = @sqlCommand + ' , sts.[StateAbbr] AS ConBusinessStateIdName, sysRef.[SysOptionName] AS ConBusinessCountryIdName '
		SET @sqlCommand = @sqlCommand + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress '
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
	
	SET @sqlCommand = @sqlCommand +' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity
	
	--Below to get BIGINT reference key name by Id if NOT NULL
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdcCustomerID]=cust.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CdcContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	
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

	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CdcCustomerID]=@parentId ' + ISNULL(@groupByWhere, '')  
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END
	
	SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id') 
	
	IF(@recordId = 0)
	BEGIN
			IF(ISNULL(@groupByWhere, '') <> '')
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END
			ELSE
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END     
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

END
ELSE
BEGIN
	
	DECLARE @SelectClauseToAdd NVARCHAR(500) = '';

	IF(@groupBy = (@entity + '.CdcCustomerIDName'))
	 BEGIN
		SET @groupBy = ' cust.[CustCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cust.[CustCode] AS CdcCustomerIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.CdcContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS CdcContactMSTRIDName ';
	 END
	 ELSE IF(@groupBy = (@entity + '.ConJobTitle'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConJobTitle] AS ConJobTitle '
	 END
	ELSE IF(@groupBy = (@entity + '.ConEmailAddress'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConEmailAddress] AS ConEmailAddress '
	 END
	 ELSE IF(@groupBy = (@entity + '.ConMobilePhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConMobilePhone] AS ConMobilePhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessPhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessPhone] AS ConBusinessPhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress1'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress2'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCity'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessCity] AS ConBusinessCity '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessZipPostal'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessStateIdName'))
	 BEGIN
		SET @groupBy = ' sts.[StateAbbr] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sts.[StateAbbr] AS ConBusinessStateIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCountryIdName'))
	 BEGIN
		SET @groupBy = ' sysRef.[SysOptionName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sysRef.[SysOptionName] AS ConBusinessCountryIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessFullAddress'))
	 BEGIN
		SET @groupBy = ' ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress ';
		SET @orderBy = REPLACE(@orderBy, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )');
	 END


	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount '
	SET @sqlCommand = @sqlCommand + @SelectClauseToAdd
	SET @sqlCommand = @sqlCommand +' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdcCustomerID]=cust.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CdcContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')
	
	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CdcCustomerID]=@parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END

END

	--To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CdcCustomerIDName', 'cust.[CustCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CdcContactMSTRIDName', 'cont.[ConFullName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConJobTitle', 'ConJobTitle')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConEmailAddress', 'ConEmailAddress')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConMobilePhone', 'ConMobilePhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessPhone', 'ConBusinessPhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress1', 'ConBusinessAddress1')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress2', 'ConBusinessAddress2')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCity', 'ConBusinessCity')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessZipPostal', 'ConBusinessZipPostal')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessStateIdName', 'sts.[StateAbbr]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCountryIdName', 'sysRef.[SysOptionName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessFullAddress', 'ConBusinessFullAddress')

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustDocReferenceView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer document reference 
-- Execution:                 EXEC [dbo].[GetCustDocReferenceView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetCustDocReferenceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [CdrCustomerID] = @parentId AND [CdrOrgId] = @orgId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;
 
IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS CdrOrgIDName, cust.[CustCode] AS CdrCustomerIDName '
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

SET @sqlCommand = @sqlCommand +' FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CdrOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdrCustomerID]=cust.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CdrOrgId] = @orgId AND '+@entity+'.[CdrCustomerID] = @parentId '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand+ ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id') 

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustFinacialCalenderView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer financial calander
-- Execution:                 EXEC [dbo].[GetCustFinacialCalenderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetCustFinacialCalenderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [CustID] = @parentId AND [OrgId] = @orgId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, cust.[CustCode] AS CustIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustID]=cust.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+@entity+'.[CustID] = @parentId '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all customer
-- Execution:                 EXEC [dbo].[GetCustomerView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetCustomerView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
 
 SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity   
 --Below for getting user specific 'Statuses'  
 SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
   
 SET @TCountQuery = @TCountQuery + ' WHERE [CustOrgId] = @orgId ' + ISNULL(@where, '')
   
 EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;  

 IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
  BEGIN
	  
	IF(@recordId = 0)  
	 BEGIN  
	  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
	  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS CustOrgIdName, contWA.[ConFullName] AS CustWorkAddressIdName, ' +   
	        ' contBA.[ConFullName] AS CustBusinessAddressIdName, contCA.[ConFullName] AS CustCorporateAddressIdName '  ;
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
	  
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity  
	--Below to get BIGINT reference key name by Id if NOT NULL  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CustOrgId] = org.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[CustWorkAddressId] = contWA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[CustBusinessAddressId] = contBA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[CustCorporateAddressId] = contCA.[Id] ' ; 
	
	--Below for getting user specific 'Statuses'  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	
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

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CustOrgId] = @orgId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  
	  
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
	 BEGIN  
	  IF((@isNext = 0) AND (@isEnd = 0))  
	   BEGIN  
		IF((ISNULL(@orderBy, '') <> '') AND (CHARINDEX(',', @orderBy) = 0))
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
		 END
		ELSE
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))
		 END
	   END  
	  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
	   BEGIN  
	    IF((ISNULL(@orderBy, '') <> '') AND (CHARINDEX(',', @orderBy) = 0))
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
	  IF(ISNULL(@groupByWhere, '') <> '')
	   BEGIN
		  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
	   END
	  ELSE
	   BEGIN
		  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
	   END
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

 END
 ELSE
  BEGIN
	
	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CustOrgId] = org.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[CustWorkAddressId] = contWA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[CustBusinessAddressId] = contBA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[CustCorporateAddressId] = contCA.[Id] ' ; 
	--Below for getting user specific 'Statuses'  
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
	 BEGIN  
	  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	 END  

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CustOrgId] = @orgId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END
  END

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@groupBy NVARCHAR(500)' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @userId = @userId,
  @groupBy = @groupBy  
  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDashboardView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/01/2018      
-- Description:               Get all Dashboards
-- Execution:                 EXEC [dbo].[GetDashboardView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetDashboardView]
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

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity +' WHERE [OrganizationId] = @orgId ' + ISNULL(@where, '')
	EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @TotalCount INT OUTPUT',@orgId ,@TotalCount  OUTPUT;
	
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

	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity

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

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrganizationId] = @orgId '+ ISNULL(@where, '')
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orgId BIGINT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500)' ,
					@orgId= @orgId,
					@entity= @entity,
					@pageNo= @pageNo, 
					@pageSize= @pageSize,
					@orderBy = @orderBy,
					@where = @where
	
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDeliveryStatusView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               06/06/2018      
-- Description:               Get all DeliveryStatus 
-- Execution:                 EXEC [dbo].[GetDeliveryStatusView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetDeliveryStatusView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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
 DECLARE @isSysAdmin BIT;

SELECT @isSysAdmin = [IsSysAdmin] FROM [dbo].[SYSTM000OpnSezMe] WHERE [Id] = @userId

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Delivery_Status] (NOLOCK) '+ @entity 

IF(@isSysAdmin = 0)
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE ' + @entity + '.OrganizationId=@orgId ' + ISNULL(@where, '')
	END
ELSE
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE 1=1' + ISNULL(@where, '')
	END

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @orgId BIGINT, @TotalCount INT OUTPUT', @userId, @orgId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		 SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrganizationIdName ' 
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
		
SET @sqlCommand = @sqlCommand +' FROM [dbo].[SYSTM000Delivery_Status] (NOLOCK) '+ @entity
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrganizationId] = org.[Id] '  

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

IF(@isSysAdmin = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.OrganizationId= @orgId ' + ISNULL(@where, '');
		SET @sqlCommand  = REPLACE(@sqlCommand,@entity + '.ItemNumber','1 as ItemNumber');
	END
ELSE
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE 1=1 ' + ISNULL(@where, '')
	END

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT, @orgId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @userId = @userId,
	 @orgId= @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobAttributeView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Attribute 
-- Execution:                 EXEC [dbo].[GetJobAttributeView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetJobAttributeView]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
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

 IF @parentId = 0
 BEGIN
     
     DECLARE @prgAttTable TABLE(
	[Id]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [JobID]                   BIGINT          NULL,
    [AjbLineOrder]            INT             NULL,
    [AjbAttributeCode]        NVARCHAR (20)   NULL,
    [AjbAttributeTitle]       NVARCHAR (50)   NULL,
    [AjbAttributeQty]         DECIMAL (18, 2) NULL,
    [AjbUnitTypeId]           INT             NULL,
    [AjbDefault]              BIT             NULL,
    [StatusId]                INT             NULL
     )

	 --INSERT INTO @prgAttTable(JobID,AjbLineOrder,AjbAttributeCode,AjbAttributeTitle,AjbAttributeQty,AjbUnitTypeId,AjbDefault,StatusId)
	 --SELECT 0,prgm.AttItemNumber,prgm.AttCode,prgm.AttTitle,prgm.AttQuantity,prgm.UnitTypeId,prgm.AttDefault,prgm.StatusId 
	 --FROM [dbo].[PRGRM020Ref_AttributesDefault] prgm
	 --INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	 --WHERE AttDefault = 1;

	 --SELECT @TotalCount = COUNT(Id) FROM @prgAttTable
	 
	 --SELECT * FROM @prgAttTable prgAtt
	 --ORDER BY prgAtt.Id
	 --OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)

 END
 ELSE
 BEGIN


  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
  
SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName, job.[JobCompleted] AS JobCompleted '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
  
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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @parentId = @parentId,  
  @userId = @userId  
END
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobCargoView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Cargo  
-- Execution:                 EXEC [dbo].[GetJobCargoView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetJobCargoView]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
  
SET @TCountQuery = @TCountQuery + ' WHERE '+ @entity +'.JobID = @parentId ' + ISNULL(@where, '')  

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount OUTPUT;  
   
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName , job.[JobCompleted] AS JobCompleted'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @parentId = @parentId,  
  @userId = @userId  
END TRY   
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobDocReferenceView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Attribute
-- Execution:                 EXEC [dbo].[GetJobDocReferenceView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetJobDocReferenceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName , job.[JobCompleted] AS JobCompleted'
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobGatewayView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Gateway
-- Execution:                 EXEC [dbo].[GetJobGatewayView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetJobGatewayView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

 IF @parentId = 0
 BEGIN
     
     DECLARE @prgGatewayTable TABLE(
	     [Id]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [JobID]                 BIGINT          NULL,
    [ProgramID]             BIGINT          NULL,
    [GwyGatewaySortOrder]   INT             NULL,
    [GwyGatewayCode]        NVARCHAR (20)   NULL,
    [GwyGatewayTitle]       NVARCHAR (50)   NULL,    
    [GwyGatewayDuration]    DECIMAL (18, 2) NULL,
	[GatewayUnitId]         INT             NULL,
	[GwyGatewayDefault]     BIT             NULL,
	[GatewayTypeId]         INT             NULL,  
    [GwyDateRefTypeId]      INT             NULL,
    [StatusId]              INT             NULL
     )

	-- INSERT INTO @prgGatewayTable(JobID,ProgramID,GwyGatewaySortOrder,GwyGatewayCode,GwyGatewayTitle,GwyGatewayDuration,GatewayUnitId,GwyGatewayDefault,GatewayTypeId,GwyDateRefTypeId,StatusId)
	--SELECT   
	-- 0
 --   ,prgm.[PgdProgramID]          
 --   ,prgm.[PgdGatewaySortOrder]   
 --   ,prgm.[PgdGatewayCode]        
 --   ,prgm.[PgdGatewayTitle] 
 --   ,prgm.[PgdGatewayDuration]    
 --   ,prgm.[UnitTypeId]            
 --   ,prgm.[PgdGatewayDefault]     
 --   ,prgm.[GatewayTypeId]         
 --   ,prgm.[GatewayDateRefTypeId]  
 --   ,prgm.[StatusId]   
	-- FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
	-- INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	-- WHERE PgdGatewayDefault = 1;

	-- SELECT @TotalCount = COUNT(Id) FROM @prgGatewayTable
	 
	-- SELECT * FROM @prgGatewayTable 
	-- ORDER BY Id
	-- OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)

 END
 ELSE
 BEGIN


SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
--IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
--	BEGIN
--		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--	END

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName, prg.[PrgProgramTitle] AS ProgramIDName , CASE WHEN cont.Id > 0 OR ' + @entity + '.GwyClosedBy IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist, job.[JobCompleted] AS JobCompleted'
		SET @sqlCommand = @sqlCommand + '  , respContact.[ConFullName] AS GwyGatewayResponsibleName ,  anaContact.[ConFullName] AS GwyGatewayAnalystName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] ';
SET @sqlCommand = @sqlCommand + ' LEFT JOIN CONTC000Master cont ON ' + @entity + '.GwyClosedBy = cont.ConFullName AND cont.StatusId  =1 '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) respContact ON ' + @entity + '.[GwyGatewayResponsible]=respContact.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaContact ON ' + @entity + '.[GwyGatewayAnalyst]=anaContact.[Id] '

--Below for getting user specific 'Statuses'
--IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
--	BEGIN
--		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
--	END

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobRefCostSheetView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[GetJobRefCostSheetView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetJobRefCostSheetView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,@userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobRefStatusView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Ref Status
-- Execution:                 EXEC [dbo].[GetJobRefStatusView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetJobRefStatusView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job 
-- Execution:                 EXEC [dbo].[GetJobView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE [dbo].[GetJobView]      
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
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

      
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity     
    
--Below for getting user specific 'Statuses'    
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '    
     
SET @TCountQuery =  @TCountQuery + ' WHERE 1=1 AND ProgramID = ISNULL(@parentId,ProgramID) ' + ISNULL(@where, '')     
    
EXEC sp_executesql @TCountQuery, N'@TotalCount INT OUTPUT, @userId BIGINT,@parentId BIGINT', @TotalCount  OUTPUT, @userId, @parentId = @parentId;      
      
IF(@recordId = 0)    
 BEGIN       
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
  
  SET @sqlCommand = @sqlCommand + ' , CASE WHEN prg.PrgHierarchyLevel = 1 THEN prg.PrgProgramCode
                                  WHEN prg.PrgHierarchyLevel = 2 THEN prg.PrgProjectCode
							 WHEN prg.PrgHierarchyLevel = 3 THEN prg.PrgPhaseCode
							 ELSE prg.PrgProgramTitle END  AS ProgramIDName '
  
        
  SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS JobDeliveryResponsibleContactIDName, anaCont.[ConFullName] AS JobDeliveryAnalystContactIDName,driverCont.[ConFullName] AS JobDriverIdName'    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity      
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[JobDeliveryResponsibleContactID]=cont.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaCont ON ' + @entity + '.[JobDeliveryAnalystContactID]=anaCont.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) driverCont ON ' + @entity + '.[JobDriverId]=driverCont.[Id] '    

    
--Below for getting user specific 'Statuses'    
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '    

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
    
SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.ProgramID = ISNULL(@parentId,'+@entity+'.ProgramID)'+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
      
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@parentId BIGINT,@userId BIGINT' ,      
  @entity= @entity,      
 @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,    
  @parentId = @parentId ,    
  @userId = @userId    
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuAccessLevelView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all menu access level 
-- Execution:                 EXEC [dbo].[GetMenuAccessLevelView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetMenuAccessLevelView]
 @userId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity

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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @langCode NVARCHAR(10), @entity NVARCHAR(100),@userId BIGINT' ,
     @langCode= @langCode,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuDriverView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all menu driver  
-- Execution:                 EXEC [dbo].[GetMenuDriverView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetMenuDriverView]
 @userId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity

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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10), @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500)' ,
    @entity = @entity,
    @langCode= @langCode,
    @pageNo= @pageNo, 
    @pageSize= @pageSize,
    @orderBy = @orderBy,
	@where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuOptionLevelView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/22/2018        
-- Description:               Get all menu option level     
-- Execution:                 EXEC [dbo].[GetMenuOptionLevelView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)      
-- Modified Desc:    
-- =============================================   
ALTER PROCEDURE [dbo].[GetMenuOptionLevelView]  
 @userId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')  
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)  + ' ,acc.MalTitle as MolMenuAccessDefaultName'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity  
SET @sqlCommand = @sqlCommand + ' INNER JOIN SYSTM010MenuAccessLevel (NOLOCK) acc ON '+ @entity+'.MolMenuAccessDefault = acc.MalOrder '       

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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @langCode NVARCHAR(10), @entity NVARCHAR(100)' ,  
     @langCode= @langCode,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMessageTypeView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all message type   
-- Execution:                 EXEC [dbo].[GetMessageTypeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetMessageTypeView]      
 @userId BIGINT,      
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
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSMS010Ref_MessageTypes] '+@entity+' INNER JOIN SYSTM000Ref_Options ref ON '+@entity+'.SysRefId = ref.Id  WHERE '+@entity+'.LangCode = @langCode AND ref.SysLookupId=27 ' + ISNULL(@where, '')      
  
    
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;      
      
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
      
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSMS010Ref_MessageTypes] (NOLOCK) '+ @entity      
SET @sqlCommand = @sqlCommand + ' INNER JOIN SYSTM000Ref_Options (NOLOCK) ref ON '+ @entity+'.SysRefId = ref.Id '       

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode  AND ref.SysLookupId=27 '+ ISNULL(@where, '')      
  
    
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))      
 BEGIN      
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSMS010Ref_MessageTypes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSMS010Ref_MessageTypes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
      
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@langCode NVARCHAR(10), @entity NVARCHAR(100)' ,      
  @langCode= @langCode,      
  @entity= @entity,      
     @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActRoleView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get all organization act role
-- Execution:                 EXEC [dbo].[GetOrgActRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
    
ALTER PROCEDURE [dbo].[GetOrgActRoleView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '  
  
IF(@parentId > 0)  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')  
 END  
ELSE  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @orgId ' + ISNULL(@where, '')  
 END  
  
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)  ;
 
  --IF(CHARINDEX(@entity+'.OrgRoleTitle',@sqlCommand) > 0)
  --BEGIN
  --   SET  @sqlCommand = REPLACE(@sqlCommand, @entity+'.OrgRoleTitle', 'rol.OrgRoleTitle');
  --END
   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, org.Id AS OrganizationId, cont.[ConFullName] AS OrgRoleContactIDName, rol.OrgRoleCode as OrgRefRoleIdName, ' + @entity + '.StatusId as PreviousStatusId '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[OrgRefRoleId] = rol.[Id] '      
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[OrgRoleContactID]=cont.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
  
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

IF(@parentId > 0)  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')  
 END  
ELSE  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @orgId '+ ISNULL(@where, '')  
 END  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT, @parentId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @userId = @userId,  
  @parentId = @parentId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActSecurityByRoleView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get all org act security by role
-- Execution:                 EXEC [dbo].[GetOrgActSecurityByRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================      
ALTER PROCEDURE [dbo].[GetOrgActSecurityByRoleView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity +' WHERE [OrgId] = @orgId AND [OrgActRoleId] =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT,@TotalCount INT OUTPUT', @orgId, @parentId, @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIdName, actRole.[OrgRoleTitle] as OrgActRoleIdName, cont.[ConFullName] as ContactIdName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole ON ' + @entity + '.[OrgActRoleId]=actRole.[Id] '   
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ContactId]=cont.[Id] '   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgId]=org.[Id] '   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON actRole.[OrgRefRoleId] = rol.[Id] '  

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+@entity+'.OrgActRoleId =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
 
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100) ,@parentId BIGINT' ,    
  @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where,    
  @orgId = @orgId,  
  @parentId = @parentId    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActSubSecurityByRoleView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get all org act subsecurity by role
-- Execution:                 EXEC [dbo].[GetOrgActSubSecurityByRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetOrgActSubSecurityByRoleView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity 
				   + ' INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] sr ON '+@entity+'.[OrgSecurityByRoleId]=sr.[Id]'
				   + ' WHERE sr.[OrgId] = @orgId AND sr.Id=@parentId AND ISNULL('+@entity+'.StatusId, 1)<3 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS SubSecOrgIdName, orgRoles.OrgRoleCode AS SecByRoleIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) sec ON ' + @entity + '.[OrgSecurityByRoleId]=sec.[Id] '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole ON sec.[OrgActRoleId]=actRole.[Id] '   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) orgRoles ON actRole.[OrgRefRoleId] = orgRoles.Id '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON sec.[OrgId]=org.[Id] '

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

SET @sqlCommand = @sqlCommand + ' WHERE sec.Id=@parentId AND org.Id=@orgId AND ISNULL(' + @entity + '.StatusId, 1)<3 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrganizationView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               09/04/2018      
-- Description:               Get all organization 
-- Execution:                 EXEC [dbo].[GetOrganizationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetOrganizationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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
 DECLARE @isSysAdmin BIT;

SELECT @isSysAdmin = [IsSysAdmin] FROM [dbo].[SYSTM000OpnSezMe] WHERE [Id] = @userId

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

IF(@isSysAdmin = 0)
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE ' + @entity + '.Id=@orgId ' + ISNULL(@where, '')
	END
ELSE
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE 1=1' + ISNULL(@where, '')
	END

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @orgId BIGINT, @TotalCount INT OUTPUT', @userId, @orgId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS OrgContactIdName '
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
		
SET @sqlCommand = @sqlCommand +' FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[OrgContactId]=cont.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

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

IF(@isSysAdmin = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id=@orgId ' + ISNULL(@where, '');
		SET @sqlCommand  = REPLACE(@sqlCommand,@entity + '.OrgSortOrder','1 as OrgSortOrder');
	END
ELSE
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE 1=1 ' + ISNULL(@where, '')
	END

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT, @orgId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @userId = @userId,
	 @orgId= @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgCredentialView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization credential    
-- Execution:                 EXEC [dbo].[GetOrgCredentialView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetOrgCredentialView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId],1) = fgus.[StatusId] '  
  
SET @TCountQuery = @TCountQuery+' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')  
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName , ([dbo].[fnGetAttachmentTableRowCount]('''+@entity+''', '+@entity+'.Id )) As AttachmentCount'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity  

--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @parentId = @parentId,  
  @userId = @userId  
END TRY       
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgFinacialCalenderView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization financial calander    
-- Execution:                 EXEC [dbo].[GetOrgFinacialCalenderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetOrgFinacialCalenderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgMarketSupportView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get a Org MRKT Org Support    
-- Execution:                 EXEC [dbo].[GetOrgMarketSupport]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetOrgMarketSupportView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity +' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @TotalCount INT OUTPUT', @parentId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100)' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
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
/****** Object:  StoredProcedure [dbo].[GetOrgPocContactView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization poc contact  
-- Execution:                 EXEC [dbo].[GetOrgPocContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetOrgPocContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, cont.[ConFullName] AS ContactIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ContactID]=cont.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgRefRoleView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization reference role 
-- Execution:                 EXEC [dbo].[GetOrgRefRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetOrgRefRoleView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity

--Below for getting user specific 'Statuses'
SET @TCountQuery += ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '

SET @TCountQuery += ' WHERE 1=1 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @TotalCount INT OUTPUT', @userId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, cont.[ConFullName] AS OrgRoleContactIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[OrgRoleContactID]=cont.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetPrgEdiHeaderView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program EDI header
-- Execution:                 EXEC [dbo].[GetPrgEdiHeaderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgEdiHeaderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [PehProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PehProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PehProgramID]=prg.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PehProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgEdiMappingView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program EDI mapping
-- Execution:                 EXEC [dbo].[GetPrgEdiMappingView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetPrgEdiMappingView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
  
SET @TCountQuery = @TCountQuery + '  WHERE [PemHeaderID] = @parentId  ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,@userId BIGINT, @TotalCount INT OUTPUT',@parentId,@userId , @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , ediHeader.[PehEdiTitle] AS PemHeaderIDName '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM070EdiHeader] (NOLOCK) ediHeader ON ' + @entity + '.[PemHeaderID]=ediHeader.[Id] '  
--SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000ColumnsAlias] (NOLOCK) colAlias ON ' + @entity + '.[PemEdiFieldId]=colAlias.[Id] '  
--SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000ColumnsAlias] (NOLOCK) colAlias2 ON ' + @entity + '.[PemSysFieldId]=colAlias2.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

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
  
SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.[PemHeaderID] = @parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@parentId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @userId = @userId  ,
   @parentId = @parentId
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgMvocRefQuestionView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Get all mvoc ref question 
-- Execution:                 EXEC [dbo].[GetPrgMvocRefQuestionView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE [dbo].[GetPrgMvocRefQuestionView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity     
    
--Below for getting user specific 'Statuses'    
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '    
    
SET @TCountQuery = @TCountQuery + ' WHERE [MVOCID] = @parentId ' + ISNULL(@where, '')    
    
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT ,@userId BIGINT, @TotalCount INT OUTPUT',@parentId,@userId , @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  SET @sqlCommand = @sqlCommand + ' , prgMvoc.[VocSurveyCode] AS MVOCIDName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[MVOC000Program] (NOLOCK) prgMvoc ON ' + @entity + '.[MVOCID]=prgMvoc.[Id] '    
    
--Below for getting user specific 'Statuses'    
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '    

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
    
SET @sqlCommand = @sqlCommand + ' WHERE [MVOCID] = @parentId '+ ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@parentId BIGINT,@userId BIGINT' ,    
  @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where,    
  @orgId = @orgId,    
  @parentId =@parentId,  
  @userId = @userId    
END TRY                    
BEGIN CATCH                   DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgRefAttributeDefaultView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ref Attributes
-- Execution:                 EXEC [dbo].[GetPrgRefAttributeDefaultView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgRefAttributeDefaultView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [ProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[ProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgRefGatewayDefaultView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ref Gateway Default
-- Execution:                 EXEC [dbo].[GetPrgRefGatewayDefaultView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetPrgRefGatewayDefaultView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [PgdProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PgdProgramIDName , respContact.[ConFullName] AS PgdGatewayResponsibleName ,  anaContact.[ConFullName] AS PgdGatewayAnalystName  '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PgdProgramID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) respContact ON ' + @entity + '.[PgdGatewayResponsible]=respContact.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaContact ON ' + @entity + '.[PgdGatewayAnalyst]=anaContact.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PgdProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgShipApptmtReasonCodeView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipApptmtReasonCodeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetPrgShipApptmtReasonCodeView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
  
SET @TCountQuery = @TCountQuery + ' WHERE [PacOrgID] = @orgId AND [PacProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
 
IF(@recordId = 0)
	BEGIN  
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgTitle] AS PacOrgIDName, prg.[PrgProgramTitle] AS PacProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[PacOrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PacProgramID]=prg.[Id] '  

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PacOrgID] = @orgId AND '+@entity+'.[PacProgramID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @parentId = @parentId,
	 @userId = @userId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgShipStatusReasonCodeView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipStatusReasonCodeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgShipStatusReasonCodeView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery =  @TCountQuery + ' WHERE [PscOrgID] = @orgId AND [PscProgramID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgTitle] AS PscOrgIDName, prg.[PrgProgramTitle] AS PscProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[PscOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PscProgramID]=prg.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PscOrgID] = @orgId AND '+@entity+'.[PscProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgVendLocationView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program vendor location
-- Execution:                 EXEC [dbo].[GetPrgVendLocationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgVendLocationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [PvlProgramID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN 
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,vend.[VendCode] AS PvlVendorIDName, cont.[ConFullName] AS PvlContactMSTRIDName '

		SET @sqlCommand = @sqlCommand + ' , CASE WHEN prg.PrgHierarchyLevel = 1 THEN     prg.[PrgProgramCode]
		 WHEN prg.PrgHierarchyLevel = 2 THEN     prg.[PrgProjectCode]
		  WHEN prg.PrgHierarchyLevel = 3 THEN     prg.PrgPhaseCode
		  ELSE prg.[PrgProgramTitle] END AS PvlProgramIDName';

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PvlProgramID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[PvlVendorID]=vend.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[PvlContactMSTRID]=cont.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PvlProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramBillableRateView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all  Program Billable Rate View
-- Execution:                 EXEC [dbo].[GetProgramBillableRateView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetProgramBillableRateView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [PbrPrgrmID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PbrPrgrmIDName, vendDcLoc.[VdcLocationTitle] AS PbrVendLocationIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PbrPrgrmID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND040DCLocations] (NOLOCK) vendDcLoc ON ' + @entity + '.[PbrVendLocationID]=vendDcLoc.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PbrPrgrmID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramCostRateView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all  Program Cost Rate View  
-- Execution:                 EXEC [dbo].[GetProgramCostRateView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetProgramCostRateView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [PcrPrgrmID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PcrPrgrmIDName, cust.[CustTitle] AS PcrCustomerIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PcrPrgrmID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[PcrCustomerID]=cust.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PcrPrgrmID]=@parentId '+ ISNULL(@where, '') 

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramRoleView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all  Program Role  
-- Execution:                 EXEC [dbo].[GetProgramRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetProgramRoleView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId],1) = fgus.[StatusId] '  
  
SET @TCountQuery = @TCountQuery + ' WHERE [OrgId] = @orgId AND [ProgramID] = @parentId ' + ISNULL(@where, '')  


EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgTitle] AS OrgIDName, prg.[PrgProgramTitle] AS ProgramIDName  ,orgrol.[OrgRoleCode] AS OrgRefRoleIdName, prgrol.[PrgRoleCode] AS PrgRoleIdName,cont.ConFullName AS PrgRoleContactIDName'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) orgrol ON ' + @entity + '.[OrgRefRoleId]=orgrol.[Id] ' 
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM020_Roles] (NOLOCK) prgrol ON ' + @entity + '.[PrgRoleId]=prgrol.[Id] ' 
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[PrgRoleContactID]=cont.[Id] ' 
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+@entity+'.[ProgramID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @parentId = @parentId,  
  @userId = @userId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramTreeView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all Program 
-- Execution:                 EXEC [dbo].[GetProgramTreeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetProgramTreeView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [PrgOrgID] = @orgId AND [PrgCustID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT prg.[Id]
							,prg.[PrgOrgID]
							,prg.[PrgCustID]
							,prg.[PrgHierarchyLevel]
							,prg.[PrgProgramTitle]
							,prg.[StatusId]
							--,refClass.SysOptionName as JobClassification
							--,refPrg.SysOptionName as JobProgramType
							--,refAcc.SysOptionName as JobAccessLevel
							--,refOp.SysOptionName as JobOptionLevel '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM000Master] (NOLOCK) prg'

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE prg.PrgOrgID=@orgId AND prg.[PrgCustID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ ISNULL(@orderBy, 'prg.Id') 

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetReportView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               12/01/2018      
-- Description:               Get all Reports
-- Execution:                 EXEC [dbo].[GetReportView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetReportView]
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

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity +' WHERE [OrganizationId] = @orgId ' + ISNULL(@where, '')
	EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @TotalCount INT OUTPUT',@orgId ,@TotalCount  OUTPUT;
	
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

	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity

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

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrganizationId] = @orgId '+ ISNULL(@where, '')
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orgId BIGINT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500)' ,
					@orgId= @orgId,
					@entity= @entity,
					@pageNo= @pageNo, 
					@pageSize= @pageSize,
					@orderBy = @orderBy,
					@where = @where
	
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnCargoDetailView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnCargoDetail  
-- Execution:                 EXEC [dbo].[GetScnCargoDetailView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnCargoDetailView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.CargoDetailID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoDetailID') + '), 0) AS CargoDetailID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.CargoDetailID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoDetailID') + '), 0) AS CargoDetailID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.CargoDetailID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoDetailID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoDetailID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoDetailID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoDetailID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.CargoDetailID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnCargoView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnCargo
-- Execution:                 EXEC [dbo].[GetScnCargoView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnCargoView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.CargoID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoID') + '), 0) AS CargoID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.CargoID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoID') + '), 0) AS CargoID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.CargoID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.CargoID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnDriverListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnDriverList  
-- Execution:                 EXEC [dbo].[GetScnDriverListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnDriverListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.DriverID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.DriverID') + '), 0) AS DriverID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.DriverID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.DriverID') + '), 0) AS DriverID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.DriverID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.DriverID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.DriverID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.DriverID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.DriverID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.DriverID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderOSDView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrderOSD  
-- Execution:                 EXEC [dbo].[GetScnOrderOSDView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderOSDView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.CargoOSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoOSDID') + '), 0) AS CargoOSDID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.CargoOSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoOSDID') + '), 0) AS CargoOSDID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.CargoOSDID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoOSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoOSDID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoOSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoOSDID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.CargoOSDID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderRequirementView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrderRequirement  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderRequirementView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS RequirementID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS RequirementID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.RequirementID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.RequirementID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderServiceView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrderService  
-- Execution:                 EXEC [dbo].[GetScnOrderServiceView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderServiceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ServicesID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServicesID') + '), 0) AS ServicesID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ServicesID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServicesID') + '), 0) AS ServicesID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ServicesID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServicesID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServicesID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServicesID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServicesID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ServicesID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrder
-- Execution:                 EXEC [dbo].[GetScnOrderView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.JobID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.JobID') + '), 0) AS JobID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.JobID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.JobID') + '), 0) AS JobID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.JobID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.JobID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.JobID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.JobID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.JobID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.JobID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnRouteListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnRouteList  
-- Execution:                 EXEC [dbo].[GetScnRouteListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnRouteListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.RouteID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RouteID') + '), 0) AS RouteID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.RouteID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RouteID') + '), 0) AS RouteID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.RouteID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RouteID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RouteID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RouteID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RouteID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.RouteID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrCatalogListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Catalog List  
-- Execution:                 EXEC [dbo].[GetScrCatalogListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrCatalogListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity +
				   ' JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.CatalogProgramID = prg.Id AND prg.Id = @parentId '

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = 	@TCountQuery  +' WHERE prg.PrgOrgID = @orgId '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS CatalogProgramIDName ';
		SET @sqlCommand = @sqlCommand + ' , CASE WHEN prg.PrgHierarchyLevel = 1 THEN     prg.[PrgProgramCode]
		 WHEN prg.PrgHierarchyLevel = 2 THEN     prg.[PrgProjectCode]
		  WHEN prg.PrgHierarchyLevel = 3 THEN     prg.PrgPhaseCode
		  ELSE prg.[PrgProgramTitle] END AS CatalogProgramIDName';

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.CatalogProgramID = prg.Id AND prg.Id=@parentId '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE prg.PrgOrgID = @orgId '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrGatewayListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScrGatewayList  
-- Execution:                 EXEC [dbo].[GetScrGatewayListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrGatewayListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.GatewayStatusID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.GatewayStatusID') + '), 0) AS GatewayStatusID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.GatewayStatusID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.GatewayStatusID') + '), 0) AS GatewayStatusID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.GatewayStatusID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.GatewayStatusID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.GatewayStatusID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.GatewayStatusID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.GatewayStatusID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.GatewayStatusID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrInfoListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScrInfoList  
-- Execution:                 EXEC [dbo].[GetScrInfoListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrInfoListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.InfoListID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.InfoListID') + '), 0) AS InfoListID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.InfoListID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.InfoListID') + '), 0) AS InfoListID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.InfoListID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity

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

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.InfoListID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.InfoListID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.InfoListID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.InfoListID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.InfoListID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrOsdListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Osd List  
-- Execution:                 EXEC [dbo].[GetScrOsdListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrOsdListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

 -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.OSDID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.OSDID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.OSDID) FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = 	@TCountQuery  +' WHERE  1=1 '+ ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) ;

		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.OSDID', @sqlCommand), LEN(@entity+'.OSDID'), @entity+'.OSDID as Id');

		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.OSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.OSDID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.OSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.OSDID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.OSDID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE  1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.OSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.OSDID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.OSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.OSDID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.OSDID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrOsdReasonListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Osd Reason List 
-- Execution:                 EXEC [dbo].[GetScrOsdReasonListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetScrOsdReasonListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

  -- Replace Orderby And Where column Name Id with ReasonID

 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.ReasonID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.ReasonID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.ReasonID) FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.ReasonID', @sqlCommand), LEN(@entity+'.ReasonID'), @entity+'.ReasonID as Id');

		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReasonID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReasonID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ReasonID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReasonID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReasonID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ReasonID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrRequirementListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Requirement List
-- Execution:                 EXEC [dbo].[GetScrRequirementListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetScrRequirementListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

  -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.RequirementID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.RequirementID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.RequirementID) FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.RequirementID', @sqlCommand), LEN(@entity+'.RequirementID'), @entity+'.RequirementID as Id');
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.RequirementID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.RequirementID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrReturnReasonListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Return Reason List
-- Execution:                 EXEC [dbo].[GetScrReturnReasonListView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetScrReturnReasonListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

  -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.ReturnReasonID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.ReturnReasonID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.ReturnReasonID) FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = 	@TCountQuery +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.ReturnReasonID', @sqlCommand), LEN(@entity+'.ReturnReasonID'), @entity+'.ReturnReasonID as Id');
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ReturnReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReturnReasonID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ReturnReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReturnReasonID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ReturnReasonID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReturnReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReturnReasonID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReturnReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReturnReasonID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ReturnReasonID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrServiceListView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Service List   
-- Execution:                 EXEC [dbo].[GetScrServiceListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetScrServiceListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

   -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.ServiceID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.ServiceID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.ServiceID) FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.ServiceID', @sqlCommand), LEN(@entity+'.ServiceID'), @entity+'.ServiceID as Id');
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ServiceID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServiceID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ServiceID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServiceID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ServiceID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServiceID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServiceID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServiceID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServiceID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ServiceID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSecurityByRoleView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/22/2018      
-- Description:               Get all security by role  
-- Execution:                 EXEC [dbo].[GetSecurityByRoleView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================       
ALTER PROCEDURE [dbo].[GetSecurityByRoleView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity +' WHERE OrgRefRoleId =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,@TotalCount INT OUTPUT',@parentId , @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  SET @sqlCommand = @sqlCommand + ' , rol.OrgRoleCode as OrgRefRoleIdName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[OrgRefRoleId] = rol.[Id] '  

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.OrgRefRoleId =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
   
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100) ,@parentId BIGINT' ,    
  @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
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
/****** Object:  StoredProcedure [dbo].[GetSubSecurityByRoleView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all subsecurity by role
-- Execution:                 EXEC [dbo].[GetSubSecurityByRoleView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetSubSecurityByRoleView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity 
				   + ' INNER JOIN [dbo].[SYSTM000SecurityByRole] sr ON '+@entity+'.[SecByRoleId]=sr.[Id]'
				   + ' WHERE sr.Id=@parentId AND ISNULL('+@entity+'.StatusId, 1)<3 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @TotalCount INT OUTPUT', @parentId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,orgRoles.OrgRoleCode AS SecByRoleIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[SYSTM000SecurityByRole] (NOLOCK) sec ON ' + @entity + '.[SecByRoleId]=sec.[Id] '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) orgRoles ON sec.[OrgRefRoleId] = orgRoles.Id '

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

SET @sqlCommand = @sqlCommand + ' WHERE sec.Id=@parentId AND ISNULL(' + @entity + '.StatusId, 1)<3 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
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
/****** Object:  StoredProcedure [dbo].[GetSysRefOptionView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/23/2018      
-- Description:               Get all sys ref option
-- Execution:                 EXEC [dbo].[GetSysRefOptionView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================      
ALTER PROCEDURE [dbo].[GetSysRefOptionView]    
 @userId BIGINT,    
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
 @referenceType NVARCHAR(100)=NULL,   
 @isNext BIT,  
 @isEnd BIT,  
 @recordId BIGINT,   
 @TotalCount INT OUTPUT    
AS    
BEGIN TRY   
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX);  
 DECLARE @TCountQuery NVARCHAR(MAX);  
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'      
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery +' WHERE 1 = 1 ' + ISNULL(@where, '')  


EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @userId BIGINT, @TotalCount INT OUTPUT', @langCode, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , lkup.[LkupCode] as LookupIdName '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON ' + @entity + '.[SysLookupId] = lkup.[Id] ' 

--Below for getting user specific 'Statuses'      
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '      

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
 
SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 ' + ISNULL(@where, '')   
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
 
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10),@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @userId BIGINT' ,  
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
/****** Object:  StoredProcedure [dbo].[GetSysRefTabPageNameView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all system ref tab page name
-- Execution:                 EXEC [dbo].[GetSysRefTabPageNameView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetSysRefTabPageNameView]
 @userId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity

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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10),@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100)' ,
     @langCode= @langCode,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemAccountView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               12/17/2018      
-- Description:               Get all System Account
-- Execution:                 EXEC [dbo].[GetSystemAccountView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================        
ALTER PROCEDURE [dbo].[GetSystemAccountView]      
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
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
 @langCode NVARCHAR(10),       
 @TotalCount INT OUTPUT      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;        
 DECLARE @sqlCommand NVARCHAR(MAX);      
 DECLARE @TCountQuery NVARCHAR(MAX);      
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity       
      
--Below for getting user specific 'Statuses'      
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '   ;
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[SysOrgId] = org.[Id] ';  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[SysOrgRefRoleId] = rol.[Id] '  ;  
      
SET @TCountQuery = @TCountQuery + ' WHERE [SysOrgId] = @orgId ' + ISNULL(@where, '')      

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;      
     
IF(@recordId = 0)      
 BEGIN      
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)       
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS SysOrgIdName, cont.[ConFullName] AS SysUserContactIDName, rol.OrgRoleCode as SysOrgRefRoleIdName '     
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
      
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity      
--Below to get BIGINT reference key name by Id if NOT NULL      
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[SysOrgId] = org.[Id] '  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[SysOrgRefRoleId] = rol.[Id] '  ;   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[SysUserContactID] = cont.[Id] '     
      
--Below for getting user specific 'Statuses'      
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '      

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
      
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[SysOrgId] = @orgId '+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))      
 BEGIN      
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,      
  @entity= @entity,      
     @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,      
  @userId = @userId      
      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemMessageView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all system message
-- Execution:                 EXEC [dbo].[GetSystemMessageView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetSystemMessageView]  
 @userId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM000Master] '+@entity+' INNER JOIN SYSTM000Ref_Options ref ON '+@entity+'.SysRefId = ref.Id  WHERE '+@entity+'.[LangCode] = @langCode AND ref.SysLookupId=27 ' + ISNULL(@where, '')
  
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;  
  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Master] (NOLOCK) '+ @entity  
SET @sqlCommand = @sqlCommand + ' INNER JOIN SYSTM000Ref_Options (NOLOCK) ref ON '+ @entity+'.SysRefId = ref.Id '   

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode  AND ref.SysLookupId=27 '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @langCode NVARCHAR(10), @entity NVARCHAR(100)' ,  
     @langCode= @langCode,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemStatusLogView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               06/08/2018      
-- Description:               Get all System status logs
-- Execution:                 EXEC [dbo].[GetSystemStatusLogView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================        
ALTER PROCEDURE [dbo].[GetSystemStatusLogView]      
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
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
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity       
      
--Below for getting user specific 'Statuses'      
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '   ;
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) pgm ON ' + @entity + '.[ProgramID] = pgm.[Id] ';  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID] = job.[Id] '  ;  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[JOBDL020Gateways] (NOLOCK) jobgate ON ' + @entity + '.[GatewayID] = jobgate.[Id] '  ;  
      
SET @TCountQuery = @TCountQuery + ' WHERE pgm.[PrgOrgID] = @orgId ' + ISNULL(@where, '')      

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;      
     
IF(@recordId = 0)      
 BEGIN      
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)      ;
  SET @sqlCommand = @sqlCommand + ' , CASE WHEN pgm.PrgHierarchyLevel = 1 THEN pgm.PrgProgramCode
                                  WHEN pgm.PrgHierarchyLevel = 2 THEN pgm.PrgProjectCode
							 WHEN pgm.PrgHierarchyLevel = 3 THEN pgm.PrgPhaseCode
							 ELSE pgm.PrgProgramTitle END  AS ProgramIDName '
   
  SET @sqlCommand = @sqlCommand + ' ,job.JobCustomerSalesOrder as JobIDName , jobgate.GwyGatewayCode as GatewayIDName '     
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
      
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity      
--Below to get BIGINT reference key name by Id if NOT NULL      
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) pgm ON ' + @entity + '.[ProgramID] = pgm.[Id] ';  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID] = job.[Id] '  ;  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[JOBDL020Gateways] (NOLOCK) jobgate ON ' + @entity + '.[GatewayID] = jobgate.[Id] '  ;    
      
--Below for getting user specific 'Statuses'      
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '      

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
      
SET @sqlCommand = @sqlCommand + ' WHERE pgm.[PrgOrgID] = @orgId '+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))      
 BEGIN      
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,      
  @entity= @entity,      
     @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,      
  @userId = @userId      
      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetValidationView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all system validation 
-- Execution:                 EXEC [dbo].[GetValidationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
     
ALTER PROCEDURE [dbo].[GetValidationView]    
 @userId BIGINT,    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'  
 SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  

 SET @TCountQuery = @TCountQuery + ' WHERE [LangCode] = @langCode ' + ISNULL(@where, '') 

EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @userId BIGINT, @TotalCount INT OUTPUT', @langCode, @userId, @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  --SET @sqlCommand = @sqlCommand + ' ,tabPage.[LangTabName] AS RefTabPageIdName '    
  SET @sqlCommand = @sqlCommand + ' ,tabPage.[TabTableName] AS RefTabPageIdName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) tabPage ON ' + @entity + '.[RefTabPageId]=tabPage.[Id] '    

--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  

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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10), @entity NVARCHAR(100), @orderBy NVARCHAR(500),@userId BIGINT, @where NVARCHAR(500)' ,    
     @langCode= @langCode,    
     @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,  
	 @userId = @userId,  
     @where = @where    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendBusinessTermView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor business term
-- Execution:                 EXEC [dbo].[GetVendBusinessTermView]
-- Modified on:               04/25/2018
-- Modified Desc:             Removed lang code filter
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendBusinessTermView]
 @userId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery +' WHERE  [VbtOrgId] = @orgId AND [VbtVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',@orgId, @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS VbtOrgIDName, vend.[VendCode] AS VbtVendorIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[VbtOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VbtVendorID]=vend.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[VbtOrgId] = @orgId  AND '+@entity+'.[VbtVendorID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
    
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendContactView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor contact
-- Execution:                 EXEC [dbo].[GetVendContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--Below to get BIGINT reference key name by Id if NOT NULL
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VendVendorID]=vend.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VendContactMSTRID]=cont.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

SET @TCountQuery = @TCountQuery +' WHERE [VendVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
 BEGIN

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , vend.[VendCode] AS VendVendorIDName, cont.[ConFullName] AS VendContactMSTRIDName '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConJobTitle] AS ConJobTitle, cont.[ConEmailAddress] AS ConEmailAddress '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConMobilePhone] AS ConMobilePhone, cont.[ConBusinessPhone] AS ConBusinessPhone '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1, cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessCity] AS ConBusinessCity, cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
		SET @sqlCommand = @sqlCommand + ' , sts.[StateAbbr] AS ConBusinessStateIdName, sysRef.[SysOptionName] AS ConBusinessCountryIdName '
		SET @sqlCommand = @sqlCommand + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VendVendorID]=vend.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VendContactMSTRID]=cont.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+ @entity + '.[VendVendorID]=@parentId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		IF(ISNULL(@groupByWhere, '') <> '')
		   BEGIN
			  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
		   END
		ELSE
		   BEGIN
			  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
		   END     
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

END
ELSE
BEGIN

	DECLARE @SelectClauseToAdd NVARCHAR(500) = '';

	IF(@groupBy = (@entity + '.VendVendorIDName'))
	 BEGIN
		SET @groupBy = ' vend.[VendCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , vend.[VendCode] AS VendVendorIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.VendContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS VendContactMSTRIDName ';
	 END
	 ELSE IF(@groupBy = (@entity + '.ConJobTitle'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConJobTitle] AS ConJobTitle '
	 END
	ELSE IF(@groupBy = (@entity + '.ConEmailAddress'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConEmailAddress] AS ConEmailAddress '
	 END
	 ELSE IF(@groupBy = (@entity + '.ConMobilePhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConMobilePhone] AS ConMobilePhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessPhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessPhone] AS ConBusinessPhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress1'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress2'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCity'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessCity] AS ConBusinessCity '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessZipPostal'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessStateIdName'))
	 BEGIN
		SET @groupBy = ' sts.[StateAbbr] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sts.[StateAbbr] AS ConBusinessStateIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCountryIdName'))
	 BEGIN
		SET @groupBy = ' sysRef.[SysOptionName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sysRef.[SysOptionName] AS ConBusinessCountryIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessFullAddress'))
	 BEGIN
		SET @groupBy = ' ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress ';
		SET @orderBy = REPLACE(@orderBy, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )');
	 END


	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount '
	SET @sqlCommand = @sqlCommand + @SelectClauseToAdd
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity 
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VendVendorID]=vend.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VendContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[VendVendorID] = @parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END

END

--To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VendVendorIDName', 'vend.[VendCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VendContactMSTRIDName', 'cont.[ConFullName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConJobTitle', 'ConJobTitle')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConEmailAddress', 'ConEmailAddress')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConMobilePhone', 'ConMobilePhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessPhone', 'ConBusinessPhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress1', 'ConBusinessAddress1')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress2', 'ConBusinessAddress2')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCity', 'ConBusinessCity')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessZipPostal', 'ConBusinessZipPostal')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessStateIdName', 'sts.[StateAbbr]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCountryIdName', 'sysRef.[SysOptionName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessFullAddress', 'ConBusinessFullAddress')

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendDcLocationContactView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/25/2018        
-- Description:               Get all Vendor DC Location Contact 
-- Execution:                 EXEC [dbo].[GetVendDcLocationContactView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)               
-- Modified Desc:           
-- =============================================  
ALTER PROCEDURE [dbo].[GetVendDcLocationContactView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
  --Below to get BIGINT reference key name by Id if NOT NULL  
  SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VlcContactMSTRID]=cont.[Id] '  
  SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] ' 
  
SET @TCountQuery = @TCountQuery + ' WHERE [VlcVendDcLocationId] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS VlcContactMSTRIDName, refOp.SysOptionName AS VendorType, cont.ConBusinessPhone AS ConBusinessPhone, cont.ConBusinessPhoneExt AS ConBusinessPhoneExt, cont.ConMobilePhone AS ConMobilePhone '  
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
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VlcContactMSTRID]=cont.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] '  
  
--Below for getting user specific 'Statuses'  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[VlcVendDcLocationId]=@parentId ' + ISNULL(@where, '')  
  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
  @entity= @entity,  
  @pageNo= @pageNo,   
  @pageSize= @pageSize,  
  @orderBy = @orderBy,  
  @where = @where,  
  @orgId = @orgId,  
  @parentId = @parentId,  
  @userId = @userId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendDCLocationView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor dc location
-- Execution:                 EXEC [dbo].[GetVendDCLocationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendDCLocationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--Below to get BIGINT reference key name by Id if NOT NULL
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VdcContactMSTRID]=cont.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

SET @TCountQuery = @TCountQuery + ' WHERE [VdcVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
BEGIN

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , vend.[VendCode] AS VdcVendorIDName, cont.[ConFullName] AS VdcContactMSTRIDName '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConJobTitle] AS ConJobTitle, cont.[ConEmailAddress] AS ConEmailAddress '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConMobilePhone] AS ConMobilePhone, cont.[ConBusinessPhone] AS ConBusinessPhone '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1, cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessCity] AS ConBusinessCity, cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
		SET @sqlCommand = @sqlCommand + ' , sts.[StateAbbr] AS ConBusinessStateIdName, sysRef.[SysOptionName] AS ConBusinessCountryIdName '
		SET @sqlCommand = @sqlCommand + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VdcContactMSTRID]=cont.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')


SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+ @entity + '.[VdcVendorID]=@parentId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		IF(ISNULL(@groupByWhere, '') <> '')
			BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END
			ELSE
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END       
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

END
ELSE
BEGIN
	
	DECLARE @SelectClauseToAdd NVARCHAR(500) = '';

	IF(@groupBy = (@entity + '.VdcVendorIDName'))
	 BEGIN
		SET @groupBy = ' vend.[VendCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , vend.[VendCode] AS VdcVendorIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.VdcContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS VdcContactMSTRIDName ';
	 END
	 ELSE IF(@groupBy = (@entity + '.ConJobTitle'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConJobTitle] AS ConJobTitle '
	 END
	ELSE IF(@groupBy = (@entity + '.ConEmailAddress'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConEmailAddress] AS ConEmailAddress '
	 END
	 ELSE IF(@groupBy = (@entity + '.ConMobilePhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConMobilePhone] AS ConMobilePhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessPhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessPhone] AS ConBusinessPhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress1'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress2'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCity'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessCity] AS ConBusinessCity '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessZipPostal'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessStateIdName'))
	 BEGIN
		SET @groupBy = ' sts.[StateAbbr] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sts.[StateAbbr] AS ConBusinessStateIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCountryIdName'))
	 BEGIN
		SET @groupBy = ' sysRef.[SysOptionName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sysRef.[SysOptionName] AS ConBusinessCountryIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessFullAddress'))
	 BEGIN
		SET @groupBy = ' ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress ';
		SET @orderBy = REPLACE(@orderBy, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )');
	 END


	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount '
	SET @sqlCommand = @sqlCommand + @SelectClauseToAdd
	SET @sqlCommand = @sqlCommand +' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VdcContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')
	
	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[VdcVendorID]=@parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END

END

	--To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcVendorIDName', 'vend.[VendCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcContactMSTRIDName', 'cont.[ConFullName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConJobTitle', 'ConJobTitle')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConEmailAddress', 'ConEmailAddress')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConMobilePhone', 'ConMobilePhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessPhone', 'ConBusinessPhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress1', 'ConBusinessAddress1')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress2', 'ConBusinessAddress2')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCity', 'ConBusinessCity')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessZipPostal', 'ConBusinessZipPostal')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessStateIdName', 'sts.[StateAbbr]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCountryIdName', 'sysRef.[SysOptionName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessFullAddress', 'ConBusinessFullAddress')

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendDocReferenceView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor document reference
-- Execution:                 EXEC [dbo].[GetVendDocReferenceView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendDocReferenceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [VdrVendorID] = @parentId AND [VdrOrgId] = @orgId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS VdrOrgIDName, vend.[VendCode] AS VdrVendorIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[VdrOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdrVendorID]=vend.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[VdrOrgId] = @orgId AND '+ @entity + '.[VdrVendorID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendFinancialCalenderView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor finance calander 
-- Execution:                 EXEC [dbo].[GetVendFinancialCalenderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendFinancialCalenderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [VendID] = @parentId AND [OrgId] = @orgId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, vend.[VendCode] AS VendIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VendID]=vend.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+ @entity + '.[VendID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendorView]    Script Date: 12/26/2018 6:04:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               11/04/2018      
-- Description:               Get all vendor
-- Execution:                 EXEC [dbo].[GetVendorView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendorView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [VendOrgId] = @orgId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS VendOrgIDName, contWA.[ConFullName] AS VendWorkAddressIdName, ' + 
										' contBA.[ConFullName] AS VendBusinessAddressIdName, contCA.[ConFullName] AS VendCorporateAddressIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[VendOrgID] = org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[VendWorkAddressId] = contWA.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[VendBusinessAddressId] = contBA.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[VendCorporateAddressId] = contCA.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[VendOrgId] = @orgId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

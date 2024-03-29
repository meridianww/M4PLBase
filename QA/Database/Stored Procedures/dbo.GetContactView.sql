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
CREATE PROCEDURE [dbo].[GetContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(MAX),
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

SET @TCountQuery = @TCountQuery +' WHERE 1=1 ' + ISNULL(@where, '') + ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS nvarchar(100))

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @TotalCount INT OUTPUT', @userId , @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.OrgTitle AS ConOrgIdName, sts1.[StateAbbr] AS ConBusinessStateIdName, sts2.[StateAbbr] AS ConHomeStateIdName '
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

SET @sqlCommand = @sqlCommand  + ', COMP.CompTitle ConCompanyIdName' + ', COMP.CompTableName AS CompanyType' + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity

--Below to get State reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts1 ON ' + @entity + '.[ConBusinessStateId]=sts1.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts2 ON ' + @entity + '.[ConHomeStateId]=sts2.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[COMP000Master] (NOLOCK) COMP ON ' + @entity + '.[ConCompanyId]=COMP.[Id] '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[ConOrgId]=org.[Id] '

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '+ ISNULL(@where, '')+ ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS nvarchar(100))

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
	print @sqlCommand
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @entity NVARCHAR(100),@userId BIGINT' ,
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

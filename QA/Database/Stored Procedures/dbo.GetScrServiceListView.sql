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
CREATE PROCEDURE [dbo].[GetScrServiceListView]
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT,@userId BIGINT' ,
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

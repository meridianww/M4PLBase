SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal       
-- Create date:               09/17/2019      
-- Description:               Get Vendor View 
-- =============================================  
CREATE PROCEDURE [dbo].[GetVendorView]
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
 DECLARE @VendorCount BIGINT,@IsVendorAdmin BIT = 0
 IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
BEGIN
DROP TABLE #EntityIdTemp
END
  CREATE TABLE #EntityIdTemp
(
EntityId BIGINT
)

INSERT INTO #EntityIdTemp
EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,@entity
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+ @entity+'.'+'Id) FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity 

SELECT @VendorCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdTemp
	WHERE ISNULL(EntityId, 0) = -1


	IF (@VendorCount = 1)
	BEGIN
		SET @IsVendorAdmin = 1
	END

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
SET @TCountQuery = @TCountQuery + ' INNER JOIN dbo.COMP000Master  (NOLOCK) COMP ON ' + @entity + '.[ID] = COMP.[CompPrimaryRecordId] ' + 'AND COMP.CompTableName =''Vendor'''
IF (ISNULL(@IsVendorAdmin, 0) = 0)
BEGIN
SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
END
SET @TCountQuery = @TCountQuery + ' WHERE [VendOrgId] = @orgId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS VendOrgIDName, contWA.[ConFullName] AS VendWorkAddressIdName, ' + 
										' contBA.[ConFullName] AS VendBusinessAddressIdName, contCA.[ConFullName] AS VendCorporateAddressIdName,COMP.Id CompanyId '
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
SET @sqlCommand = @sqlCommand + ' INNER JOIN dbo.COMP000Master  (NOLOCK) COMP ON ' + @entity + '.[ID] = COMP.[CompPrimaryRecordId] ' + 'AND COMP.CompTableName =''Vendor'''
IF (ISNULL(@IsVendorAdmin, 0) = 0)
BEGIN
SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[id] = tmp.[EntityId] '
END
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId

DROP TABLE #EntityIdTemp
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

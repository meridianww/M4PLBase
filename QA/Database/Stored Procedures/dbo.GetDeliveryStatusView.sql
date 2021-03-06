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
CREATE PROCEDURE [dbo].[GetDeliveryStatusView]
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @entity NVARCHAR(100),@userId BIGINT, @orgId BIGINT' ,
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

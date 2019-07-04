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
CREATE PROCEDURE [dbo].[GetJobGatewayView]
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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

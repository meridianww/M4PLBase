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
CREATE PROCEDURE [dbo].[GetJobCargoView]  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity   
 IF OBJECT_ID('tempdb..#JobTemp') IS NOT NULL DROP TABLE #JobTemp
Select Id, [JobSiteCode] AS JobIDName, [JobCompleted] AS JobCompleted INTO #JobTemp From dbo.JobDL000Master Where Id = @parentId
  
SET @TCountQuery = @TCountQuery + ' WHERE '+ @entity +'.JobID = @parentId ' + ISNULL(@where, '')  

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount OUTPUT;  
   
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = REPLACE(@sqlCommand,'JobCargo.CgoQTYOrdered','JobCargo.CgoQtyOrdered');
  SET @sqlCommand = @sqlCommand + ' , job.JobIDName , job.JobCompleted ,' +
  'refOpt.SysOptionName AS CgoPackagingTypeIdName,refOptWeight.SysOptionName AS CgoWeightUnitsIdName,refOptQty.SysOptionName AS CgoQtyUnitsIdName,refOptVolume.SysOptionName AS CgoVolumeUnitsIdName '  
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
SET @sqlCommand = @sqlCommand + ' INNER JOIN #JobTemp job ON ' + @entity + '.[JobID]=job.[Id] '  
  
--Below for getting user specific 'Statuses'  
--SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  

SET @sqlCommand = @sqlCommand + ' LEFT JOIN  [dbo].[SYSTM000Ref_Options] refOpt ON  ' + @entity + '.[CgoPackagingTypeId] = refOpt.[id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN  [dbo].[SYSTM000Ref_Options] refOptWeight ON  ' + @entity + '.[CgoWeightUnitsId] = refOpt.[id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN  [dbo].[SYSTM000Ref_Options] refOptVolume ON  ' + @entity + '.[CgoVolumeUnitsId] = refOpt.[id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN  [dbo].[SYSTM000Ref_Options] refOptQty ON  ' + @entity + '.[CgoQtyUnitsId] = refOpt.[id] '  

--Below to update order by clause if related to Ref_Options
	IF(ISNULL(@orderBy, '') <> '')
	BEGIN
		DECLARE @orderByJoinClause NVARCHAR(500);
		SELECT @orderBy = OrderClause, @orderByJoinClause=JoinClause FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);
		IF(ISNULL(@orderByJoinClause, '') <> '')
		BEGIN 
			SET @sqlCommand = @sqlCommand + @orderByJoinClause
		END
		print 1
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @parentId = @parentId,  
  @userId = @userId  

 DROP TABLE #JobTemp
END TRY   
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

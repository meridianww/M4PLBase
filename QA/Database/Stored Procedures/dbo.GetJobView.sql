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
CREATE PROCEDURE [dbo].[GetJobView]      
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
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity     
    
--Below for getting user specific 'Statuses'    
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '   
 IF EXISTS(select 1 From #EntityIdTemp Where EntityId <> 99999999999)
	BEGIN
	SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END 
     
SET @TCountQuery =  @TCountQuery + ' WHERE 1=1 AND ProgramID = ISNULL(@parentId,ProgramID) ' + ISNULL(@where, '')     
    
EXEC sp_executesql @TCountQuery, N'@TotalCount INT OUTPUT, @userId BIGINT,@parentId BIGINT', @TotalCount  OUTPUT, @userId, @parentId = @parentId;  

IF OBJECT_ID('tempdb..#ActualCargoPartCount') IS NOT NULL
		BEGIN
			DROP TABLE #ActualCargoPartCount
		END

		IF OBJECT_ID('tempdb..#ActualCargoQuantityCount') IS NOT NULL
		BEGIN
			DROP TABLE #ActualCargoQuantityCount
		END

		SELECT JobId
			,Count(JobId) CargoCount
		INTO #ActualCargoItemCount
		FROM [dbo].[JOBDL010Cargo]
		Where  StatusId IN (1,2) AND ISNULL(CgoQtyUnits, '') <> '' AND CgoQtyUnits NOT IN ('Cabinets', 'Pallets')
		GROUP BY JobId

		SELECT JobId
			,Count(JobId) CargoCount
		INTO #ActualCargoQuantityCount
		FROM [dbo].[JOBDL010Cargo]
		Where StatusId IN (1,2) AND ISNULL(CgoQtyUnits, '') <> '' AND CgoQtyUnits IN ('Cabinets', 'Pallets')
		GROUP BY JobId

IF(@recordId = 0)    
 BEGIN     
 Declare @QueryData Varchar(Max)
 Select @QueryData = [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
 SELECT @QueryData = REPLACE(@QueryData, 'Job.JobPartsActual', 'CASE WHEN ISNULL(Job.JobPartsActual, 0) > 0 THEN CAST(Job.JobPartsActual AS INT) WHEN ISNULL(CC.CargoCount, 0) > 0 THEN CAST(CC.CargoCount AS INT) ELSE NULL END JobPartsActual');
 SELECT @QueryData =  REPLACE(@QueryData, 'Job.JobQtyActual', 'CASE WHEN ISNULL(Job.JobQtyActual, 0) > 0 THEN CAST(Job.JobQtyActual AS INT) WHEN ISNULL(CC1.CargoCount, 0) > 0 THEN CAST(CC1.CargoCount AS INT) ELSE NULL END JobQtyActual');
 SELECT @QueryData =  REPLACE(@QueryData, 'Job.JobPartsOrdered', 'CAST(Job.JobPartsOrdered AS INT) JobPartsOrdered');  
  SET @sqlCommand = 'SELECT ' + @QueryData 
  
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
IF EXISTS(select 1 From #EntityIdTemp Where EntityId <> 99999999999)
BEGIN
SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
END    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[JobDeliveryResponsibleContactID]=cont.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaCont ON ' + @entity + '.[JobDeliveryAnalystContactID]=anaCont.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) driverCont ON ' + @entity + '.[JobDriverId]=driverCont.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN #ActualCargoItemCount  CC ON ' + @entity + '.[Id]=CC.[JobId] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN #ActualCargoQuantityCount CC1 ON ' + @entity + '.[Id]=CC.[JobId] ' 
    
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
      
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @entity NVARCHAR(100),@parentId BIGINT,@userId BIGINT' ,      
  @entity= @entity,      
 @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,    
  @parentId = @parentId ,    
  @userId = @userId  

DROP TABLE #EntityIdTemp  
DROP TABLE #ActualCargoItemCount
DROP TABLE #ActualCargoQuantityCount   
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO

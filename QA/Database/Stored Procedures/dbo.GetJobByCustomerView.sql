SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal         
-- Create date:               09/23/2019      
-- Description:               Get all Job by CustomerId
-- Execution:                 declare @p15 int
							--set @p15=0
							--exec dbo.GetJobByCustomerView @userId=1,@roleId=14,@orgId=1,@entity=N'Job',@pageNo=1,@pageSize=50,@orderBy=NULL,@where=NULL,@parentId=10007,@isNext=0,@isEnd=0,@recordId=0,@groupBy=NULL,@groupByWhere=NULL,@TotalCount=@p15 output
							--select @p15
-- =============================================    
CREATE PROCEDURE [dbo].[GetJobByCustomerView]      
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
 DECLARE @EntityCount BIGINT,@IsEntityAdmin BIT = 0,@ProgramCount BIGINT,@IsProgAdmin BIT = 0

IF OBJECT_ID('tempdb..#ProgramIdTemp') IS NOT NULL
		BEGIN
			DROP TABLE #ProgramIdTemp
		END

		IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
		BEGIN
			DROP TABLE #EntityIdTemp
		END
CREATE TABLE #ProgramIdTemp
(
	EntityId BIGINT
)

CREATE NONCLUSTERED INDEX IX_ProgramIdTemp_EntityId ON #ProgramIdTemp (EntityId)

 CREATE TABLE #EntityIdTemp
(
	EntityId BIGINT
)
CREATE NONCLUSTERED INDEX IX_EntityIdTemp_EntityId ON #EntityIdTemp (EntityId)

INSERT INTO #ProgramIdTemp
EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Program'

INSERT INTO #EntityIdTemp
EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,@entity,@parentId

SELECT @EntityCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdTemp
	WHERE ISNULL(EntityId, 0) = -1


	IF (@EntityCount = 1)
	BEGIN
		SET @IsEntityAdmin = 1
	END

	SELECT @ProgramCount = Count(ISNULL(EntityId, 0))
	FROM #ProgramIdTemp
	WHERE ISNULL(EntityId, 0) = -1


	IF (@ProgramCount = 1)
	BEGIN
		SET @IsProgAdmin = 1
	END
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[vwJobMasterData] (NOEXPAND) '+ @entity     
    
--Below for getting user specific 'Statuses'    
--SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '   
IF(ISNULL(@IsEntityAdmin, 0) = 0)
BEGIN
SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
END 

IF (ISNULL(@IsProgAdmin, 0) = 1)
BEGIN
INSERT INTO #ProgramIdTemp
Select Id FROM dbo.PRGRM000Master WITH(NOLOCK) 
Where PrgCustID = @parentId AND StatusId IN (select StatusId from [dbo].[fnGetUserStatuses](@userId))
END
     
SET @TCountQuery =  @TCountQuery + ' WHERE 1=1 AND ProgramID IN (Select EntityId From #ProgramIdTemp) ' + ISNULL(@where, '')     
    
EXEC sp_executesql @TCountQuery, N'@TotalCount INT OUTPUT, @userId BIGINT,@parentId BIGINT', @TotalCount  OUTPUT, @userId, @parentId = @parentId;  



IF(@recordId = 0)    
 BEGIN     
 Declare @QueryData Varchar(Max)
 Select @QueryData = [dbo].[fnGetGridBaseQueryByUserId](@entity, @userId)
 SELECT @QueryData = REPLACE(@QueryData, 'Job.JobPartsActual', 'CASE WHEN ISNULL(Job.JobPartsActual, 0) > 0 THEN CAST(Job.JobPartsActual AS INT)  ELSE NULL END JobPartsActual');
SELECT @QueryData =  REPLACE(@QueryData, 'Job.JobQtyActual', 'CASE WHEN ISNULL(Job.JobQtyActual, 0) > 0 THEN CAST(Job.JobQtyActual AS INT)  ELSE NULL END JobQtyActual');
SELECT @QueryData =  REPLACE(@QueryData, 'Job.JobPartsOrdered', 'CAST(Job.JobPartsOrdered AS INT) JobPartsOrdered');  
SELECT @QueryData =  REPLACE(@QueryData, 'Job.JobServiceOrder', 'CAST(Job.JobServiceOrder AS INT) JobServiceOrder');  
SELECT @QueryData =  REPLACE(@QueryData, 'Job.JobServiceActual', 'CAST(Job.JobServiceActual AS INT) JobServiceActual');   
 SELECT @QueryData =  REPLACE(@QueryData, 'Job.IsJobVocSurvey', 'CAST(Job.IsJobVocSurvey AS BIT) IsJobVocSurvey'); 
  SET @sqlCommand = 'SELECT ' + @QueryData 
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[vwJobMasterData] (NOEXPAND) '+ @entity      
IF(ISNULL(@IsEntityAdmin, 0) = 0)
BEGIN
SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
END    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[JobDeliveryResponsibleContactID]=cont.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaCont ON ' + @entity + '.[JobDeliveryAnalystContactID]=anaCont.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) driverCont ON ' + @entity + '.[JobDriverId]=driverCont.[Id] '    

--Below for getting user specific 'Statuses'    
--SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '    

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
    
SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.ProgramID IN (Select Entityid From #ProgramIdTemp)'+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobMasterData] (NOEXPAND) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobMasterData] (NOEXPAND) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
DROP TABLE #ProgramIdTemp

END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH



GO

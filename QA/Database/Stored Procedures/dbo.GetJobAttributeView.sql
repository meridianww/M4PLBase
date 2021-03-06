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
CREATE PROCEDURE [dbo].[GetJobAttributeView]  
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal       
-- Create date:               08/09/2020      
-- Description:               Get all Event type  
-- Execution:                 EXEC [dbo].GetEventView  
-- =============================================   

ALTER PROCEDURE [dbo].[GetEventView]  
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
	--@EventTypeId INT,
	@TotalCount INT OUTPUT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX)  
		,@TCountQuery NVARCHAR(MAX)
		,@EventEntityRelationId INT
		,@ToEmailSubscriberTypeId INT
		,@CustomSubscriberId INT
		,@CCEmailSubscriberTypeId INT
		,@CustomToAddressEmail VARCHAR(200)
		,@CustomCCAddressEmail VARCHAR(200)
		,@ToEmail NVARCHAR(400)
		,@CcEmail NVARCHAR(400)	
		,@EventTypeId INT = 4
		
		SELECT @CustomSubscriberId = SubscriberId
	FROM [dbo].[EventSubscriber]
	WHERE SubscriberDescription = 'Custom'

	SELECT @ToEmailSubscriberTypeId = Id
	FROM [dbo].[EventSubscriberType]
	WHERE EventSubscriberTypeName = 'To'

	SELECT @CcEmailSubscriberTypeId = Id
	FROM [dbo].[EventSubscriberType]
	WHERE EventSubscriberTypeName = 'CC'

  SELECT @ToEmail = EmailAddresses FROM dbo.EventSubscriberRelation  ESR INNER JOIN dbo.EventEntityRelation eer
  ON ESR.EventEntityRelationId = eer.ID WHERE EventSubscriberTypeId = @ToEmailSubscriberTypeId 
  AND SubscriberId = @CustomSubscriberId

  SELECT @CcEmail = EmailAddresses FROM dbo.EventSubscriberRelation  ESR INNER JOIN dbo.EventEntityRelation eer
  ON ESR.EventEntityRelationId = eer.ID WHERE EventSubscriberTypeId = @CcEmailSubscriberTypeId 
  AND SubscriberId = @CustomSubscriberId
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+ @entity+'.Id) FROM [dbo].[Event] (NOLOCK) '+ @entity     
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[EventEntityRelation] eer ON ' + @entity + '.[Id] = eer.[EventId] '
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[EventEntityContentDetail] eecd ON eer.[Id] = eecd.[EventEntityRelationId] '

  
SET @TCountQuery = @TCountQuery + ' WHERE '+ @entity +'.EventTypeId = @EventTypeId ' + ISNULL(@where, '')  

EXEC sp_executesql @TCountQuery, N'@EventTypeId INT, @userId BIGINT, @TotalCount INT OUTPUT', @EventTypeId, @userId, @TotalCount OUTPUT;  
   
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
  SET @sqlCommand = @sqlCommand + (', eer.ParentId , eecd.Subject, eecd.IsBodyHtml,eer.ParentId AS ProgramID');
  SET @sqlCommand = @sqlCommand + ' , '''+ ISNULL(@ToEmail,'')+''' AS ToEmail, '''+ ISNULL(@CcEmail, '')+''' AS CcEmail ';  

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

SET @sqlCommand = @sqlCommand + + ' FROM [dbo].[Event] (NOLOCK) '+ @entity  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[EventEntityRelation] eer ON ' + @entity + '.[Id] = eer.[EventId] '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[EventEntityContentDetail] eecd ON eer.[Id] = eecd.[EventEntityRelationId] '
print @sqlCommand
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
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[Event] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[Event] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
 PRINT @sqlCommand
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
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

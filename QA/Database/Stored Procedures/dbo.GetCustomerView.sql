SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal       
-- Create date:               09/17/2019      
-- Description:               Get Customer View 
-- Execution:                 declare @p15 int
                              --set @p15=4
                              --exec dbo.GetCustomerView @userId=10013,@roleId=10036,@orgId=1,@entity=N'Customer',@pageNo=1,@pageSize=50,@orderBy=N'Customer.CustItemNumber',@where=NULL,@parentId=0,@isNext=0,@isEnd=0,@recordId=0,@groupBy=NULL,@groupByWhere=NULL,@TotalCount=@p15 output
                              --select @p15
-- =============================================  
CREATE PROCEDURE [dbo].[GetCustomerView]  
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
 DECLARE @CustomerCount BIGINT,@IsCustomerAdmin BIT = 0
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
 SET @TCountQuery = 'SELECT @TotalCount = COUNT('+ @entity+'.'+'Id) FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity   
 --Below for getting user specific 'Statuses'  
 SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId]'  
 SET @TCountQuery = @TCountQuery + ' INNER JOIN dbo.COMP000Master  (NOLOCK) COMP ON ' + @entity + '.[ID] = COMP.[CompPrimaryRecordId] ' + 'AND COMP.CompTableName =''Customer'''
 SELECT @CustomerCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdTemp
	WHERE ISNULL(EntityId, 0) = -1


	IF (@CustomerCount = 1)
	BEGIN
		SET @IsCustomerAdmin = 1
	END
 IF (ISNULL(@IsCustomerAdmin,0) = 0)
	BEGIN
	SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END
   
 SET @TCountQuery = @TCountQuery + ' WHERE [CustOrgId] = @orgId ' + ISNULL(@where, '')
   
 EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;  

 IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
  BEGIN
	  
	IF(@recordId = 0)  
	 BEGIN  
	  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
	  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS CustOrgIdName, contWA.[ConFullName] AS CustWorkAddressIdName, ' +   
	        ' contBA.[ConFullName] AS CustBusinessAddressIdName, contCA.[ConFullName] AS CustCorporateAddressIdName, COMP.Id CompanyId '  ;
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
	  
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity  
	--Below to get BIGINT reference key name by Id if NOT NULL  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN dbo.COMP000Master  (NOLOCK) COMP ON ' + @entity + '.[ID] = COMP.[CompPrimaryRecordId] ' + 'AND COMP.CompTableName =''Customer'''
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CustOrgId] = org.[Id] '  
	IF (ISNULL(@IsCustomerAdmin,0) = 0)
	BEGIN
	SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[CustWorkAddressId] = contWA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[CustBusinessAddressId] = contBA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[CustCorporateAddressId] = contCA.[Id] ' ; 
	
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

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CustOrgId] = @orgId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  
	  
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
	 BEGIN  
	  IF((@isNext = 0) AND (@isEnd = 0))  
	   BEGIN  
		IF((ISNULL(@orderBy, '') <> '') AND (CHARINDEX(',', @orderBy) = 0))
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
		 END
		ELSE
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))
		 END
	   END  
	  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
	   BEGIN  
	    IF((ISNULL(@orderBy, '') <> '') AND (CHARINDEX(',', @orderBy) = 0))
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
	  IF(ISNULL(@groupByWhere, '') <> '')
	   BEGIN
		  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
	   END
	  ELSE
	   BEGIN
		  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
	   END
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

 END
 ELSE
  BEGIN
	
	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CustOrgId] = org.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[CustWorkAddressId] = contWA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[CustBusinessAddressId] = contBA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[CustCorporateAddressId] = contCA.[Id] ' ; 
	--Below for getting user specific 'Statuses'  
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
	 BEGIN  
	  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	 END  

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CustOrgId] = @orgId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END
  END

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@groupBy NVARCHAR(500)' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @userId = @userId,
  @groupBy = @groupBy  
  
DROP TABLE #EntityIdTemp
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH


GO

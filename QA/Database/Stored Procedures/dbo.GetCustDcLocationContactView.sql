SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/25/2018        
-- Description:               Get all Customer DC Location Contact 
-- Execution:                 EXEC [dbo].[GetCustDcLocationContactView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)               
-- Modified Desc:           
-- =============================================  
CREATE PROCEDURE [dbo].[GetCustDcLocationContactView]  
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[vwDCLocationContactMapping]  (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] ' 
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) refOp ON ' + @entity + '.[ConCodeId]=refOp.[Id] '   
  
SET @TCountQuery = @TCountQuery + ' WHERE [ConPrimaryRecordId] = @parentId AND ' + @entity + '.[ConTableName] = @entity ' + ISNULL(@where, '')  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @entity NVARCHAR(100), @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @entity, @TotalCount  OUTPUT;  
 
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' +' ' + @entity + '.ConCodeId, ' + @entity + '.ConItemNumber, ' + @entity + '.ContactMSTRID, ' + @entity + '.ConTitle, ' + @entity + '.Id, ' + @entity + '.StatusId,' + @entity + '.ConCompanyId, ' + @entity + '.ConCompanyName ConCompanyIdName '
  SET @sqlCommand = @sqlCommand + ' ,org.OrgCode As ConOrgIdName,' + @entity + '.[ConTitleId] AS ConTitleId, ' + @entity + '.[ConFullName] AS ContactMSTRIDName, ' + @entity + '.ConBusinessPhone AS ConBusinessPhone, 
  ' + @entity + '.ConBusinessPhoneExt AS ConBusinessPhoneExt, ' + @entity + '.ConMobilePhone AS ConMobilePhone, refOp.OrgRoleCode AS ConCodeIdName '  
 END  
ELSE  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
     SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id') + '), 0) AS Id '  
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
     SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id') + '), 0) AS Id '   
   END  
  ELSE  
   BEGIN  
    SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '  
   END  
 END  
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[vwDCLocationContactMapping] (NOLOCK) '+ @entity  
  
--Adding ConCompany
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id=' + @entity + '.ConOrgId'
  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) refOp ON ' + @entity + '.[ConCodeId]=refOp.[Id] '  
  
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
  
SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.[ConPrimaryRecordId] = @parentId AND ' + @entity + '.[ConTableName] = @entity ' + ISNULL(@where, '')  
  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwDCLocationContactMapping] (NOLOCK) ' + @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @entity + 'cc.Id <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwDCLocationContactMapping] (NOLOCK) ' + @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
 END  
  
SET @sqlCommand = @sqlCommand + ' ORDER BY '+ ISNULL(@orderBy, '' + @entity + '.Id')  
  
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
  @entity= @entity,  
  @pageNo= @pageNo,   
  @pageSize= @pageSize,  
  @orderBy = @orderBy,  
  @where = @where,  
  @orgId = @orgId,  
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               12/17/2018      
-- Description:               Get all System Account
-- Execution:                 EXEC [dbo].[GetSystemAccountView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================        
CREATE PROCEDURE [dbo].[GetSystemAccountView]      
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
 @langCode NVARCHAR(10),       
 @TotalCount INT OUTPUT      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;        
 DECLARE @sqlCommand NVARCHAR(MAX);      
 DECLARE @TCountQuery NVARCHAR(MAX);      
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity       
      
--Below for getting user specific 'Statuses'      
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
 BEGIN      
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '   ;
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[SysOrgId] = org.[Id] ';  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[SysOrgRefRoleId] = rol.[Id] '  ;  
 END      
      
SET @TCountQuery = @TCountQuery + ' WHERE [SysOrgId] = @orgId ' + ISNULL(@where, '')      

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;      
     
IF(@recordId = 0)      
 BEGIN      
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)       
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS SysOrgIdName, cont.[ConFullName] AS SysUserContactIDName, rol.OrgRoleCode as SysOrgRefRoleIdName ,'+@entity+'.IsSysAdmin As IsSysAdminPrev'      
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
      
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity      
--Below to get BIGINT reference key name by Id if NOT NULL      
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[SysOrgId] = org.[Id] '  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[SysOrgRefRoleId] = rol.[Id] '  ;   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[SysUserContactID] = cont.[Id] '     
      
--Below for getting user specific 'Statuses'      
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
 BEGIN      
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '      
 END      
      
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[SysOrgId] = @orgId '+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))      
 BEGIN      
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,      
  @entity= @entity,      
     @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,      
  @userId = @userId      
      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO

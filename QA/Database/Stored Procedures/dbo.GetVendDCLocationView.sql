SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor dc location
-- Execution:                 EXEC [dbo].[GetVendDCLocationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[GetVendDCLocationView]
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--Below to get BIGINT reference key name by Id if NOT NULL
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VdcContactMSTRID]=cont.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

SET @TCountQuery = @TCountQuery + ' WHERE [VdcVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
BEGIN

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , vend.[VendCode] AS VdcVendorIDName, cont.[ConFullName] AS VdcContactMSTRIDName '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConJobTitle] AS ConJobTitle, cont.[ConEmailAddress] AS ConEmailAddress '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConCompanyId] AS ConCompanyId '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConMobilePhone] AS ConMobilePhone, cont.[ConBusinessPhone] AS ConBusinessPhone '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1, cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessCity] AS ConBusinessCity, cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
		SET @sqlCommand = @sqlCommand + ' , sts.[StateAbbr] AS ConBusinessStateIdName, sysRef.[SysOptionName] AS ConBusinessCountryIdName '
		SET @sqlCommand = @sqlCommand + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC010Bridge] (NOLOCK) CB ON CB.[ConPrimaryRecordId]=VendDcLocation.[Id] AND (CB.ConTableName=''VendDcLocation'' OR (CB.ConTableName=''VendContact'' AND CB.ConTitle=''Vendor_default'')) '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON CB.ContactMSTRID=cont.[Id] ' 
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '


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

--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')


SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+ @entity + '.[VdcVendorID]=@parentId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
	
	DECLARE @SelectClauseToAdd NVARCHAR(500) = '';

	IF(@groupBy = (@entity + '.VdcVendorIDName'))
	 BEGIN
		SET @groupBy = ' vend.[VendCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , vend.[VendCode] AS VdcVendorIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.VdcContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS VdcContactMSTRIDName ';
	 END
	 ELSE IF(@groupBy = (@entity + '.ConJobTitle'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConJobTitle] AS ConJobTitle '
	 END
	ELSE IF(@groupBy = (@entity + '.ConEmailAddress'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConEmailAddress] AS ConEmailAddress '
	 END
	 ELSE IF(@groupBy = (@entity + '.ConMobilePhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConMobilePhone] AS ConMobilePhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessPhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessPhone] AS ConBusinessPhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress1'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress2'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCity'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessCity] AS ConBusinessCity '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessZipPostal'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessStateIdName'))
	 BEGIN
		SET @groupBy = ' sts.[StateAbbr] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sts.[StateAbbr] AS ConBusinessStateIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCountryIdName'))
	 BEGIN
		SET @groupBy = ' sysRef.[SysOptionName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sysRef.[SysOptionName] AS ConBusinessCountryIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessFullAddress'))
	 BEGIN
		SET @groupBy = ' ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress ';
		SET @orderBy = REPLACE(@orderBy, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )');
	 END


	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount '
	SET @sqlCommand = @sqlCommand + @SelectClauseToAdd
	SET @sqlCommand = @sqlCommand +' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VdcContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')
	
	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[VdcVendorID]=@parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END

END

	--To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcVendorIDName', 'vend.[VendCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcContactMSTRIDName', 'cont.[ConFullName]')
	  SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcContactMSTRID', 'cont.[Id] AS VdcContactMSTRID')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConJobTitle', 'ConJobTitle')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConEmailAddress', 'ConEmailAddress')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConMobilePhone', 'ConMobilePhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessPhone', 'ConBusinessPhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress1', 'ConBusinessAddress1')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress2', 'ConBusinessAddress2')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCity', 'ConBusinessCity')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessZipPostal', 'ConBusinessZipPostal')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessStateIdName', 'sts.[StateAbbr]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCountryIdName', 'sysRef.[SysOptionName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessFullAddress', 'ConBusinessFullAddress')

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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

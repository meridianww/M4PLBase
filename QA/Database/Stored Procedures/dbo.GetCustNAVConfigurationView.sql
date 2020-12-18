SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal      
-- Create date:               12/17/2020
-- Description:               Get Customer Nav Configuration View 
-- Execution:                
-- =============================================  
ALTER PROCEDURE [dbo].[GetCustNAVConfigurationView] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@pageNo INT
	,@pageSize INT
	,@orderBy NVARCHAR(500)
	,@groupBy NVARCHAR(500)
	,@groupByWhere NVARCHAR(500)
	,@where NVARCHAR(MAX)
	,@parentId BIGINT
	,@isNext BIT
	,@isEnd BIT
	,@recordId BIGINT
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX);
	DECLARE @TCountQuery NVARCHAR(MAX);

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.' + 'NAVConfigurationId) FROM [dbo].[SYSTM000CustNAVConfiguration] (NOLOCK) ' + @entity
	SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustomerId]=cust.[Id] '
	SET @TCountQuery = @TCountQuery + ' WHERE '+ @entity + '.[CustomerId] =' + CONVERT(NVARCHAR(10), @parentId) + ISNULL(@where, '')
	EXEC sp_executesql @TCountQuery
		,N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT'
		,@orgId
		,@userId
		,@TotalCount OUTPUT;

	IF (
			(ISNULL(@groupBy, '') = '')
			OR (@recordId > 0)
			)
	BEGIN
		IF (@recordId = 0)
		BEGIN
			SET @sqlCommand = 'SELECT ' + @entity + '.NAVConfigurationId,' + @entity + '.ServiceUrl,
	  ' + @entity + '.ServiceUserName,' + @entity + '.ServicePassword,' + @entity + '.CustomerId,' + @entity + '.DateEntered,
	  ' + @entity + '.EnteredBy,' + @entity + '.DateChanged,' + @entity + '.ChangedBy, ' + @entity + '.StatusId '
		END
		ELSE
		BEGIN
			IF (
					(@isNext = 0)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.NAVConfigurationId) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.NAVConfigurationId') + '), 0) AS Id '
			END
			ELSE IF (
					(@isNext = 1)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.NAVConfigurationId) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.NAVConfigurationId') + '), 0) AS Id '
			END
			ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.NAVConfigurationId '
			END
		END

		SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000CustNAVConfiguration] (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustomerId]=cust.[Id] '
		SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[CustomerId] =' + CONVERT(NVARCHAR(10), @parentId) 
		
		--Below to update order by clause if related to Ref_Options
		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			DECLARE @orderByJoinClause NVARCHAR(500);

			SELECT @orderBy = OrderClause
				,@orderByJoinClause = JoinClause
			FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);

			IF (ISNULL(@orderByJoinClause, '') <> '')
			BEGIN
				SET @sqlCommand = @sqlCommand + @orderByJoinClause
			END
		END

		SET @sqlCommand += ISNULL(@where, '') + ISNULL(@groupByWhere, '')

		IF (
				(@recordId > 0)
				AND (
					(
						(@isNext = 0)
						AND (@isEnd = 0)
						)
					OR (
						(@isNext = 1)
						AND (@isEnd = 0)
						)
					)
				)
		BEGIN
			IF (
					(@isNext = 0)
					AND (@isEnd = 0)
					)
			BEGIN
				IF (
						(ISNULL(@orderBy, '') <> '')
						AND (CHARINDEX(',', @orderBy) = 0)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000CustNAVConfiguration] (NOLOCK) ' + @entity + ' WHERE ' + @entity + '.NAVConfigurationId=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.NAVConfigurationId <= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
			ELSE IF (
					(@isNext = 1)
					AND (@isEnd = 0)
					)
			BEGIN
				IF (
						(ISNULL(@orderBy, '') <> '')
						AND (CHARINDEX(',', @orderBy) = 0)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[SYSTM000CustNAVConfiguration] (NOLOCK) ' + @entity + ' WHERE ' + @entity + '.NAVConfigurationId=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.NAVConfigurationId >= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY ' + ISNULL(@orderBy, @entity + '.NAVConfigurationId')

		IF (@recordId = 0)
		BEGIN
			IF (ISNULL(@groupByWhere, '') <> '')
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
			IF (@orderBy IS NULL)
			BEGIN
				IF (
						(
							(@isNext = 1)
							AND (@isEnd = 1)
							)
						OR (
							(@isNext = 0)
							AND (@isEnd = 0)
							)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' DESC'
				END
			END
			ELSE
			BEGIN
				IF (
						(
							(@isNext = 1)
							AND (@isEnd = 1)
							)
						OR (
							(@isNext = 0)
							AND (@isEnd = 0)
							)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' DESC'
				END
			END
		END
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.NAVConfigurationId) AS DataCount FROM [dbo].[SYSTM000CustNAVConfiguration] (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustomerId]=cust.[Id] '
		SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[CustomerId] =' + CONVERT(NVARCHAR(10), @parentId) + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy

		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @orderBy
		END
	END
	PRINT @sqlCommand
	EXEC sp_executesql @sqlCommand
		,N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@groupBy NVARCHAR(500)'
		,@entity = @entity
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@orderBy = @orderBy
		,@where = @where
		,@orgId = @orgId
		,@userId = @userId
		,@groupBy = @groupBy
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
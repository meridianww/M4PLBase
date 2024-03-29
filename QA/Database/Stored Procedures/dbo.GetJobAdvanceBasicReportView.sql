SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal          
-- Create date:               01/20/2020      
-- Description:               Get Job Advance Report Data  
-- =============================================
ALTER PROCEDURE [dbo].[GetJobAdvanceBasicReportView] @userId BIGINT
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
	,@IsExport BIT = 0
	,@scheduled NVARCHAR(500) = ''
	,@orderType NVARCHAR(500) = ''
	,@DateType NVARCHAR(500) = ''
	,@JobStatus NVARCHAR(100) = NULL
	,@SearchText NVARCHAR(300) = ''
	,@gatewayTitles NVARCHAR(800) = ''
	,@PackagingCode NVARCHAR(50) = ''
	,@CargoId BIGINT = NULL
	,@reportTypeId INT = NULL
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX)
		,@TablesQuery NVARCHAR(MAX)
	    ,@TCountQuery NVARCHAR(MAX)
		
	DECLARE @AdvanceFilter NVARCHAR(MAX) = ''
		,@JobStatusId INT = 0;
    SET @where = REPLACE(@where,'prg.PrgCustID','JobAdvanceReport.CustomerId')
	SET @where = REPLACE(@where,'prg.Id','JobAdvanceReport.ProgramId')
	IF (@JobStatus = 'Active')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Active'
				);
	END
	ELSE IF (@JobStatus = 'Inactive')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Inactive'
				);
	END
	ELSE IF (@JobStatus = 'Archive')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Archive'
				);
	END
	ELSE IF (@JobStatus = 'Canceled')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Canceled'
				);
	END

	SET @TablesQuery = ' FROM CUST000Master CUST ' 
	+ ' INNER JOIN [dbo].[vwJobMasterData] (NOEXPAND) ' + @entity + ' ON ' + @entity +'.CustomerId = CUST.Id AND CUST.StatusId = 1 '
	IF(@JobStatusId >0 )
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.StatusId = ' + CONVERT(NVARCHAR(10), @JobStatusId)
	END
	IF ((ISNULL(@orderType, '') <> '' AND ISNULL(@orderType, '') <> 'ALL'))
	BEGIN
	   SET @TablesQuery += ' AND JobAdvanceReport.JobType = ''' + @orderType +''''
	END		 
	IF (ISNULL(@scheduled, '') = 'Not Scheduled')
	BEGIN
		SET @TablesQuery += ' AND (JobAdvanceReport.JobIsSchedule = 0 ) '  
	END
	ELSE IF (ISNULL(@scheduled, '') = 'Scheduled')
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.JobIsSchedule = 1'  
	END 
	IF(ISNULL(@gatewayTitles, '') <> '' AND ISNULL(@gatewayTitles, '') <> 'ALL')
	BEGIN 
	  DECLARE @Titles NVARCHAR(500) = '';
	  CREATE TABLE #TEMP (TypeId INT PRIMARY KEY);
	  SET @Titles += 'INSERT INTO #TEMP(TypeId) SELECT DISTINCT GatewayTypeId FROM [dbo].[vwJobGateways] (NOEXPAND)
	  WHERE StatusId IN (194,195) AND GwyGatewayCode IN '
	  + @gatewayTitles + ' OR GwyGatewayTitle IN ' + @gatewayTitles +'';
	  EXEC sp_executesql @Titles;  
	  IF (((SELECT COUNT(TypeId) FROM #TEMP) = 1) AND ((SELECT COUNT(TypeId) FROM #TEMP WHERE TypeId =85) = 1))
	  BEGIN
	     SET @TablesQuery += ' AND  JobAdvanceReport.JobGatewayStatus IN ' + @gatewayTitles +''
	  END
	  ELSE IF (((SELECT COUNT(TypeId) FROM #TEMP) = 1) AND ((SELECT COUNT(TypeId) FROM #TEMP WHERE TypeId =86) = 1))
	  BEGIN
		    SET @TablesQuery = @TablesQuery + ' INNER JOIN [dbo].[vwJobGateways] (NOEXPAND) gateway ON  gateway.JobId = ' + @entity +
			'.[Id] AND gateway.StatusId IN (194,195) AND gateway.GatewayTypeId = 86 AND gateway.GwyGatewayTitle IN ' 
			+ @gatewayTitles +''	     
	  END
	  ELSE
	  BEGIN
	       SET @TablesQuery = @TablesQuery + ' INNER JOIN [dbo].[vwJobGateways] (NOEXPAND) gateway ON  gateway.JobId = '+ @entity + '.[Id] 
		   AND gateway.StatusId IN (194,195) AND (gateway.GwyGatewayTitle IN ' + @gatewayTitles +' OR gateway.GwyGatewayCode 
		   IN '+ @gatewayTitles +') AND (' + @entity + '.JobGatewayStatus IN ' + @gatewayTitles +')'
	  END	   
	  DROP TABLE #TEMP
	END
	
	--------------------- Security Start----------------------------------------------------------
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN 
		DROP TABLE #EntityIdTemp
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)
	CREATE NONCLUSTERED INDEX [IDX_#EntityIdTemp_EntityId] ON #EntityIdTemp (EntityId)

	INSERT INTO #EntityIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Job'

	IF EXISTS (
			SELECT 1
			FROM #EntityIdTemp
			WHERE ISNULL(EntityId, 0) = - 1
			)
	BEGIN
		SET @IsJobAdmin = 1
	END
	ELSE
	BEGIN
		SET @TablesQuery = @TablesQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END
	------------------------------- Security End---------------------------------------
	
	SET @TCountQuery = 'SELECT @TotalCount = COUNT( DISTINCT ' + @entity + '.Id) ' + @TablesQuery

	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @TCountQuery = @TCountQuery + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + @where
    END
	EXEC sp_executesql @TCountQuery
		,N'@userId BIGINT, @TotalCount INT OUTPUT'
		,@userId
		,@TotalCount OUTPUT;
	IF (
			(ISNULL(@groupBy, '') = '')
			OR (@recordId > 0)
			)
	BEGIN
		IF (@recordId = 0)
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT ' + [dbo].[fnGetJobReportBaseQuery](@entity, @userId, @reportTypeId)
			--SET @sqlCommand = @sqlCommand+' ,TotalRows = COUNT(*) OVER()'
		END
		ELSE
		BEGIN
			IF (
					(@isNext = 0)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id') + '), 0) AS Id '
			END
			ELSE IF (
					(@isNext = 1)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id') + '), 0) AS Id '
			END
			ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '
			END
		END

		----------------   
		-------------------------
		SET @sqlCommand = @sqlCommand + ' ,' + @entity + '.JobProductType ProductType, ' + @entity + '.JobChannel Channel,' + @entity + '.JobTotalWeight '
		SET @sqlCommand = @sqlCommand + ' ,JobAdvanceReport.DateEntered,JobAdvanceReport.PrgCustID CustomerId,cust.CustTitle '
		SET @sqlCommand = @sqlCommand + ', CAST(1 AS BIT) IsIdentityVisible ';
		SET @sqlCommand += @TablesQuery

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

		IF (ISNULL(@where, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		END
				
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
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id <= ' + CAST(@recordId AS NVARCHAR(50))
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
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id >= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id')

		IF (
				@recordId = 0
				AND @IsExport = 0
				)
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
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[vwJobMasterData] (NOEXPAND) ' + @entity
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy

		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @orderBy
		END
	END
	
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.CustomerTitle', 'Cust.CustTitle');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.CustTitle', 'Cust.CustTitle');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.PrgCustID', 'JobAdvanceReport.CustomerId');
	SET @where = REPLACE(@where, 'JobAdvanceReport.CustomerTitle', 'Cust.CustTitle');
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
GO


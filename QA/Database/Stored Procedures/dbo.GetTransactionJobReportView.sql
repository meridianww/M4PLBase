
/****** Object:  StoredProcedure [dbo].[GetTransactionJobReportView]    Script Date: 8/24/2020 3:06:08 PM ******/
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
CREATE PROCEDURE [dbo].[GetTransactionJobReportView] @userId BIGINT
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
	,@reportTypeId INT = 0
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX)
		,@TCountQuery NVARCHAR(MAX)
		,@TablesQuery NVARCHAR(MAX)
		,@GatewayTypeId INT = 0
		,@GatewayActionTypeId INT = 0;
	DECLARE @AdvanceFilter NVARCHAR(MAX) = ''
		,@JobStatusId INT = 0;

	IF (
			ISNULL(@JobStatus, '') = ''
			OR @JobStatus = 'Active'
			)
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

	SELECT @GatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @GatewayActionTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

	SET @TablesQuery = ' FROM CUST000Master CUST ' + ' INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id AND CUST.StatusId = 1 AND PRG.StatusId = 1 ' + ' INNER JOIN JOBDL000Master ' + @entity + ' ON ' + @entity + '.ProgramID = PRG.Id  AND JobAdvanceReport.StatusId = ' + CONVERT(NVARCHAR(10), @JobStatusId)

	--------------------- Security Start----------------------------------------------------------
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityIdTemp
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)

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
	IF ( (
				(
					ISNULL(@PackagingCode, '') <> ''
					AND ISNULL(@PackagingCode, '') <> 'ALL'
					)
				OR (ISNULL(@CargoId, 0) > 0)
				)
			)
	BEGIN
		SET @TablesQuery = @TablesQuery + ' INNER JOIN JOBDL010Cargo JC ON JC.JobID = ' + @entity + '.Id AND JC.StatusId = 1'
	END

	IF (
			ISNULL(@PackagingCode, '') <> ''
			AND ISNULL(@PackagingCode, '') <> 'ALL'
			)
	BEGIN
		SET @TablesQuery = @TablesQuery + ' LEFT JOIN SYSTM000Ref_Options SO ON JC.CgoPackagingTypeId = SO.Id '
		SET @TablesQuery = @TablesQuery + ' AND SO.SysOptionName = ''' + @PackagingCode + '''';
	END

	IF (
			(
				ISNULL(@orderType, '') <> ''
				AND ISNULL(@orderType, '') <> 'ALL'
				)
			OR (
				ISNULL(@DateType, '') <> ''
				AND ISNULL(@DateType, '') <> 'ALL'
				)
			OR (
				ISNULL(@gatewayTitles, '') <> ''
				AND ISNULL(@gatewayTitles, '') <> 'ALL'
				)
			OR (
				ISNULL(@scheduled, '') <> ''
				AND ISNULL(@scheduled, '') <> 'ALL'
				)
			)
	BEGIN
		DECLARE @condition NVARCHAR(500) = '';
		DECLARE @GatewayCommand NVARCHAR(500);

		SET @GatewayCommand = 'SELECT DISTINCT GWY.JobID from  JOBDL020Gateways GWY  (NOLOCK) WHERE (1=1) ' + ' AND GWY.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE GwyCompleted = 1 '

		IF (
				(
					ISNULL(@gatewayTitles, '') <> ''
					AND ISNULL(@gatewayTitles, '') <> 'ALL'
					)
				OR (
					ISNULL(@orderType, '') <> ''
					AND ISNULL(@orderType, '') <> 'ALL'
					)
				)
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND GatewayTypeId = ' + CONVERT(VARCHAR, @GatewayTypeId)
		END

		IF (ISNULL(@scheduled, '') = 'Not Scheduled')
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND JobId NOT IN (SELECT DISTINCT JobId FROM JOBDL020Gateways WHERE GatewayTypeId= ' + CONVERT(VARCHAR, @GatewayActionTypeId) + ')  AND JobId IS NOT NULL '
		END
		ELSE IF (ISNULL(@scheduled, '') = 'Scheduled')
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND JobId IN (SELECT DISTINCT JobId FROM JOBDL020Gateways WHERE GatewayTypeId= ' + CONVERT(VARCHAR, @GatewayActionTypeId) + ')  AND JobId IS NOT NULL'
		END

		SET @GatewayCommand = @GatewayCommand + ' GROUP BY JobID ) AND GWY.GwyCompleted = 1 '

		IF (ISNULL(@DateType, '') <> '')
		BEGIN
			SET @GatewayCommand = 'SELECT DISTINCT GWY.JobID from  JOBDL020Gateways GWY  (NOLOCK) WHERE (1=1) '
			SET @GatewayCommand += @DateType
		END

		IF (
				ISNULL(@orderType, '') <> ''
				AND ISNULL(@orderType, '') <> 'ALL'
				)
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND GWY.GwyOrderType = ''' + @orderType + ''''
		END

		IF (
				ISNULL(@gatewayTitles, '') <> ''
				AND ISNULL(@gatewayTitles, '') <> 'ALL'
				)
		BEGIN
			SET @condition = ' ' + @gatewayTitles
		END

		SET @GatewayCommand = @GatewayCommand + @condition

		IF OBJECT_ID('tempdb..#JOBDLGateways') IS NOT NULL
		BEGIN
			DROP TABLE #JOBDLGateways
		END

		CREATE TABLE #JOBDLGateways (JobID BIGINT)

		INSERT INTO #JOBDLGateways
		EXEC sp_executesql @GatewayCommand

		CREATE NONCLUSTERED INDEX ix_tempJobIndexAft ON #JOBDLGateways ([JobID]);

		SET @TablesQuery = @TablesQuery + ' INNER JOIN #JOBDLGateways GWY ON GWY.JobID=JobAdvanceReport.[Id] '
	END

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) ' + @TablesQuery

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
			SET @sqlCommand = 'SELECT ' + [dbo].[fnGetJobReportBaseQuery](@entity, @userId, @reportTypeId)
			SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.GwyGatewayACD', 'CASE WHEN ISNULL(Gateway.GwyGatewayACD, '''') = '''' THEN GwyGatewayACD ELSE FORMAT(GwyGatewayACD,''MM/dd/yyyy hh:mm tt'') END GwyGatewayACD');
			SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Labels', 'ISNULL(Cargo.Labels, 0) Labels');
			SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Inbound', 'ISNULL(Cargo.Inbound,0) Inbound');
			SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Outbound', 'ISNULL(Cargo.Outbound,0) Outbound');
			SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Delivered', 'ISNULL(Cargo.Delivered,0) Delivered');
			SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Cabinets', 'ISNULL(Cargo.Cabinets,0) Cabinets ');
			SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Parts', 'ISNULL(Cargo.Parts, 0) Parts');
			SET @sqlCommand = @sqlCommand + ', CAST(1 AS BIT) IsIdentityVisible ';
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

		SET @sqlCommand += @TablesQuery
		SET @sqlCommand += ' LEFT JOIN dbo.JobCargoAdvanceReportView Cargo ON Cargo.JobId =' + @entity + '.Id'
		SET @sqlCommand += ' LEFT JOIN dbo.JOBDL020Gateways Gateway ON Gateway.JobId = ' + @entity + '.Id ' + 'AND Gateway.StatusId = 194 AND Gateway.GatewayTypeId = 85 AND GwyGatewayCode IN (''DS On Truck'', ''Loaded on Truck'', ''On Truck'')'

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
		END
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy

		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @orderBy
		END
	END
	Print @sqlCommand
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

	IF (
			(
				ISNULL(@orderType, '') <> ''
				AND ISNULL(@orderType, '') <> 'ALL'
				)
			OR (
				ISNULL(@DateType, '') <> ''
				AND ISNULL(@DateType, '') <> 'ALL'
				)
			OR (
				ISNULL(@gatewayTitles, '') <> ''
				AND ISNULL(@gatewayTitles, '') <> 'ALL'
				)
			OR (
				ISNULL(@scheduled, '') <> ''
				AND ISNULL(@scheduled, '') <> 'ALL'
				)
			)
	BEGIN
		DROP TABLE #JOBDLGateways
	END
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

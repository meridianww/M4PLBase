SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               08/18/2020      
-- Description:               Get Manifest Report Data  
-- =============================================
CREATE PROCEDURE [dbo].[GetManifestReportView] @userId BIGINT
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
	SET @TablesQuery = @TablesQuery + ' INNER JOIN JOBDL010Cargo JC ON JC.JobID = ' + @entity + '.Id AND JC.StatusId = 1'
	SET @TablesQuery = @TablesQuery + ' LEFT JOIN SYSTM000Ref_Options SO ON JC.CgoPackagingTypeId = SO.Id '

	IF (
			(
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
	ELSE IF (ISNULL(@CargoId, 0) > 0)
	BEGIN
		SET @TablesQuery = @TablesQuery + ' AND JC.Id = ' + CONVERT(NVARCHAR(10), @CargoId)
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
		SET @where = REPLACE(@where, 'JobAdvanceReport.CargoTitle', 'JC.CgoTitle');
		SET @where = REPLACE(@where, 'JobAdvanceReport.CgoPartCode', 'JC.CgoPartNumCode');
		SET @where = REPLACE(@where, 'JobAdvanceReport.PackagingCode', 'SO.ID');
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobTotalWeight', 'JC.CgoWeight');
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobTotalCubes', 'JC.CgoCubes');
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobServiceActual', 'CASE WHEN SO.SysOptionName = ''Service'' THEN 1 ELSE 0 END')
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobPartsActual', 'CASE WHEN SO.SysOptionName = ''Accessory'' THEN 1 ELSE 0 END')
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobQtyActual', 'CASE WHEN SO.SysOptionName = ''Appliance'' THEN 1 ELSE 0 END')
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
		print @sqlCommand
		SET @sqlCommand = @sqlCommand + ' ,' + @entity + '.JobPartsActual TotalParts, ' + @entity + '.JobQtyActual TotalQuantity, ' + @entity + '.JobProductType ProductType, ' + @entity + '.JobChannel Channel,' + @entity + '.JobTotalWeight '
		SET @sqlCommand = @sqlCommand + ' ,JobAdvanceReport.DateEntered,prg.PrgCustID CustomerId,cust.CustTitle '
		SET @sqlCommand += ' , JC.CgoTitle CargoTitle, JC.CgoPackagingTypeId PackagingCode, JC.CgoPartNumCode AS CgoPartCode';
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobTotalCubes', 'JC.CgoCubes JobTotalCubes')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobTotalWeight', 'JC.CgoWeight JobTotalWeight')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobServiceActual', 'CASE WHEN SO.SysOptionName = ''Service'' THEN 1 ELSE 0 END JobServiceActual')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobPartsActual TotalParts', 'CASE WHEN SO.SysOptionName = ''Accessory'' THEN 1 ELSE 0 END TotalParts')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobQtyActual TotalQuantity', 'CASE WHEN SO.SysOptionName = ''Appliance'' THEN 1 ELSE 0 END TotalQuantity')
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
GO


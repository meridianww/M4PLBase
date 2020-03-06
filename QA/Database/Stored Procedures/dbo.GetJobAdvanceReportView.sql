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
ALTER PROCEDURE [dbo].[GetJobAdvanceReportView] @userId BIGINT
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
	,@JobStatus NVARCHAR(100) = ''
	,@SearchText NVARCHAR(300) = ''
	,@gatewayTitles NVARCHAR(800) = ''
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX);
	DECLARE @TCountQuery NVARCHAR(MAX);
	DECLARE @GatewayTypeId INT = 0, @GatewayActionTypeId INT = 0

	SELECT @GatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

		SELECT @GatewayActionTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

	--------------------- Security ----------------------------------------------------------
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityIdTemp
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)

	IF (ISNULL(@IsJobAdmin, 0) = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END

	INSERT INTO #EntityIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Job' --@entity

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity
	+ ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]=JobAdvanceReport.[ProgramID] '
	+ ' INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID]  '

	SELECT @JobCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdTemp
	WHERE ISNULL(EntityId, 0) = - 1

	IF (@JobCount = 1)
	BEGIN
		SET @IsJobAdmin = 1
	END

	--SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]=JobAdvanceReport.[ProgramID] '
	--+'INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID]  '

	IF (ISNULL(@IsJobAdmin, 0) = 0)
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END

	PRINT @TCountQuery

	--------------------------end-----------------------------------------------------
	IF (
			(ISNULL(@orderType, '') <> '')
			OR (ISNULL(@DateType, '') <> '')
			OR (ISNULL(@gatewayTitles, '') <> '')
			OR (ISNULL(@scheduled, '') <> '')
			)
	BEGIN
		DECLARE @condition NVARCHAR(500);
		DECLARE @GatewayCommand NVARCHAR(500);

		SET @GatewayCommand = 'SELECT DISTINCT GWY.JobID from  JOBDL020Gateways GWY  (NOLOCK) WHERE (1=1) '
		+' AND GWY.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE GwyCompleted = 1 '
		
		IF(ISNULL(@scheduled, '') = 'Not Scheduled')
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND JobId NOT IN (SELECT DISTINCT JobId FROM JOBDL020Gateways WHERE GatewayTypeId= ' + @GatewayActionTypeId + ')  AND JobId IS NOT NULL '
		END
		ELSE IF(ISNULL(@scheduled, '') = 'Scheduled')
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND JobId IN (SELECT DISTINCT JobId FROM JOBDL020Gateways WHERE GatewayTypeId= ' + @GatewayActionTypeId + ')  AND JobId IS NOT NULL'
		END

		SET @GatewayCommand = @GatewayCommand + ' GROUP BY JobID ) AND GWY.GwyCompleted = 1 '
		
			--IF(NULLIF(@orderType, '') IS NOT NULL)
		IF(ISNULL(@orderType, '') <> '')
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND GWY.GwyOrderType = ''' + @orderType+''''
		END

		--IF(ISNULL(@scheduled, '') = 'Not Scheduled')
		--BEGIN
		--	SET @GatewayCommand = @GatewayCommand + ' AND GWY.GatewayTypeId = ' + CONVERT(nvarchar(6),  @GatewayTypeId)
		--END
		--ELSE IF(ISNULL(@scheduled, '') = 'Scheduled')
		--BEGIN
		--	SET @GatewayCommand = @GatewayCommand + ' AND GWY.GatewayTypeId = ' + CONVERT(nvarchar(6), @GatewayActionTypeId)
		--END
		
		SET @condition = ISNULL(@DateType, '') + ' ' + ISNULL(@gatewayTitles, '')
		SET @GatewayCommand = @GatewayCommand + @condition
		
		IF OBJECT_ID('tempdb..#JOBDLGateways') IS NOT NULL
		BEGIN
			DROP TABLE #JOBDLGateways
		END

		CREATE TABLE #JOBDLGateways (JobID BIGINT)

		INSERT INTO #JOBDLGateways
		EXEC sp_executesql @GatewayCommand

		CREATE NONCLUSTERED INDEX ix_tempJobIndexAft ON #JOBDLGateways ([JobID]);

		SET @TCountQuery = @TCountQuery + ' INNER JOIN #JOBDLGateways JWY ON JWY.JobID=JobAdvanceReport.[Id] '
	END

	IF (ISNULL(@JobStatus, '') <> '')
	BEGIN
		DECLARE @JobStatusCondition NVARCHAR(200);
		DECLARE @JobStatusId BIGINT;

		SELECT @JobStatusId = Id
		FROM SYSTM000Ref_Options
		WHERE SysLookupCode = 'Status'
			AND SysOptionName = @JobStatus
			AND Id IS NOT NULL

		SET @JobStatusCondition = ' AND JobAdvanceReport.StatusId = ' + CONVERT(NVARCHAR, @JobStatusId)
		SET @where = @where + @JobStatusCondition;
	END

	--Declare @gatewayTitlesQuery NVARCHAR(200);	
	--IF (ISNULL(@gatewayTitles, '') <> '')
	--BEGIN
	--     SET @gatewayTitlesQuery = ' INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) PrgGwty  on PrgGwty.[PgdProgramID] = prg.[Id] ';
	--	 SET @TCountQuery = @TCountQuery + @gatewayTitlesQuery
	--	 SET @where =  @where +' '+ @gatewayTitles + ' ';
	--END
	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @TCountQuery = @TCountQuery + '  WHERE (1=1) ' + @where
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
			SET @sqlCommand = 'SELECT  DISTINCT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
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
		SET @sqlCommand = @sqlCommand + ' 	,(' + @entity + '.JobPartsActual + ' + @entity + '.JobPartsOrdered) TotalParts
	   ,(' + @entity + '.JobQtyActual + ' + @entity + '.JobQtyOrdered) TotalQuantity, ' + @entity + '.JobProductType ProductType, ' + @entity + '.JobChannel Channel '
		SET @sqlCommand = @sqlCommand + ' ,JobAdvanceReport.DateEntered,prg.PrgCustID CustomerId,cust.CustTitle FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity

		------------------------------------
		IF (ISNULL(@IsJobAdmin, 0) = 0)
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
		END

		------------------------------
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]=' + @entity + '.[ProgramID] '
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID] '

		--IF (ISNULL(@gatewayTitles, '') <> '')
		--   BEGIN
		--    	SET @sqlCommand = @sqlCommand + @gatewayTitlesQuery
		--END
		IF (
				(ISNULL(@orderType, '') <> '')
				OR (ISNULL(@DateType, '') <> '')
				OR (ISNULL(@gatewayTitles, '') <> '')
				OR (ISNULL(@scheduled, '') <> '')
				)
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN #JOBDLGateways JWY ON JWY.JobID=' + @entity + '.[Id] '
		END

		--SET @sqlCommand = @sqlCommand + ' INNER JOIN dbo.JOBDL020Gateways GWY ON GWY.JobID = Job.Id '
		--IF (((ISNULL(@scheduled, '') <> '') OR (ISNULL(@orderType, '') <> '') ) OR ((ISNULL(@DateType, '') <> '')))
		--BEGIN
		--	SET @sqlCommand = @sqlCommand + 'INNER JOIN dbo.JOBDL020Gateways GWY ON GWY.JobID = Job.Id'
		--END
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

		IF (ISNULL(@where, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) ' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
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
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
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
					--ELSE
					--BEGIN
					--	IF (((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
					--	BEGIN
					--		SET @sqlCommand = @sqlCommand + ' DESC'
					--	END
					--END
		END
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity
		--Below for getting user specific 'Statuses'  
		--IF ((ISNULL(@where, '') = '') OR (@where NOT LIKE '%' + @entity + '.StatusId%'))
		--BEGIN
		--	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '
		--END
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) ' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
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
				(ISNULL(@scheduled, '') <> '')
				OR (ISNULL(@orderType, '') <> '')
				)
			OR ((ISNULL(@DateType, '') <> ''))
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

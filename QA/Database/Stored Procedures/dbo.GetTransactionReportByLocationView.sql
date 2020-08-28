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
CREATE PROCEDURE [dbo].[GetTransactionReportByLocationView] @userId BIGINT
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

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(Distinct ' + @entity + '.JobSiteCode)' + @TablesQuery

	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @TCountQuery = @TCountQuery + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + @where
	END

	PRINT @TCountQuery

	EXEC sp_executesql @TCountQuery
		,N'@userId BIGINT, @TotalCount INT OUTPUT'
		,@userId
		,@TotalCount OUTPUT;

	SET @sqlCommand = 'SELECT ' + [dbo].[fnGetJobReportBaseQuery](@entity, @userId, @reportTypeId)
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Id', 'Max(JobAdvanceReport.Id) Id');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Labels', 'SUM(Cargo.Labels) Labels');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Inbound', 'SUM(Cargo.Inbound) Inbound');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Outbound', 'SUM(Cargo.Outbound) Outbound');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Delivered', 'SUM(Cargo.Delivered) Delivered');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Cabinets', 'SUM(Cargo.Cabinets) Cabinets ');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Parts', 'SUM(Cargo.Parts) Parts');
	SET @sqlCommand = @sqlCommand + ', CAST(0 AS BIT) IsIdentityVisible ';	
	SET @sqlCommand = @sqlCommand + ', CAST(1 AS BIT) IsFilterSortDisable ';

	PRINT @sqlCommand

	SET @sqlCommand += @TablesQuery
	SET @sqlCommand += ' LEFT JOIN dbo.JobCargoAdvanceReportView Cargo ON Cargo.JobId =' + @entity + '.Id'

	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + ISNULL(@where, '') + ISNULL(@groupByWhere, '') + ' Group by ' + @entity + '.JobSiteCode'
	END

	SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @entity + '.JobSiteCode'

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


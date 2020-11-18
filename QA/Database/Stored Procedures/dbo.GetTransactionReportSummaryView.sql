
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
ALTER PROCEDURE [dbo].[GetTransactionReportSummaryView] @userId BIGINT
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
		,@AdvanceFilter NVARCHAR(MAX) = ''
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
	
	SET @TablesQuery = ' FROM CUST000Master CUST ' + ' INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id AND CUST.StatusId = 1 AND PRG.StatusId = 1 ' 
	+ ' INNER JOIN JOBDL000Master ' + @entity + ' ON ' + @entity + '.ProgramID = PRG.Id '
	IF(@JobStatusId >0 )
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.StatusId = ' + CONVERT(NVARCHAR(10), @JobStatusId)
	END
	IF ((ISNULL(@orderType, '') <> '' AND ISNULL(@orderType, '') <> 'ALL'))
	BEGIN
	   SET @TablesQuery += ' AND JobAdvanceReport.JobType = ''' + @orderType +''''
	END	
	IF(ISNULL(@gatewayTitles, '') <> '' AND ISNULL(@gatewayTitles, '') <> 'ALL')
	BEGIN 
	  SET @TablesQuery += @gatewayTitles
	END 
	IF (ISNULL(@scheduled, '') = 'Not Scheduled')
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.JobIsSchedule = 0'  
	END
	ELSE IF (ISNULL(@scheduled, '') = 'Scheduled')
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.JobIsSchedule = 1'  
	END
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

	SET @sqlCommand = 'SELECT ' + [dbo].[fnGetJobReportBaseQuery](@entity, @userId, @reportTypeId)
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Id', 'Max(JobAdvanceReport.Id) Id');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.CustTitle', 'Cust.CustTitle');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Labels', 'SUM(Cargo.Labels) Labels');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Inbound', 'SUM(Cargo.Inbound) Inbound');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Outbound', 'SUM(Cargo.Outbound) Outbound');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Delivered', 'SUM(Cargo.Delivered) Delivered');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Cabinets', 'SUM(Cargo.Cabinets) Cabinets ');
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.Parts', 'SUM(Cargo.Parts) Parts');
	SET @sqlCommand = @sqlCommand + ', CAST(0 AS BIT) IsIdentityVisible ';
	SET @sqlCommand = @sqlCommand + ', CAST(1 AS BIT) IsFilterSortDisable ';
	SET @sqlCommand = @sqlCommand+' ,TotalRows = COUNT(*) OVER() '
	
	SET @sqlCommand += @TablesQuery
	SET @sqlCommand += ' LEFT JOIN dbo.JobCargoAdvanceReportView Cargo ON Cargo.JobId =' + @entity + '.Id'

	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + ISNULL(@where, '') + ISNULL(@groupByWhere, '') + ' Group by Cust.CustTitle'
	END

	SET @sqlCommand = @sqlCommand + ' ORDER BY ' + 'Cust.CustTitle'

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
	EXEC sp_executesql @sqlCommand
		,N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@groupBy NVARCHAR(500)'
		,@entity = @entity
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@orderBy = 'Cust.CustTitle'
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

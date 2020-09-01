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
CREATE PROCEDURE [dbo].[GetPrideMatrixReportView] @userId BIGINT
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

	
	SET @TablesQuery = ' FROM CUST000Master CUST ' + ' INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id AND CUST.StatusId = 1 AND PRG.StatusId = 1 ' + ' INNER JOIN JOBDL000Master ' + @entity + ' ON ' + @entity + '.ProgramID = PRG.Id  AND JobAdvanceReport.StatusId = 1 '

	DECLARE @sqlTempTable VARCHAR(max)
	IF OBJECT_ID('tempdb..##JobTemp') IS NOT NULL DROP TABLE ##JobTemp
	SET @sqlTempTable = 'CREATE TABLE ##JobTemp (JobId BIGINT, JobSiteCode Nvarchar(150)) INSERT INTO ##JobTemp (JobId, JobSiteCode) Select JobAdvanceReport.Id,JobAdvanceReport.JobSiteCode '
	SET @sqlTempTable = @sqlTempTable + @TablesQuery

	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @sqlTempTable = @sqlTempTable + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + @where
	END
	EXEC (@sqlTempTable)

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(Distinct JobSiteCode) From ##JobTemp'

	PRINT @TCountQuery

	EXEC sp_executesql @TCountQuery
		,N'@userId BIGINT, @TotalCount INT OUTPUT'
		,@userId
		,@TotalCount OUTPUT;
	SET @sqlCommand = 'Select Max(Temp.JobId) Id, 
	Temp.JobSiteCode, 
	SUM(ISNULL(Cargo.Labels,0)) Labels,
	SUM(ISNULL(Cargo.Delivered,0)) Delivered, 
	CAST(0 AS BIT) IsIdentityVisible, 
	SUM(V.FivePMDeliveryWindow) FivePMDeliveryWindow, 
	SUM(V.ApptScheduledReceiving) ApptScheduledReceiving,
	SUM(V.FourHrWindowDelivery) FourHrWindowDelivery,
	CAST(1 AS BIT) IsFilterSortDisable, 
	Max(ISNULL(SL.OverallScore, 0)) OverallScore ';
	SET @sqlCommand += ' From ##JobTemp Temp'
	SET @sqlCommand += ' INNER JOIN dbo.vwJobPrideMatrixReport V ON V.JobId =Temp.JobId'
	SET @sqlCommand += ' LEFT JOIN dbo.JobCargoAdvanceReportView Cargo ON Cargo.JobId = Temp.JobId'
	SET @sqlCommand += ' LEFT JOIN [dbo].[JobSurveyByLocationView] SL ON SL.JobId =Temp.JobId'
	Print @sqlCommand
	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @sqlCommand = @sqlCommand + ' Group by Temp.JobSiteCode'
	END

	SET @sqlCommand = @sqlCommand + ' ORDER BY Temp.JobSiteCode '

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

	IF OBJECT_ID('tempdb..##JobTemp') IS NOT NULL DROP TABLE ##JobTemp
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


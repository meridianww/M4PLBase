SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 8/18/2020
-- Description:	Get Job Advance Report View
-- =============================================
CREATE PROCEDURE [dbo].[GetJobAdvanceReportView] (
	@userId BIGINT
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
	,@StartDate DateTime2(7) = NULL
	,@EndDate DateTime2(7) = NULL
	,@CustomerId BIGINT = 0
	,@ProjectedYear INT = 0
	,@TotalCount INT OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReportName VARCHAR(150)

	IF(ISNULL(@reportTypeId,0) = 0)
	BEGIN
	   SELECT TOP 1 @reportTypeId = Id
		FROM SYSTM000Ref_Options
		WHERE SysLookupCode ='JobReportType' AND SysDefault = 1
	END
	SELECT @ReportName = SysOptionName
	FROM SYSTM000Ref_Options
	WHERE Id = @reportTypeId
	
	

	IF (ISNULL(@ReportName, '') = 'Job Advance Report')
	BEGIN
		EXEC dbo.GetJobAdvanceBasicReportView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@TotalCount OUTPUT
	END
	ELSE IF (ISNULL(@ReportName, '') = 'Manifest Report')
	BEGIN
		EXEC dbo.GetManifestReportView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@TotalCount OUTPUT
	END
	ELSE IF (ISNULL(@ReportName, '') = 'Transaction Summary')
	BEGIN
		EXEC dbo.GetTransactionReportSummaryView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@TotalCount OUTPUT
	END
	ELSE IF (ISNULL(@ReportName, '') = 'Transaction Locations')
	BEGIN
		EXEC dbo.GetTransactionReportByLocationView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@TotalCount OUTPUT
	END
	ELSE IF (ISNULL(@ReportName, '') = 'Transaction Jobs')
	BEGIN
		EXEC dbo.GetTransactionJobReportView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@TotalCount OUTPUT
	END
	ELSE IF (ISNULL(@ReportName, '') = 'Pride Metric Report')
	BEGIN
		EXEC dbo.GetPrideMatrixReportView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@TotalCount OUTPUT
	END
	ELSE IF(ISNULL(@ReportName, '') = 'Driver Scrub Report')
	BEGIN
	IF(ISNULL(@CustomerId, 0) = 10007)
	BEGIN
	EXEC dbo.GetAWCDriverScrubReportView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@StartDate
	        ,@EndDate
	        ,@CustomerId
			,@TotalCount OUTPUT
    END
	ELSE
	BEGIN
	EXEC dbo.GetCommonDriverScrubReportView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@StartDate
	        ,@EndDate
	        ,@CustomerId
			,@TotalCount OUTPUT
	END
	END
	ELSE IF(ISNULL(@ReportName, '') = 'Capacity Report')
	BEGIN
		EXEC dbo.GetProjectedCapacitybReportView @userId
			,@roleId
			,@orgId
			,@entity
			,@pageNo
			,@pageSize
			,@orderBy
			,@groupBy
			,@groupByWhere
			,@where
			,@parentId
			,@isNext
			,@isEnd
			,@recordId
			,@IsExport
			,@scheduled
			,@orderType
			,@DateType
			,@JobStatus
			,@SearchText
			,@gatewayTitles
			,@PackagingCode
			,@CargoId
			,@reportTypeId
			,@StartDate
	        ,@EndDate
	        ,@CustomerId
			,@ProjectedYear
			,@TotalCount OUTPUT
	END
END
GO


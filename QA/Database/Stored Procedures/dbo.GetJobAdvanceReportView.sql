SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
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
	,@TotalCount INT OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReportName VARCHAR(150)

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
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAWCDriverScrubReportView]
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
,@TotalCount INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @sqlCommand NVARCHAR(MAX)
		,@TCountQuery NVARCHAR(MAX)
		,@TablesQuery NVARCHAR(MAX)
		,@GatewayTypeId INT = 0
		,@GatewayActionTypeId INT = 0;
	DECLARE @AdvanceFilter NVARCHAR(MAX) = ''
		,@JobStatusId INT = 0;


SET @TCountQuery = 'SELECT @TotalCount = COUNT(AD.Id) FROM dbo.AWCDriverScrubReport AD
INNER JOIN dbo.DriverScrubReportMaster DM ON DM.Id = AD.DriverScrubReportMasterId
LEFT JOIN dbo.JobDL000Master Job ON Job.JobCustomerSalesOrder LIKE ''%'' + AD.ActualControlId + ''%''
LEFT JOIN dbo.CONTC000Master DriverContact ON DriverContact.Id = Job.JobDriverId
Where CAST(DM.StartDate AS DATE) <= CAST('''+CAST(@StartDate AS Varchar)+''' AS DATE) AND CAST(DM.EndDate AS DATE) >= CAST('''+CAST(@EndDate AS Varchar)+''' AS DATE)'
Print @TCountQuery
EXEC sp_executesql @TCountQuery
		,N'@StartDate DateTime2(7),@EndDate DateTime2(7),@TotalCount INT OUTPUT'
		,@StartDate
		,@EndDate
		,@TotalCount OUTPUT;


			SET @sqlCommand = 'SELECT AD.QRCDescription LevelGrouped
	,AD.QMSRemark Remarks
	,AD.ThirdParty OriginalThirdPartyCarrier
	,AD.ActualControlId OriginalOrderNumber
	,AD.ModelName Description
	,AD.QMSTotalUnit QtyShipped
	,AD.QMSTotalPrice
	,'''' CabOrPart
	,CASE 
		WHEN ISNULL(DriverContact.ConFirstName, '''') <> ''''
			AND ISNULL(DriverContact.ConLastName, '''') <> ''''
			THEN CONCAT (
					DriverContact.ConFirstName
					,'' ''
					,DriverContact.ConLastName
					)
		WHEN ISNULL(DriverContact.ConFirstName, '''') <> ''''
			AND ISNULL(DriverContact.ConLastName, '''') = ''''
			THEN DriverContact.ConFirstName
		ELSE ''''
		END DriverName
	,'''' InitialedPackingSlip
	,'''' Scanned
	,(
		SELECT dbo.GetOnlyAlpabets(Item)
		FROM (
			SELECT ROW_NUMBER() OVER (
					ORDER BY Item ASC
					) AS rownumber
				,Item
			FROM dbo.fnSplitString(QMSShippedOn, '','')
			) AS MonthTable
		WHERE rownumber = 2
		) [Month]
	,QRCGrouping ShortageDamage
	,(
		SELECT Item
		FROM (
			SELECT ROW_NUMBER() OVER (
					ORDER BY Item ASC
					) AS rownumber
				,Item
			FROM dbo.fnSplitString(QMSShippedOn, '','')
			) AS YearTable
		WHERE rownumber = 1
		) [Year]
	,AD.ProductSubCategory
	,AD.CustomerName Customer
	,CAST(0 AS BIT) IsIdentityVisible
	,AD.Id
	,CAST(1 AS BIT) IsFilterSortDisable
FROM dbo.AWCDriverScrubReport AD
INNER JOIN dbo.DriverScrubReportMaster DM ON DM.Id = AD.DriverScrubReportMasterId
LEFT JOIN dbo.JobDL000Master Job ON Job.JobCustomerSalesOrder LIKE ''%'' + AD.ActualControlId + ''%''
LEFT JOIN dbo.CONTC000Master DriverContact ON DriverContact.Id = Job.JobDriverId '
SET @sqlCommand = @sqlCommand + ' Where CAST(DM.StartDate AS DATE) <= CAST('''+CAST(@StartDate AS Varchar)+''' AS DATE) AND CAST(DM.EndDate AS DATE) >= CAST('''+CAST(@EndDate AS Varchar)+''' AS DATE) ORDER BY AD.Id'
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
	
	Print @sqlCommand
	EXEC sp_executesql @sqlCommand
		,N'@pageNo INT, @pageSize INT,@StartDate DateTime2(7),@EndDate DateTime2(7)'
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@StartDate = @StartDate
		,@EndDate = @EndDate
END
GO

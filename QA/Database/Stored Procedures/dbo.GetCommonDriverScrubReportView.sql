SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kamal
-- Create date: 28-8-2020
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetCommonDriverScrubReportView]
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

IF OBJECT_ID('tempdb..#TempDriverScrub') IS NOT NULL DROP TABLE #TempDriverScrub
Select AD.Id 
		,AD.JobId
		,'N' Scanned
		,AD.ModelName
		,AD.QRCDescription
		,AD.QMSRemark
		,AD.ThirdParty
		,AD.ActualControlId
		,AD.QMSTotalUnit
		,AD.QMSTotalPrice
		,AD.QMSShippedOn
		,AD.ProductCategory
		,AD.ProductSubCategory
		,AD.CustomerName
		,AD.QRCGrouping INTO #TempDriverScrub
FROM dbo.CommonDriverScrubReport AD
INNER JOIN dbo.DriverScrubReportMaster DM ON DM.Id = AD.DriverScrubReportMasterId
Where DM.CustomerId = @CustomerId AND CAST(AD.ShipDate AS DATE) >= CAST(@StartDate AS DATE) AND CAST(AD.ShipDate AS DATE) <= CAST(@EndDate AS DATE)

ALTER TABLE #TempDriverScrub ADD DriverName Varchar(500)
UPDATE tmp
SET Scanned = CASE WHEN ISNULL(Cargo.CgoDateLastScan, '') = '' THEN Scanned ELSE 'Y' END
From #TempDriverScrub tmp
INNER JOIN dbo.JOBDL010Cargo Cargo ON Cargo.JobId = tmp.JobId AND tmp.ModelName like '%' + Cargo.CgoPartNumCode + '%' AND Cargo.StatusId=1

UPDATE tmp
SET DriverName = CASE 
		WHEN ISNULL(DriverContact.ConFirstName, '') <> ''
			AND ISNULL(DriverContact.ConLastName, '') <> ''
			THEN CONCAT (
					DriverContact.ConFirstName
					,' '
					,DriverContact.ConLastName
					)
		WHEN ISNULL(DriverContact.ConFirstName, '') <> ''
			AND ISNULL(DriverContact.ConLastName, '') = ''
			THEN DriverContact.ConFirstName
		ELSE ''
		END 
From #TempDriverScrub tmp
INNER JOIN dbo.JobDL000Master Job ON Job.Id = tmp.JobId
INNER JOIN dbo.CONTC000Master DriverContact ON DriverContact.Id = Job.JobDriverId

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM #TempDriverScrub'

EXEC sp_executesql @TCountQuery
		,N'@TotalCount INT OUTPUT'
		,@TotalCount OUTPUT;


			SET @sqlCommand = 'SELECT QRCDescription LevelGrouped
	,QMSRemark Remarks
	,ThirdParty OriginalThirdPartyCarrier
	,ActualControlId OriginalOrderNumber
	,ModelName Description
	,QMSTotalUnit QtyShipped
	,QMSTotalPrice
	,CASE WHEN ProductCategory IN (''Cabinet'',''Door'',''Drawer Front'')  THEN ''Cab'' ELSE ''Part'' END CabOrPart
	,DriverName
	,'''' InitialedPackingSlip
	,Scanned
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
	,ProductSubCategory
	,CustomerName Customer
	,CAST(0 AS BIT) IsIdentityVisible
	,Id
	,CAST(1 AS BIT) IsFilterSortDisable
FROM #TempDriverScrub '
SET @sqlCommand = @sqlCommand + ' ORDER BY Id'
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
		,N'@pageNo INT, @pageSize INT'
		,@pageNo = @pageNo
		,@pageSize = @pageSize

DROP TABLE #TempDriverScrub
END
GO

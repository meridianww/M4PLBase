SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProjectedCapacitybReportView]
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
,@ProjectedYear INT = 2019
,@TotalCount INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @LastFridayDate DATETIME = DATEADD(day, (DATEDIFF(day, '19800104', CURRENT_TIMESTAMP) / 7) * 7, '19800104')
DECLARE @sqlCommand NVARCHAR(MAX)
		,@TCountQuery NVARCHAR(MAX)
		,@TablesQuery NVARCHAR(MAX)
		,@GatewayTypeId INT = 0
		,@GatewayActionTypeId INT = 0;
	DECLARE @AdvanceFilter NVARCHAR(MAX) = ''
		,@JobStatusId INT = 0;

IF OBJECT_ID('tempdb..#TempProjectedCapacity') IS NOT NULL DROP TABLE #TempProjectedCapacity
CREATE TABLE #TempProjectedCapacity
(
JobId BIGINT,
ProgramId BIGINT,
ProjectedYear INT,
Location Varchar(150),
ProjectedCapacity INT,
CustomerId BIGINT,
OnHandACD DateTime2(7),
OnTruckACD DateTime2(7)
)

CREATE NONCLUSTERED INDEX IX_TempProjectedCapacity_ProgramId
ON #TempProjectedCapacity ([ProgramId])

CREATE NONCLUSTERED INDEX IX_TempProjectedCapacity_ProjectedYear_CustomerId
ON #TempProjectedCapacity ([ProjectedYear],[CustomerId])
INCLUDE ([JobId],[Location],[ProjectedCapacity],[OnHandACD],[OnTruckACD])

INSERT INTO #TempProjectedCapacity(JobId,ProgramId,ProjectedCapacity,Location,ProjectedYear)
Select DISTINCT Job.id,Job.ProgramId,PC.ProjectedCapacity,PC.Location,PC.[Year] From dbo.JOBDL000Master Job
INNER JOIN dbo.LocationProjectedCapacity PC ON PC.Location = Job.JobSiteCode
Where ISNULL(Job.IsCancelled,0) = 0 AND PC.StatusId=1

UPDATE Temp
SET Temp.CustomerId = Prg.PrgCustId
From #TempProjectedCapacity Temp
INNER JOIN dbo.Prgrm000Master Prg ON Prg.Id = Temp.ProgramId

UPDATE Temp
SET Temp.OnHandACD = OnHandGateway.GwyGatewayACD,
Temp.OnTruckACD = OnTruckGateway.GwyGatewayACD
From #TempProjectedCapacity Temp
LEFT JOIN dbo.JOBDL020Gateways OnHandGateway ON OnHandGateway.JobId = Temp.JobId AND OnHandGateway.GwyGatewayCode IN ('On Hand','Onhand')
LEFT JOIN dbo.JOBDL020Gateways OnTruckGateway ON OnTruckGateway.JobId = Temp.JobId AND OnTruckGateway.GwyGatewayCode IN ('Loaded on Truck', 'On Truck')

SET @TCountQuery = 'SELECT @TotalCount = Count(Id) From
(SELECT Max(PC.JobId) Id
FROM #TempProjectedCapacity PC
Where PC.CustomerId = '+ CAST(@CustomerId AS Varchar(50)) +' AND PC.ProjectedYear = '+ CAST(@ProjectedYear AS Varchar(50)) +'
GROUP BY PC.Location,PC.ProjectedCapacity,PC.CustomerId,PC.OnHandACD, PC.OnTruckACD
)temp'

Print @TCountQuery
EXEC sp_executesql @TCountQuery
		,N'@CustomerId BIGINT,@ProjectedYear INT,@TotalCount INT OUTPUT'
		,@CustomerId
		,@ProjectedYear
		,@TotalCount OUTPUT;


SET @sqlCommand = 'SELECT Max(Job.JobId) Id, Job.Location
    ,Job.ProjectedCapacity ProjectedCount
	,CASE 
	WHEN @LastFridayDate  < OnHandACD AND 
		@LastFridayDate  > OnTruckACD
     THEN 
	 CASE WHEN Job.CustomerId = 20047 THEN SUM(CASE 
		  WHEN Package.SysOptionName = ''Appliance''
		  THEN ISNULL(Cargo.CgoQtyOnHand, 0)
		  ELSE 0 END) ELSE 
		  SUM(CASE WHEN Options.SysOptionName IN (''CAB'', ''CABINET'')
		  THEN ISNULL(Cargo.CgoQtyOnHand, 0)
		  ELSE 0 END) END
							ELSE 0
		END Cabinets
FROM #TempProjectedCapacity Job
LEFT JOIN dbo.JobDL010Cargo Cargo ON Cargo.JobID = Job.JobId AND Cargo.StatusId=1
LEFT JOIN dbo.SYSTM000Ref_Options Options ON Options.Id = Cargo.CgoQtyUnitsId
LEFT JOIN dbo.SYSTM000Ref_Options Package ON Package.Id = Cargo.CgoPackagingTypeId'
SET @sqlCommand = @sqlCommand + ' Where Job.CustomerId = '+ CAST(@CustomerId AS Varchar(50)) +' AND Job.[ProjectedYear] = '+ CAST(@ProjectedYear AS Varchar(50)) + +' GROUP BY Job.Location,Job.ProjectedCapacity,Job.CustomerId,Job.OnHandACD, Job.OnTruckACD ' + ' ORDER BY Max(Job.JobId)'
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
		,N'@pageNo INT, @pageSize INT,@LastFridayDate DateTime,@CustomerId BIGINT,@ProjectedYear INT'
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@LastFridayDate = @LastFridayDate
		,@CustomerId = @CustomerId
		,@ProjectedYear = @ProjectedYear

DROP TABLE #TempProjectedCapacity

END
GO

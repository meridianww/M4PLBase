SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant A
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetProjectedCapacitybReportView]
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
DECLARE @sqlCommand NVARCHAR(MAX)
		,@TCountQuery NVARCHAR(MAX)
		,@TablesQuery NVARCHAR(MAX)

IF OBJECT_ID('tempdb..#TempProjectedCapacity') IS NOT NULL DROP TABLE #TempProjectedCapacity
CREATE TABLE #TempProjectedCapacity
(
JobId BIGINT
,CapacityId INT,
ProjectedYear INT,
Location Varchar(150),
ProjectedCapacity INT,
CustomerId BIGINT,
Cabinets INT
)


INSERT INTO #TempProjectedCapacity(JobId,ProjectedCapacity,Location,ProjectedYear,CustomerId,CapacityId)
Select DISTINCT Job.id,PC.ProjectedCapacity,PC.Location,PC.[Year],PC.CustomerId,PC.Id
From dbo.LocationProjectedCapacity PC
INNER JOIN  dbo.JOBDL000Master Job ON Job.JobSiteCode LIKE PC.Location +'%' AND ISNULL(Job.IsCancelled,0) = 0
Where PC.StatusId=1 AND PC.[Year] = @ProjectedYear AND PC.CustomerId = @CustomerId

UPDATE TempCapacity
SET TempCapacity.Cabinets = ISNULL(RT.Cabinets,0)
From #TempProjectedCapacity TempCapacity
INNER JOIN (Select T.Id, SUM(ISNULL(T.Cabinets,0)) Cabinets 
From vwJobCapacityReport T
INNER JOIN #TempProjectedCapacity Temp ON temp.JobId = T.Id
Where Temp.jobId IS NOT NULL
Group BY T.id)RT ON RT.Id = TempCapacity.JobId

SET @TCountQuery = 'SELECT @TotalCount = Count(Distinct Location) From #TempProjectedCapacity'

EXEC sp_executesql @TCountQuery
		,N'@TotalCount INT OUTPUT'
		,@TotalCount OUTPUT;

SET @sqlCommand = 'SELECT Max(Job.CapacityId) Id, Job.Location
,Job.ProjectedCapacity ProjectedCount
,SUM(ISNULL(Cabinets,0)) Cabinets
FROM #TempProjectedCapacity Job
GROUP BY Job.Location,Job.ProjectedCapacity '
SET @sqlCommand = @sqlCommand + ' ORDER BY Max(Job.CapacityId)'
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

DROP TABLE #TempProjectedCapacity

END
GO

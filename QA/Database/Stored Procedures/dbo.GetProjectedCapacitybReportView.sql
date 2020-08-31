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

SET @TCountQuery = 'SELECT @TotalCount = Count(Id) From
(SELECT Max(PC.Id) Id
FROM dbo.LocationProjectedCapacity PC
LEFT JOIN JobDL000Master Job ON Job.JobSiteCode = PC.Location
LEFT JOIN dbo.Prgrm000Master Prg ON Prg.Id = Job.ProgramId
Where PC.StatusId = 1 AND Prg.PrgCustId = '+ CAST(@CustomerId AS Varchar(50)) +' AND PC.[Year] = '+ CAST(@ProjectedYear AS Varchar(50)) +'
GROUP BY PC.Location,PC.ProjectedCapacity,Prg.PrgCustID
)temp'

Print @TCountQuery
EXEC sp_executesql @TCountQuery
		,N'@StartDate DateTime2(7),@EndDate DateTime2(7),@TotalCount INT OUTPUT'
		,@StartDate
		,@EndDate
		,@TotalCount OUTPUT;


SET @sqlCommand = 'SELECT Max(PC.Id) Id, PC.Location
	,PC.ProjectedCapacity
	,CASE 
		WHEN @LastFridayDate > Max(OnHandGateway.GwyGatewayACD) AND 
		     @LastFridayDate < Max(OnHandGateway.GwyGatewayACD) AND 
			 Prg.PrgCustID = 20047
			THEN SUM(CASE WHEN CP.SysOptionName = ''Appliance'' THEN ISNULL(Cargo.CgoQtyOnHand, 0) ELSE 0 END)
		WHEN @LastFridayDate > Max(OnHandGateway.GwyGatewayACD) AND 
		     @LastFridayDate < Max(OnHandGateway.GwyGatewayACD) AND 
			 Prg.PrgCustID <> 20047 
			 THEN SUM(CASE WHEN OP.SysOptionName IN (''CAB'', ''CABINET'') THEN ISNULL(Cargo.CgoQtyOnHand, 0) ELSE 0 END)
        ELSE 0
		END Cabinets
		,CAST(0 AS BIT) IsIdentityVisible
		,CAST(1 AS BIT) IsFilterSortDisable
FROM dbo.LocationProjectedCapacity PC
LEFT JOIN JobDL000Master Job ON Job.JobSiteCode = PC.Location
LEFT JOIN dbo.Prgrm000Master Prg ON Prg.Id = Job.ProgramId
LEFT JOIN dbo.JOBDL010Cargo Cargo ON Cargo.jobId = Job.Id AND Cargo.StatusId = 1
LEFT JOIN dbo.JOBDL020Gateways OnHandGateway ON OnHandGateway.JobId = Job.Id AND OnHandGateway.GwyGatewayCode = ''On Hand'' AND OnHandGateway.StatusId = 1
LEFT JOIN dbo.JOBDL020Gateways OnTrunckGateway ON OnTrunckGateway.JobId = Job.Id AND OnTrunckGateway.GwyGatewayCode = ''On Truck'' AND OnTrunckGateway.StatusId = 1
LEFT JOIN SYSTM000Ref_Options OP ON OP.Id = Cargo.CgoQtyUnitsId AND OP.SysLookupCode=''CargoUnit''
LEFT JOIN SYSTM000Ref_Options CP ON CP.Id = Cargo.CgoPackagingTypeId AND CP.SysLookupCode = ''PackagingCode'' '
SET @sqlCommand = @sqlCommand + ' Where PC.StatusId = 1 AND Prg.PrgCustId = '+ CAST(@CustomerId AS Varchar(50)) +' AND PC.[Year] = '+ CAST(@ProjectedYear AS Varchar(50)) + +' GROUP BY PC.Location,PC.ProjectedCapacity,Prg.PrgCustID' + ' ORDER BY Max(PC.Id)'
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

END
GO

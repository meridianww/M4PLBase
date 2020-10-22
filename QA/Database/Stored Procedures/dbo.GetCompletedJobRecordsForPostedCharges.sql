SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 09/22/2020
-- Description:	Get Completed Job Records For Posted Charges
-- =============================================
ALTER PROCEDURE [dbo].[GetCompletedJobRecordsForPostedCharges] (
	@userId BIGINT
	,@roleId INT
	,@orgId INT
	,@Where NVARCHAR(MAX)
	,@IsCostCharge BIT
	,@IsExport BIT = 0
	,@TotalCount INT OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsJobAdmin BIT
		,@CanceledStatus INT
		,@TablesQuery NVARCHAR(MAX)
		,@IsPriceChargeReport BIT
		,@TCountQuery NVARCHAR(MAX)

	SELECT @IsPriceChargeReport = CASE 
			WHEN ISNULL(@IsCostCharge, 0) = 0
				THEN 1
			ELSE 0
			END

	SELECT @CanceledStatus = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'Status'
		AND SysOptionName = 'Canceled'

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

	SET @TablesQuery = 
		'Select JobAdvanceReport.Id Id,
JobAdvanceReport.Id JobId,
JobAdvanceReport.JobDeliveryDateTimePlanned,
JobAdvanceReport.JobOriginDateTimePlanned,
JobAdvanceReport.JobGatewayStatus,
JobAdvanceReport.JobSiteCode,
JobAdvanceReport.JobCustomerSalesOrder,
JobAdvanceReport.PlantIDCode,
JobAdvanceReport.JobQtyActual,
JobAdvanceReport.JobPartsActual,
JobAdvanceReport.JobTotalCubes,
JobAdvanceReport.JobServiceMode,
JobAdvanceReport.JobCustomerPurchaseOrder,
JobAdvanceReport.JobCarrierContract,
JobAdvanceReport.StatusId,
JobAdvanceReport.JobDeliverySitePOC,
JobAdvanceReport.JobDeliverySitePOCPhone,
JobAdvanceReport.JobDeliverySitePOCPhone2,
JobAdvanceReport.JobDeliverySitePOCEmail,
JobAdvanceReport.JobOriginSiteName,
JobAdvanceReport.JobDeliverySiteName,
JobAdvanceReport.JobDeliveryStreetAddress,
JobAdvanceReport.JobDeliveryStreetAddress2,
JobAdvanceReport.JobDeliveryCity,
JobAdvanceReport.JobDeliveryState,
JobAdvanceReport.JobDeliveryPostalCode,
JobAdvanceReport.JobDeliveryDateTimeActual,
JobAdvanceReport.JobOriginDateTimeActual,
JobAdvanceReport.JobOrderedDate, 
CAST(0 AS BIT) IsIdentityVisible,
CAST(1 AS BIT) IsFilterSortDisable,
CAST(1 AS BIT) IsPaginationDisable,
CAST(1 AS BIT) IsChargeReport, ' 
		+ 'CAST(' + CAST(@IsCostCharge AS VARCHAR) + ' AS BIT) IsCostChargeReport, ' + 'CAST(' + CAST(@IsPriceChargeReport AS VARCHAR) + ' AS BIT) IsPriceChargeReport ' + ' From JobDL000Master JobAdvanceReport INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = JobAdvanceReport.ProgramId '
	SET @TCountQuery = 'SELECT @TotalCount = COUNT(JobAdvanceReport.Id) From JobDL000Master JobAdvanceReport INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = JobAdvanceReport.ProgramId '

	IF EXISTS (
			SELECT 1
			FROM #EntityIdTemp
			WHERE ISNULL(EntityId, 0) <> - 1
			)
	BEGIN
		SET @TablesQuery = @TablesQuery + ' INNER JOIN #EntityIdTemp Tmp on tmp.EntityId = job.Id '
		SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp Tmp on tmp.EntityId = job.Id '
	END

	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @TablesQuery = @TablesQuery + ' Where ISNULL(JobAdvanceReport.JobCompleted,0) = 1 AND JobAdvanceReport.StatusId <> ' + CAST(@CanceledStatus AS VARCHAR) + ' AND ISNULL(JobAdvanceReport.JobSiteCode,'''') <> '''' ' + @where
		SET @TCountQuery = @TCountQuery + ' Where ISNULL(JobAdvanceReport.JobCompleted,0) = 1 AND JobAdvanceReport.StatusId <> ' + CAST(@CanceledStatus AS VARCHAR) + ' AND ISNULL(JobAdvanceReport.JobSiteCode,'''') <> '''' ' + @where
	END
	ELSE
	BEGIN
		SET @TablesQuery = @TablesQuery + ' Where ISNULL(JobAdvanceReport.JobCompleted,0) = 1 AND JobAdvanceReport.StatusId <> ' + CAST(@CanceledStatus AS VARCHAR) + ' AND ISNULL(JobAdvanceReport.JobSiteCode,'''') <> '''' '
		SET @TCountQuery = @TCountQuery + ' Where ISNULL(JobAdvanceReport.JobCompleted,0) = 1 AND JobAdvanceReport.StatusId <> ' + CAST(@CanceledStatus AS VARCHAR) + ' AND ISNULL(JobAdvanceReport.JobSiteCode,'''') <> '''' '
	END

	EXEC sp_executesql @TCountQuery
		,N' @TotalCount INT OUTPUT'
		,@TotalCount OUTPUT;

	EXEC sp_executesql @TablesQuery

	DROP TABLE #EntityIdTemp
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:                    Prashant Aggarwal         
-- Create date:               10/04/2019      
-- Description:               Get Column List For Order
-- Execution:                [dbo].[GetDataForOrder] 'SalesOrder',170725
-- =============================================
CREATE PROCEDURE [dbo].[GetDataForOrder] (
	@EntityName NVARCHAR(150)
	,@JobIdList uttIDList READONLY
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#SelectQueryTemp') IS NOT NULL
	BEGIN
		DROP TABLE #SelectQueryTemp
	END

	DECLARE @JobId BIGINT
		,@JobShipmentDate DATETIME2(7)
		,@CustomerId BIGINT

	SELECT TOP 1 @JobId = Id
	FROM @JobIdList

	CREATE TABLE #SelectQueryTemp (SelectQuery NVARCHAR(Max))

	DECLARE @jobIdCollection VARCHAR(Max) = ''

	SELECT @jobIdCollection = @jobIdCollection + CAST(Id AS VARCHAR(50)) + ', '
	FROM @JobIdList

	INSERT INTO #SelectQueryTemp
	EXEC [dbo].[GetColumnListForOrder] @EntityName

	DECLARE @SelectOrderQuery NVARCHAR(Max)

	SELECT @SelectOrderQuery = SelectQuery
	FROM #SelectQueryTemp

	SELECT @JobShipmentDate = Job.JobShipmentDate, @CustomerId = Prg.PrgCustID
		FROM JOBDL000Master Job
		INNER JOIN dbo.PRGRM000Master Prg On Job.ProgramId = Prg.Id
		WHERE Job.Id = @JobId

	IF (@EntityName = 'SalesOrder')
	BEGIN
		IF (ISNULL(YEAR(@JobShipmentDate), 0) <= 2000)
		BEGIN
			UPDATE JOBDL000Master
			SET JobShipmentDate = JobOriginDateTimeActual
			WHERE Id = @JobId
		END

		SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job
               INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
               INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID 
			   INNER JOIN dbo.COMP000Master Company ON Company.CompPrimaryRecordId = Customer.Id AND Company.CompTableName = ''Customer''' + ' LEFT JOIN dbo.PRGRM051VendorLocations PV ON PV.PvlProgramId = Program.Id AND Job.JobSiteCode = PV.PvlLocationCode AND PV.StatusId = 1' + ' LEFT JOIN dbo.VEND040DCLocations DC ON DC.Id = Pv.VendDCLocationId AND DC.StatusId = 1 ' + ' Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	END

	IF (@EntityName = 'ShippingItem')
	BEGIN
	IF(ISNULL(@CustomerId,0) = 10007)
        BEGIN
        EXEC dbo.UpdatePriceCostDeliveryChargeQuantity @JobId
        END

		SET @SelectOrderQuery = 'Select BillableSheet.Id M4PLItemId, ' + @SelectOrderQuery + '  FROM [dbo].[JOBDL061BillableSheet] BillableSheet
                                             INNER JOIN dbo.JOBDL000Master Job ON Job.Id = BillableSheet.[JobID]
											 LEFT JOIN dbo.NAV000JobSalesOrderMapping JOM ON JOM.JobId = Job.Id AND ISNULL(JOM.IsElectronicInvoiced,0) = 0 
                                             LEFT JOIN dbo.NAV000JobSalesOrderMapping EJOM ON EJOM.JobId = Job.Id AND ISNULL(EJOM.IsElectronicInvoiced,0) = 1 
	Where BillableSheet.StatusId IN (1,2) AND ISNULL(BillableSheet.PrcInvoiced, 0) = 0 AND BillableSheet.JobId IN (' + SUBSTRING(@jobIdCollection, 1, LEN(@jobIdCollection) - 1) + ')'
	END

	IF (@EntityName = 'PurchaseOrder')
	BEGIN
		SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job
	INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
	INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID 
	LEFT JOIN dbo.PRGRM051VendorLocations PVC ON PVC.PvlProgramID = Program.Id AND PVC.PvlLocationCode = Job.JobSiteCode AND PVC.StatusId = 1
	LEFT JOIN dbo.VEND040DCLocations DC ON DC.Id = PVC.VendDCLocationId AND DC.StatusId = 1
	LEFT JOIN dbo.Vend000Master Vendor On Vendor.Id = PVC.PvlVendorId ' + ' Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	END

	IF (@EntityName = 'PurchaseOrderItem')
	BEGIN
	IF(ISNULL(@CustomerId,0) = 10007)
        BEGIN
        EXEC dbo.UpdatePriceCostDeliveryChargeQuantity @JobId
        END

		SET @SelectOrderQuery = 'Select CostSheet.Id M4PLItemId, ' + @SelectOrderQuery + '  FROM [dbo].[JOBDL062CostSheet] CostSheet
                                             INNER JOIN dbo.JOBDL000Master Job ON Job.Id = CostSheet.[JobID]
											 LEFT JOIN dbo.NAV000JobPurchaseOrderMapping JOM ON JOM.JobId = Job.Id AND ISNULL(JOM.IsElectronicInvoiced,0) = 0 
                                             LEFT JOIN dbo.NAV000JobPurchaseOrderMapping EJOM ON EJOM.JobId = Job.Id AND ISNULL(EJOM.IsElectronicInvoiced,0) = 1 
	Where CostSheet.StatusId IN (1,2) AND ISNULL(CostSheet.CstInvoiced, 0) = 0 AND CostSheet.JobId IN (' + SUBSTRING(@jobIdCollection, 1, LEN(@jobIdCollection) - 1) + ')'
	END

	EXEC (@SelectOrderQuery)

	DROP TABLE #SelectQueryTemp
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:                    Prashant Aggarwal         
-- Create date:               10/04/2019      
-- Description:               Get Column List For Order
-- Execution:                [dbo].[GetDataForOrder] 'ShippingItem',1259
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
	DECLARE @RateTypeId BIGINT, @JobId BIGINT
	Select TOP 1 @JobId = Id From @JobIdList
   SELECT @RateTypeId = [Id] FROM [dbo].[SYSTM000Ref_Options]
   Where [SysLookupCode] = 'RateType' AND SysOptionName = 'Expression(Delivery)'
	CREATE TABLE #SelectQueryTemp (SelectQuery NVARCHAR(Max))

	declare @jobIdCollection varchar(Max) = ''

select @jobIdCollection = @jobIdCollection + CAST(Id AS Varchar(50)) + ', ' from @JobIdList

	INSERT INTO #SelectQueryTemp
	EXEC [dbo].[GetColumnListForOrder] @EntityName

	DECLARE @SelectOrderQuery NVARCHAR(Max)
	SELECT @SelectOrderQuery = SelectQuery
	FROM #SelectQueryTemp
	IF(@EntityName = 'SalesOrder')
	BEGIN
	SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job
               INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
               INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID 
			   INNER JOIN dbo.COMP000Master Company ON Company.CompPrimaryRecordId = Customer.Id AND Company.CompTableName = ''Customer'''+
              ' Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	END
	IF(@EntityName = 'ShippingItem')
	BEGIN
	SET @SelectOrderQuery = 'Select BillableSheet.Id M4PLItemId, ' + @SelectOrderQuery + '  FROM [dbo].[JOBDL061BillableSheet] BillableSheet
                                             INNER JOIN dbo.JOBDL000Master Job ON Job.Id = BillableSheet.[JobID]
											 LEFT JOIN dbo.NAV000JobSalesOrderMapping JOM ON JOM.JobId = Job.Id AND ISNULL(JOM.IsElectronicInvoiced,0) = 0 
                                             LEFT JOIN dbo.NAV000JobSalesOrderMapping EJOM ON EJOM.JobId = Job.Id AND ISNULL(EJOM.IsElectronicInvoiced,0) = 1 
	Where BillableSheet.StatusId IN (1,2) AND BillableSheet.JobId IN ('+ SUBSTRING(@jobIdCollection, 1, LEN(@jobIdCollection)-1) +')'
	SET @SelectOrderQuery = REPLACE(@SelectOrderQuery, '@RateTypeId', @RateTypeId)
	END

	IF(@EntityName = 'PurchaseOrder')
	BEGIN
	SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job
	INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
	INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID 
	LEFT JOIN dbo.PRGRM051VendorLocations PVC ON PVC.PvlProgramID = Program.Id AND PVC.PvlLocationCode = Job.JobSiteCode AND PVC.StatusId = 1
	LEFT JOIN dbo.Vend000Master Vendor On Vendor.Id = PVC.PvlVendorId'+
	' Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	END

	IF(@EntityName = 'PurchaseOrderItem')
	BEGIN
	SET @SelectOrderQuery = 'Select CostSheet.Id M4PLItemId, ' + @SelectOrderQuery + '  FROM [dbo].[JOBDL062CostSheet] CostSheet
                                             INNER JOIN dbo.JOBDL000Master Job ON Job.Id = CostSheet.[JobID]
											 LEFT JOIN dbo.NAV000JobSalesOrderMapping SJOM ON SJOM.JobId = Job.Id AND ISNULL(SJOM.IsElectronicInvoiced,0) = 0 
                                             LEFT JOIN dbo.NAV000JobSalesOrderMapping SEJOM ON SEJOM.JobId = Job.Id AND ISNULL(SEJOM.IsElectronicInvoiced,0) = 1 
											LEFT JOIN dbo.NAV000JobPurchaseOrderMapping JOM ON JOM.JobSalesOrderMappingId = SJOM.JobSalesOrderMappingId AND ISNULL(JOM.IsElectronicInvoiced,0) = 0 
                                             LEFT JOIN dbo.NAV000JobPurchaseOrderMapping EJOM ON EJOM.JobSalesOrderMappingId = SEJOM.JobSalesOrderMappingId AND ISNULL(EJOM.IsElectronicInvoiced,0) = 1 
	Where CostSheet.StatusId IN (1,2) AND CostSheet.JobId IN ('+ SUBSTRING(@jobIdCollection, 1, LEN(@jobIdCollection)-1) +')'
	SET @SelectOrderQuery = REPLACE(@SelectOrderQuery, '@RateTypeId', @RateTypeId)
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

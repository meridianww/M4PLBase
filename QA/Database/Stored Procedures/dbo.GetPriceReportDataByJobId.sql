SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 06/09/2020
-- Description: GetPriceReportDataByJobId 127481,1
-- =============================================
CREATE PROCEDURE [dbo].[GetPriceReportDataByJobId] (
	@jobId BIGINT
	,@customerId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CargoServiceId BIGINT

	SELECT @CargoServiceId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'PackagingCode'
		AND SysOptionName = 'Service'

	SELECT Job.Id JobId
		,JobDeliveryDateTimePlanned DeliveryDateTimePlanned
		,JobOriginDateTimePlanned OriginDateTimePlanned
		,JobGatewayStatus GatewayStatus
		,JobSiteCode VendorLocation
		,JobCustomerSalesOrder ContractNumber
		,PlantIDCode PlantCode
		,JobQtyActual QuantityActual
		,JobPartsActual PartActual
		,JobTotalCubes Cubes
		,BS.PrcChargeCode ChargeCode
		,CASE 
			WHEN ISNULL(Cargo.CgoTitle, '') <> ''
				THEN Cargo.CgoTitle
			ELSE BS.PrcTitle
			END ChargeTitle
		,BS.PrcRate Rate
		,Job.JobServiceMode ServiceMode
		,Job.JobCustomerPurchaseOrder CustomerPurchaseOrder
		,Job.JobCarrierContract Brand
		,OP.SysOptionName StatusName
		,Job.JobDeliverySitePOC DeliverySitePOC
		,Job.JobDeliverySitePOCPhone DeliverySitePOCPhone
		,Job.JobDeliverySitePOC2 DeliverySitePOC2
		,Job.JobDeliverySitePOCPhone2 DeliverySitePOCPhone2
		,Job.JobDeliverySitePOCEmail DeliverySitePOCEmail
		,Job.JobOriginSiteName OriginSiteName
		,Job.JobDeliverySiteName DeliverySiteName
		,Job.JobDeliveryStreetAddress DeliveryStreetAddress
		,Job.JobDeliveryStreetAddress2 DeliveryStreetAddress2
		,Job.JobDeliveryCity DeliveryCity
		,Job.JobDeliveryState DeliveryState
		,Job.JobDeliveryPostalCode DeliveryPostalCode
		,Job.JobDeliveryDateTimeActual DeliveryDateTimeActual
		,Job.JobOriginDateTimeActual OriginDateTimeActual
		,Job.JobOrderedDate OrderedDate
	FROM JobDL000Master Job
	LEFT JOIN dbo.JOBDL061BillableSheet BS ON BS.JobId = Job.Id
	LEFT JOIN dbo.PRGRM040ProgramBillableRate PB ON PB.Id = BS.PrcChargeId
	LEFT JOIN dbo.JOBDL010Cargo Cargo ON Cargo.CgoPartNumCode = PB.PbrCustomerCode
		AND Cargo.JobId = @jobId
		AND CgoPackagingTypeId = @CargoServiceId
		AND Cargo.StatusId = 1
	LEFT JOIN dbo.SYSTM000Ref_Options OP ON OP.Id = BS.StatusId
		AND OP.SysLookupCode = 'Status'
	WHERE Job.Id = @jobId AND BS.StatusId=1
END
GO


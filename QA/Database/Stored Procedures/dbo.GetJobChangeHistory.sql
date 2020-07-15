SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 07/15/2020
-- Description:	Get Job Change History Data
-- =============================================
CREATE PROCEDURE [dbo].[GetJobChangeHistory] (@JobId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT JobSiteCode
		,JobCustomerSalesOrder
		,JobBOL
		,JobBOLMaster
		,JobCustomerPurchaseOrder
		,JobCarrierContract
		,JobManifestNo
		,JobQtyOrdered
		,JobQtyActual
		,JobPartsOrdered
		,JobPartsActual
		,StatusId
		,JobType
		,ShipmentType
		,PlantIDCode
		,WindowDelStartTime
		,WindowDelEndTime
		,JobDeliverySitePOCPhone
		,JobDeliverySitePOCEmail
		,JobDeliverySiteName
		,JobDeliveryStreetAddress
		,JobDeliveryStreetAddress2
		,JobDeliveryCity
		,JobDeliveryState
		,JobDeliveryPostalCode
		,JobDeliveryDateTimePlanned
		,JobLatitude
		,JobLongitude
		,JobOriginSiteCode
		,JobOriginSitePOC
		,JobOriginSitePOCPhone
		,JobOriginSitePOCEmail
		,JobOriginSiteName
		,JobOriginStreetAddress
		,JobOriginStreetAddress2
		,JobOriginCity
		,JobOriginState
		,JobOriginPostalCode
		,JobOriginDateTimePlanned
		,JobDeliverySitePOC2
		,JobDeliverySitePOCPhone2
		,JobDeliverySitePOCEmail2
		,JobOriginSitePOC2
		,JobOriginSitePOCPhone2
		,JobOriginSitePOCEmail2
		,JobMileage
		,JobServiceOrder
		,JobServiceActual
		,JobDriverAlert
		,EnteredBy
		,ChangedBy
		,DateChanged
		,DateEntered
	FROM cdc.dbo_JobDL000Master_CT
	WHERE Id = @JobId
		AND __$operation IN (3, 4)
END
GO


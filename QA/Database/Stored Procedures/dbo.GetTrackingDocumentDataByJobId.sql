SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 06/09/2020
-- Description:	GetTrackingDocumentDataByJobId 127481
-- =============================================
ALTER PROCEDURE [dbo].[GetTrackingDocumentDataByJobId] (@jobId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT JobBOL BOLNumber
	    ,Vendor.VendTitle VendorName
		,JobSiteCode VendorLocation
		,JobCustomerSalesOrder ContractNumber
		,JobManifestNo ManifestNo
		,PlantIDCode PlantCode
		,CarrierID TrailerNo
		,FORMAT (JobOrderedDate, 'dd/MM/yyyy, hh:mm:ss ')  OrderedDate
		,FORMAT (JobShipmentDate, 'dd/MM/yyyy, hh:mm:ss ')  ShipmentDate
		,FORMAT (JobOriginDateTimePlanned, 'dd/MM/yyyy, hh:mm:ss ')  ArrivalPlannedDate
		,FORMAT (JobDeliveryDateTimePlanned, 'dd/MM/yyyy, hh:mm:ss ')  DeliveryPlannedDate
		,JobOriginSiteName OriginSiteName
		,JobOriginStreetAddress OriginAddress
		,JobOriginStreetAddress2 OriginAddress1
		,JobOriginStreetAddress3 OriginAddress2
		,JobOriginStreetAddress4 OriginAddress3
		,JobOriginCity OriginCity
		,JobOriginState OriginStateCode
		,JobOriginPostalCode OriginPostalCode
		,JobOriginCountry OriginCountry
		,JobOriginSitePOC OriginContactName
		,JobOriginSitePOCPhone OriginPhoneNumber
		,JobOriginSitePOCEmail OriginEmail
		,'12:00-09:00' OriginWindow
		,JobOriginTimeZone OriginTimeZone
		,JobDeliverySiteName DestinationSiteName
		,JobDeliveryStreetAddress DestinationAddress
		,JobDeliveryStreetAddress2 DestinationAddress1
		,JobDeliveryStreetAddress3 DestinationAddress2
		,JobDeliveryStreetAddress4 DestinationAddress3
		,JobDeliveryCity DestinationCity
		,JobDeliveryState DestinationStateCode
		,JobDeliveryPostalCode DestinationPostalCode
		,JobDeliveryCountry DestinationCountry
		,JobDeliverySitePOC DestinationContactName
		,JobDeliverySitePOCPhone DestinationPhoneNumber
		,JobDeliverySitePOCEmail DestinationEmail
		,'12:00-09:00' DestinationWindow
		,JobDeliveryTimeZone DestinationTimeZone
		,JobType OrderType
		,JobTotalWeight TotalWeight
		,ShipmentType ShipmentType
		,JobTotalCubes TotalCube
		,JobDriverAlert DriverAlert
	FROM JobDL000Master Job
	LEFT JOIN dbo.PRGRM051VendorLocations PVC ON PVC.PvlProgramID = Job.ProgramId AND PVC.PvlLocationCode = Job.JobSiteCode AND PVC.StatusId = 1
	LEFT JOIN dbo.Vend000Master Vendor On Vendor.Id = PVC.PvlVendorId
	WHERE Job.Id = @jobId

	SELECT CgoLineItem ItemNo
		,CgoPartNumCode PartCode
		,CgoSerialNumber SerialNumber
		,CgoTitle Title
		,OP.SysOptionName PackagingType
		,OU.SysOptionName QuantityUnit
		,CgoWeight [Weight]
		,CgoCubes Cubes
	FROM JOBDL010Cargo Cargo
	LEFT JOIN dbo.SYSTM000Ref_Options OP ON OP.Id = Cargo.CgoPackagingTypeId
		AND OP.SysLookupCode = 'PackagingCode'
	LEFT JOIN dbo.SYSTM000Ref_Options OU ON OU.Id = Cargo.CgoQtyUnitsId
		AND OU.SysLookupCode = 'CargoUnit'
	WHERE Cargo.StatusId = 1
		AND Cargo.JObId = @jobId
    Order By CgoLineItem ASC

	SELECT GwyGatewaySortOrder ItemNumber
	,GwyGatewayACD GatewayACD
	,GwyDDPCurrent ScheduledDate
	,GwyGatewayCode GatewayCode
	,GwyGatewayTitle GatewayTitle
	,OU.SysOptionName GatewayType
FROM dbo.JOBDL020Gateways Gateway
LEFT JOIN dbo.SYSTM000Ref_Options OU ON OU.Id = Gateway.GatewayTypeId
	AND OU.SysLookupCode = 'GatewayType'
WHERE JobId = @jobId
Order By GwyGatewaySortOrder ASC
END

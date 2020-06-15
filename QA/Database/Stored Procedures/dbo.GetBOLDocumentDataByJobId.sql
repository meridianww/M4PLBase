SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 06/09/2020
-- Description:	GetBOLDocumentDataByJobId 127496
-- =============================================
ALTER PROCEDURE [dbo].[GetBOLDocumentDataByJobId] (@jobId BIGINT)
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
		,FORMAT (JobOrderedDate, 'MM/dd/yyyy hh:mm tt ')  OrderedDate
		,FORMAT (JobShipmentDate, 'MM/dd/yyyy hh:mm tt ')  ShipmentDate
		,FORMAT (JobOriginDateTimePlanned, 'MM/dd/yyyy hh:mm tt ')  ArrivalPlannedDate
		,FORMAT (JobDeliveryDateTimePlanned, 'MM/dd/yyyy hh:mm tt ')  DeliveryPlannedDate
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
		,CASE WHEN (ISNULL(WindowPckStartTime, '') <> '' AND ISNULL(WindowPckStartTime, '') <> '') 
		THEN CONCAT(FORMAT(WindowPckStartTime, 'hh:mm tt '),'- ',FORMAT(WindowPckEndTime, 'hh:mm tt '))
		ELSE '' END OriginWindow
		,JobOriginTimeZone OriginTimeZone
		,JobDeliverySiteName DestinationSiteName
		,JobDeliveryStreetAddress DestinationAddress
		,JobDeliveryStreetAddress2 DestinationAddress1
		,JobDeliveryStreetAddress3 DestinationAddress2
		,JobDeliveryStreetAddress4 DestinationAddress3
		,ISNULL(JobDeliveryCity,'') DestinationCity
		,JobDeliveryState DestinationStateCode
		,JobDeliveryPostalCode DestinationPostalCode
		,JobDeliveryCountry DestinationCountry
		,JobDeliverySitePOC DestinationContactName
		,JobDeliverySitePOCPhone DestinationPhoneNumber
		,JobDeliverySitePOCEmail DestinationEmail
		,CASE WHEN (ISNULL(WindowDelStartTime, '') <> '' AND ISNULL(WindowDelEndTime, '') <> '') 
	 	       THEN CONCAT(FORMAT(WindowDelStartTime, 'hh:mm tt '),'- ',FORMAT(WindowDelEndTime, 'hh:mm tt ')) 
		ELSE '' END DestinationWindow
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
	LEFT JOIN dbo.SYSTM000Ref_Options OU ON OP.Id = Cargo.CgoQtyUnitsId
		AND OU.SysLookupCode = 'CargoUnit'
	WHERE Cargo.StatusId = 1
		AND Cargo.JObId = @jobId
		Order BY CgoLineItem ASC
END

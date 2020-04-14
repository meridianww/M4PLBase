SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Prashant Aggarwal          
-- Create date:               04/14/2020        
-- Description:               Get a Job data by Sales Order Number   
-- =============================================        
CREATE PROCEDURE [dbo].[GetJobByCustomerSalesOrder] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@JobCustomerSalesOrder VARCHAR(30)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @id BIGINT
		,@parentId BIGINT

	SELECT @Id = Id
		,@parentId = ProgramId
	FROM [JOBDL000Master]
	WHERE JobCustomerSalesOrder = @JobCustomerSalesOrder

	IF OBJECT_ID('tempdb..#ActualCargoPartCount') IS NOT NULL
	BEGIN
		DROP TABLE #ActualCargoPartCount
	END

	IF OBJECT_ID('tempdb..#ActualCargoQuantityCount') IS NOT NULL
	BEGIN
		DROP TABLE #ActualCargoQuantityCount
	END

	SELECT JobId
		,Count(JobId) CargoCount
	INTO #ActualCargoItemCount
	FROM [dbo].[JOBDL010Cargo]
	WHERE StatusId IN (
			1
			,2
			)
		AND ISNULL(CgoQtyUnits, '') <> ''
		AND CgoQtyUnits NOT IN (
			'Cabinets'
			,'Pallets'
			)
	GROUP BY JobId

	SELECT JobId
		,Count(JobId) CargoCount
	INTO #ActualCargoQuantityCount
	FROM [dbo].[JOBDL010Cargo]
	WHERE StatusId IN (
			1
			,2
			)
		AND ISNULL(CgoQtyUnits, '') <> ''
		AND CgoQtyUnits IN (
			'Cabinets'
			,'Pallets'
			)
	GROUP BY JobId

	IF @id = 0
	BEGIN
		DECLARE @pickupTime TIME
			,@deliveryTime TIME
			,@programCode NVARCHAR(50)
			,@JobElectronicInvoice BIT

		SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			,@deliveryTime = CAST(PrgDeliveryTimeDefault AS TIME)
			,@JobElectronicInvoice = PrgElectronicInvoice
			,@programCode = CASE 
				WHEN PrgHierarchyLevel = 1
					THEN [PrgProgramCode]
				WHEN PrgHierarchyLevel = 2
					THEN [PrgProjectCode]
				WHEN PrgHierarchyLevel = 3
					THEN PrgPhaseCode
				ELSE [PrgProgramTitle]
				END
		FROM PRGRM000MASTER
		WHERE Id = @parentId;

		SELECT @parentId AS ProgramID
			,@programCode AS ProgramIDName
			,NULL --CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@deliveryTime AS DATETIME) AS JobDeliveryDateTimePlanned
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@deliveryTime AS DATETIME) AS JobDeliveryDateTimeActual
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@deliveryTime AS DATETIME) AS JobDeliveryDateTimeBaseline
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimePlanned
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeActual
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeBaseline
			,@JobElectronicInvoice JobElectronicInvoice
	END
	ELSE
	BEGIN
		SELECT job.[Id]
			,job.[JobMITJobID]
			,job.[ProgramID]
			,CASE 
				WHEN prg.PrgHierarchyLevel = 1
					THEN prg.[PrgProgramCode]
				WHEN prg.PrgHierarchyLevel = 2
					THEN prg.[PrgProjectCode]
				WHEN prg.PrgHierarchyLevel = 3
					THEN prg.PrgPhaseCode
				ELSE prg.[PrgProgramTitle]
				END AS ProgramIDName
			,job.[JobSiteCode]
			,job.[JobConsigneeCode]
			,job.[JobCustomerSalesOrder]
			,job.[JobBOL]
			,job.[JobBOLMaster]
			,job.[JobBOLChild]
			,job.[JobCustomerPurchaseOrder]
			,job.[JobCarrierContract]
			,job.[JobManifestNo]
			,job.[JobGatewayStatus]
			,job.[StatusId]
			,job.[JobStatusedDate]
			,job.[JobCompleted]
			,job.[JobType]
			,job.[ShipmentType]
			,job.[JobDeliveryAnalystContactID]
			,job.[JobDeliveryResponsibleContactID]
			,job.[JobDeliverySitePOC]
			,job.[JobDeliverySitePOCPhone]
			,job.[JobDeliverySitePOCEmail]
			,job.[JobDeliverySiteName]
			,job.[JobDeliveryStreetAddress]
			,job.[JobDeliveryStreetAddress2]
			,job.[JobDeliveryCity]
			,job.[JobDeliveryState]
			,job.[JobDeliveryPostalCode]
			,job.[JobDeliveryCountry]
			,job.[JobDeliveryTimeZone]
			,job.[JobDeliveryDateTimePlanned]
			,job.[JobDeliveryDateTimeActual]
			,job.[JobDeliveryDateTimeBaseline]
			,job.[JobDeliveryRecipientPhone]
			,job.[JobDeliveryRecipientEmail]
			,job.[JobLatitude]
			,job.[JobLongitude]
			,job.[JobOriginResponsibleContactID]
			,job.[JobOriginSitePOC]
			,job.[JobOriginSitePOCPhone]
			,job.[JobOriginSitePOCEmail]
			,job.[JobOriginSiteName]
			,job.[JobOriginStreetAddress]
			,job.[JobOriginStreetAddress2]
			,job.[JobOriginCity]
			,job.[JobOriginState]
			,job.[JobOriginPostalCode]
			,job.[JobOriginCountry]
			,job.[JobOriginTimeZone]
			,job.[JobOriginDateTimePlanned]
			,job.[JobOriginDateTimeActual]
			,job.[JobOriginDateTimeBaseline]
			,job.[JobProcessingFlags]
			,job.[JobDeliverySitePOC2]
			,job.[JobDeliverySitePOCPhone2]
			,job.[JobDeliverySitePOCEmail2]
			,job.[JobOriginSitePOC2]
			,job.[JobOriginSitePOCPhone2]
			,job.[JobOriginSitePOCEmail2]
			,job.JobSellerCode
			,job.JobSellerSitePOC
			,job.JobSellerSitePOCPhone
			,job.JobSellerSitePOCEmail
			,job.JobSellerSitePOC2
			,job.JobSellerSitePOCPhone2
			,job.JobSellerSitePOCEmail2
			,job.JobSellerSiteName
			,job.JobSellerStreetAddress
			,job.JobSellerStreetAddress2
			,job.JobSellerCity
			,job.JobSellerState
			,job.JobSellerPostalCode
			,job.JobSellerCountry
			,job.[JobUser01]
			,job.[JobUser02]
			,job.[JobUser03]
			,job.[JobUser04]
			,job.[JobUser05]
			,job.[JobStatusFlags]
			,job.[JobScannerFlags]
			,job.[PlantIDCode]
			,job.[CarrierID]
			,job.[JobDriverId]
			,job.[WindowDelStartTime]
			,job.[WindowDelEndTime]
			,job.[WindowPckStartTime]
			,job.[WindowPckEndTime]
			,job.[JobRouteId]
			,job.[JobStop]
			,job.[JobSignText]
			,job.[JobSignLatitude]
			,job.[JobSignLongitude]
			,Job.JobQtyOrdered
			,CASE 
				WHEN ISNULL(Job.JobQtyActual, 0) > 0
					THEN CAST(Job.JobQtyActual AS INT)
				WHEN ISNULL(CC1.CargoCount, 0) > 0
					THEN CAST(CC1.CargoCount AS INT)
				ELSE NULL
				END JobQtyActual
			,Job.JobQtyUnitTypeId
			,CAST(Job.JobPartsOrdered AS INT) JobPartsOrdered
			,CASE 
				WHEN ISNULL(Job.JobPartsActual, 0) > 0
					THEN CAST(Job.JobPartsActual AS INT)
				WHEN ISNULL(CC.CargoCount, 0) > 0
					THEN CAST(CC.CargoCount AS INT)
				ELSE NULL
				END JobPartsActual
			,Job.JobTotalCubes
			,Job.JobServiceMode
			,Job.JobChannel
			,Job.JobProductType
			,JOM.SONumber JobSONumber
			,JPM.PONumber JobPONumber
			,EJOM.SONumber JobElectronicInvoiceSONumber
			,EJPM.PONumber JobElectronicInvoicePONumber
			,job.[EnteredBy]
			,job.[DateEntered]
			,job.[ChangedBy]
			,job.[DateChanged]
			,prg.PckEarliest
			,prg.PckLatest
			,prg.PckDay
			,prg.DelEarliest
			,prg.DelLatest
			,prg.DelDay
			,prg.PrgPickUpTimeDefault
			,prg.PrgDeliveryTimeDefault
			,Job.JobOrderedDate
			,Job.JobShipmentDate
			,Job.JobInvoicedDate
			,Job.JobShipFromSiteName
			,Job.JobShipFromStreetAddress
			,Job.JobShipFromStreetAddress2
			,Job.JobShipFromCity
			,Job.JobShipFromState
			,Job.JobShipFromPostalCode
			,Job.JobShipFromCountry
			,Job.JobShipFromSitePOC
			,Job.JobShipFromSitePOCPhone
			,Job.JobShipFromSitePOCEmail
			,Job.JobShipFromSitePOC2
			,Job.JobShipFromSitePOCPhone2
			,Job.JobShipFromSitePOCEmail2
			,CAST(ISNULL(Customer.CustERPID, 0) AS BIGINT) CustomerERPId
			,CAST(ISNULL(Vendor.VendERPID, 0) AS BIGINT) VendorERPId
			,Job.JobElectronicInvoice
			,Job.JobOriginStreetAddress3
			,Job.JobOriginStreetAddress4
			,Job.JobDeliveryStreetAddress3
			,Job.JobDeliveryStreetAddress4
			,Job.JobSellerStreetAddress3
			,Job.JobSellerStreetAddress4
			,Job.JobShipFromStreetAddress3
			,Job.JobShipFromStreetAddress4
			,Job.JobCubesUnitTypeId
			,Job.JobTotalWeight
			,Job.JobWeightUnitTypeId
			,job.JobMileage
		FROM [dbo].[JOBDL000Master] job
		INNER JOIN PRGRM000MASTER prg ON job.ProgramID = prg.Id
		INNER JOIN dbo.CUST000Master Customer ON Customer.Id = prg.PrgCustID
		LEFT JOIN dbo.PRGRM051VendorLocations PVC ON PVC.PvlProgramID = prg.Id
			AND ISNULL(PVC.PvlLocationCode, '') = ISNULL(Job.JobSiteCode, '')
			AND PVC.StatusId = 1
		LEFT JOIN dbo.Vend000Master Vendor ON Vendor.Id = PVC.PvlVendorId
		LEFT JOIN dbo.NAV000JobSalesOrderMapping JOM ON JOM.JobId = Job.Id
			AND ISNULL(JOM.IsElectronicInvoiced, 0) = 0
		LEFT JOIN dbo.NAV000JobPurchaseOrderMapping JPM ON JPM.JobSalesOrderMappingId = JOM.JobSalesOrderMappingId
			AND ISNULL(JPM.IsElectronicInvoiced, 0) = 0
		LEFT JOIN dbo.NAV000JobSalesOrderMapping EJOM ON EJOM.JobId = Job.Id
			AND ISNULL(EJOM.IsElectronicInvoiced, 0) = 1
		LEFT JOIN dbo.NAV000JobPurchaseOrderMapping EJPM ON EJPM.JobSalesOrderMappingId = EJOM.JobSalesOrderMappingId
			AND ISNULL(EJPM.IsElectronicInvoiced, 0) = 1
		LEFT JOIN #ActualCargoItemCount CC ON Job.Id = CC.JobId
		LEFT JOIN #ActualCargoQuantityCount CC1 ON Job.Id = CC1.JobId
		WHERE job.[Id] = @id
	END

	DROP TABLE #ActualCargoItemCount

	DROP TABLE #ActualCargoQuantityCount
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


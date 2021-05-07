
/* Copyright (2021) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Nathan Fujimoto         
-- Create date:               5/6/2021        
-- Description:               Get a Job data by BOLMaster 
-- Execution                  EXEC [dbo].[GetJobByBOLMaster] 2,14,1,'7400230134',20047 
-- =============================================        
CREATE PROCEDURE [dbo].[GetJobByBOLMaster] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@JobBOLMasterNumber VARCHAR(30)
	,@customerId BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @id BIGINT
		,@parentId BIGINT
		,@ExceptionStatusId BIGINT
		,@JobIsInvoiced BIT = 0
		,@InstallStatus VARCHAR(200)
		,@ExceptionTitleId BIGINT
		,@GatewayCode VARCHAR(200)
		,@ActionType INT
		,@JobCustomerSalesOrder VARCHAR(30)
		--,@IsxCBLRecieved BIT = 0

	SELECT TOP 1 @Id = Job.Id
		,@parentId = Job.ProgramId
		,@JobCustomerSalesOrder = JobCustomerSalesOrder
		,@JobIsInvoiced = CASE 
			WHEN ISNULL(JobInvoicedDate, '') <> ''
				THEN 1
			ELSE 0
			END
	FROM [JOBDL000Master] Job
	INNER JOIN PRGRM000MASTER prg ON job.ProgramID = prg.Id
	WHERE Job.JobBOLMaster = @JobBOLMasterNumber AND Prg.PrgCustId = @customerId
		AND Job.StatusId = 1

	SELECT TOP 1 @ExceptionStatusId = JG.GwyExceptionStatusId
		,@ExceptionTitleId = JG.GwyExceptionTitleId
		,@GatewayCode = CASE 
			WHEN ISNULL(JG.StatusCode, '') <> ''
				AND JG.GwyGatewayCode <> JG.StatusCode
				THEN CONCAT (
						JG.GwyGatewayCode
						,'-'
						,ISNULL(JG.StatusCode, '')
						)
			ELSE JG.GwyGatewayCode
			END
	FROM [dbo].[JOBDL020Gateways] JG WITH (NOLOCK)
	INNER JOIN [dbo].[SYSTM000Ref_Options] SO WITH (NOLOCK) ON SO.Id = JG.GatewayTypeId
	WHERE JobId = @Id
		AND ISNULL(GwyCargoId, 0) = 0
	ORDER BY JG.ID DESC

	IF (ISNULL(@JobIsInvoiced, 0) = 1)
	BEGIN
		SELECT @InstallStatus = ExStatusDescription
		FROM [dbo].[JOBDL023GatewayInstallStatusMaster]
		WHERE ExStatusDescription = 'Invoiced'
	END
	ELSE
	BEGIN
		SELECT @InstallStatus = ExStatusDescription
		FROM [dbo].[JOBDL023GatewayInstallStatusMaster]
		WHERE Id = @ExceptionStatusId
	END

	SELECT @ActionType = ISNULL(ActionType, 0)
	FROM [dbo].[JOBDL022GatewayExceptionReason] GER
	INNER JOIN [dbo].[JOBDL021GatewayExceptionCode] GEO ON GER.JGExceptionId = GEO.ID
	WHERE GER.Id = @ExceptionTitleId

	IF (
			ISNULL(@ActionType, 0) = 0
			AND ISNULL(@JobIsInvoiced, 0) = 0
			)
	BEGIN
		SELECT @InstallStatus = ExStatusDescription
		FROM PRGRM010Ref_GatewayDefaults GP
		INNER JOIN [dbo].[JOBDL023GatewayInstallStatusMaster] GIS ON GIS.Id = GP.InstallStatusId
		WHERE GP.PgdProgramId = @parentId
			AND PgdGatewayCode = @GatewayCode
	END

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
				ELSE NULL
				END JobQtyActual
			,Job.JobQtyUnitTypeId
			,CAST(Job.JobPartsOrdered AS INT) JobPartsOrdered
			,CAST(Job.JobPartsActual AS INT) JobPartsActual
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
			,Customer.CustERPID CustomerERPId
			,Vendor.VendERPID VendorERPId
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
			,job.JobServiceOrder
			,job.JobServiceActual
			,Customer.Id AS CustomerId
			,CASE 
				WHEN ISNULL(@InstallStatus, '') <> ''
					THEN @InstallStatus
				ELSE JobGatewayStatus
				END InstallStatus
			,Job.IsCancelled
			--,@IsxCBLRecieved IsxCBLRecieved
			,Job.JobIsSchedule
			,CASE WHEN ISNULL(JOM.IsParentOrder, 0) = 0 THEN EJOM.IsParentOrder ELSE JOM.IsParentOrder END IsParentOrder
		FROM [dbo].[JOBDL000Master] job
		INNER JOIN PRGRM000MASTER prg ON job.ProgramID = prg.Id
		INNER JOIN dbo.CUST000Master Customer ON Customer.Id = prg.PrgCustID
		LEFT JOIN dbo.PRGRM051VendorLocations PVC ON PVC.PvlProgramID = prg.Id
			AND ISNULL(PVC.PvlLocationCode, '') = ISNULL(Job.JobSiteCode, '')
			AND PVC.StatusId = 1
		LEFT JOIN dbo.Vend000Master Vendor ON Vendor.Id = PVC.PvlVendorId
		LEFT JOIN dbo.NAV000JobSalesOrderMapping JOM ON JOM.JobId = Job.Id
			AND ISNULL(JOM.IsElectronicInvoiced, 0) = 0
		LEFT JOIN dbo.NAV000JobPurchaseOrderMapping JPM ON JPM.JobId = Job.Id
			AND ISNULL(JPM.IsElectronicInvoiced, 0) = 0
		LEFT JOIN dbo.NAV000JobSalesOrderMapping EJOM ON EJOM.JobId = Job.Id
			AND ISNULL(EJOM.IsElectronicInvoiced, 0) = 1
		LEFT JOIN dbo.NAV000JobPurchaseOrderMapping EJPM ON EJPM.JobId = Job.Id
			AND ISNULL(EJPM.IsElectronicInvoiced, 0) = 1
		WHERE job.[Id] = @id
			AND job.StatusId = 1
	END
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

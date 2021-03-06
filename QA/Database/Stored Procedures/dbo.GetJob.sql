SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job   
-- Execution:                 EXEC [dbo].[GetJob]     
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================        
ALTER PROCEDURE [dbo].[GetJob]-- 1,14,1,1283,
     @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
	,@parentId BIGINT = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;
	IF(ISNULL(@id, 0) > 0)
	BEGIN
	Select @parentId = ProgramId From  [JOBDL000Master] Where ID = @id
	END

	IF @id = 0
	BEGIN
		DECLARE @pickupTime TIME
			,@deliveryTime TIME
			,@programCode NVARCHAR(50)
			,@JobElectronicInvoice BIT
			,@CustomerID BIGINT

		SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			,@deliveryTime = CAST(PrgDeliveryTimeDefault AS TIME)
			,@JobElectronicInvoice = PrgElectronicInvoice
			,@CustomerID = PrgCustId
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
			--,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimePlanned
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeActual
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeBaseline
			,@JobElectronicInvoice JobElectronicInvoice
			,@CustomerID CustomerId
	END
	ELSE
	BEGIN
	  
		SELECT job.[Id]
			,job.[JobMITJobID]
			,job.[ProgramID]
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
			,Job.JobQtyActual
			,Job.JobQtyUnitTypeId
			,Job.JobPartsOrdered
			,Job.JobPartsActual
			,Job.JobTotalCubes
			,Job.JobServiceMode
			,Job.JobChannel
			,Job.JobProductType
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
			,job.IsJobVocSurvey
			,job.JobTransitionStatusId
			,job.JobDriverAlert
			,job.JobSalesInvoiceNumber
			,job.JobPurchaseInvoiceNumber
			,prg.PrgCustId CustomerId
			,sysOpt.SysOptionName StatusIdName
			,job.IsCancelled
			,job.JobIsSchedule
			,job.JobDeliveryCommentText
		FROM [dbo].[JOBDL000Master] job
		INNER JOIN PRGRM000MASTER prg ON job.ProgramID = prg.Id
		LEFT JOIN SYSTM000Ref_Options sysOpt ON sysOpt.Id = job.StatusId
		WHERE job.[Id] = @id
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

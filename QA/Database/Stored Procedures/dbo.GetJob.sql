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
ALTER PROCEDURE [dbo].[GetJob] --1,14,1,1283,0
     @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
	,@parentId BIGINT = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @JobIsHavingPermission BIT = 1;
	DECLARE @JobDeliveryAnalystContactIDName NVARCHAR(100),
			@JobDeliveryResponsibleContactIDName NVARCHAR(100),
			@JobQtyUnitTypeIdName NVARCHAR(50),
			@JobCubesUnitTypeIdName NVARCHAR(50),
			@JobWeightUnitTypeIdName NVARCHAR(50),
			@JobOriginResponsibleContactIDName NVARCHAR(50),
			@JobDriverIdName NVARCHAR(100)

	IF(ISNULL(@id, 0) > 0)
	BEGIN
	Select @parentId = ProgramId From  [JOBDL000Master] Where ID = @id
	----------Security Check Start----------
	DECLARE @JobCount BIGINT, @IsJobAdmin BIT = 0
	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityIdTemp
	END
	CREATE TABLE #EntityIdTemp (EntityId BIGINT)
	INSERT INTO #EntityIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'JOB'
	
	SELECT @JobCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdTemp
	WHERE ISNULL(EntityId, 0) = - 1
	
	IF (@JobCount = 1)
	BEGIN
		SET @IsJobAdmin = 1
	END
	ELSE
	BEGIN
		 IF NOT EXISTS(SELECT 1 FROM #EntityIdTemp WHERE ISNULL(EntityId, 0) = @id)
		 BEGIN 
			SET @JobIsHavingPermission = 0;
		 END
	END
	----------Security Check Start----------
	END
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
		Where StatusId IN (1,2) AND ISNULL(CgoQtyUnits, '') <> '' AND CgoQtyUnits NOT IN ('Cabinets', 'Pallets')
		GROUP BY JobId

		SELECT JobId
			,Count(JobId) CargoCount
		INTO #ActualCargoQuantityCount
		FROM [dbo].[JOBDL010Cargo]
		Where StatusId IN (1,2) AND ISNULL(CgoQtyUnits, '') <> '' AND CgoQtyUnits IN ('Cabinets', 'Pallets')
		GROUP BY JobId
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
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimePlanned
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeActual
			,CAST(CAST(GETUTCDATE() AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeBaseline
			,@JobElectronicInvoice JobElectronicInvoice
			,@CustomerID CustomerId
	END
	ELSE
	BEGIN
	   SELECT @JobDeliveryAnalystContactIDName =ConFullName FROM CONTC000Master 
							WHERE Id =(SELECT JobDeliveryAnalystContactID FROM JOBDL000Master WHERE Id = @ID)
		SELECT @JobDeliveryResponsibleContactIDName =ConFullName FROM CONTC000Master 
							WHERE Id =(SELECT JobDeliveryResponsibleContactID FROM JOBDL000Master WHERE Id = @ID)
		SELECT @JobOriginResponsibleContactIDName =ConFullName FROM CONTC000Master 
							WHERE Id =(SELECT JobOriginResponsibleContactID FROM JOBDL000Master WHERE Id = @ID)
		SELECT @JobDriverIdName =ConFullName FROM CONTC000Master 
							WHERE Id =(SELECT JobDriverId FROM JOBDL000Master WHERE Id = @ID)

		SELECT @JobQtyUnitTypeIdName =SysOptionName FROM SYSTM000Ref_Options 
							WHERE Id =CASE WHEN (SELECT JobQtyUnitTypeId FROM JOBDL000Master WHERE Id = @ID) = 0 THEN 
							(SELECT ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'CABINET') ELSE
							(SELECT JobQtyUnitTypeId FROM JOBDL000Master WHERE Id = @ID) END
		SELECT @JobCubesUnitTypeIdName =SysOptionName FROM SYSTM000Ref_Options 
							WHERE Id =CASE WHEN (SELECT JobCubesUnitTypeId FROM JOBDL000Master WHERE Id = @ID) = 0 THEN 
							(SELECT ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'E') ELSE
							(SELECT JobCubesUnitTypeId FROM JOBDL000Master WHERE Id = @ID) END;
		SELECT @JobWeightUnitTypeIdName =SysOptionName FROM SYSTM000Ref_Options 
							WHERE Id =CASE WHEN (SELECT JobWeightUnitTypeId FROM JOBDL000Master WHERE Id = @ID) = 0 THEN 
							(SELECT ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'K') ELSE
							(SELECT JobWeightUnitTypeId FROM JOBDL000Master WHERE Id = @ID) END;
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
			,Job.JobQtyActual
			,Job.JobQtyUnitTypeId
			,Job.JobPartsOrdered
			,Job.JobPartsActual
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
			,job.JobServiceOrder
			,job.JobServiceActual
			,job.IsJobVocSurvey
			,@JobIsHavingPermission AS JobIsHavingPermission
			,@JobDeliveryAnalystContactIDName  AS JobDeliveryAnalystContactIDName
			,@JobDeliveryResponsibleContactIDName AS JobDeliveryResponsibleContactIDName
			,@JobQtyUnitTypeIdName AS JobQtyUnitTypeIdName
			,@JobCubesUnitTypeIdName AS JobCubesUnitTypeIdName
			,@JobWeightUnitTypeIdName AS JobWeightUnitTypeIdName
			,@JobOriginResponsibleContactIDName AS JobOriginResponsibleContactIDName
			,@JobDriverIdName AS JobDriverIdName
			,Customer.Id CustomerId
			,job.JobTransitionStatusId
		FROM [dbo].[JOBDL000Master] job
		INNER JOIN PRGRM000MASTER prg ON job.ProgramID = prg.Id
		INNER JOIN dbo.CUST000Master Customer ON Customer.Id = prg.PrgCustID 
		LEFT JOIN dbo.PRGRM051VendorLocations PVC ON PVC.PvlProgramID = prg.Id AND ISNULL(PVC.PvlLocationCode, '') = ISNULL(Job.JobSiteCode,'') AND PVC.StatusId = 1
	    LEFT JOIN dbo.Vend000Master Vendor On Vendor.Id = PVC.PvlVendorId
		LEFT JOIN dbo.NAV000JobSalesOrderMapping JOM ON JOM.JobId = Job.Id AND ISNULL(JOM.IsElectronicInvoiced,0) = 0 
		LEFT JOIN dbo.NAV000JobPurchaseOrderMapping JPM ON JPM.JobSalesOrderMappingId = JOM.JobSalesOrderMappingId AND ISNULL(JPM.IsElectronicInvoiced,0) = 0
		LEFT JOIN dbo.NAV000JobSalesOrderMapping EJOM ON EJOM.JobId = Job.Id AND ISNULL(EJOM.IsElectronicInvoiced,0) = 1
		LEFT JOIN dbo.NAV000JobPurchaseOrderMapping EJPM ON EJPM.JobSalesOrderMappingId = EJOM.JobSalesOrderMappingId AND ISNULL(EJPM.IsElectronicInvoiced,0) = 1
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




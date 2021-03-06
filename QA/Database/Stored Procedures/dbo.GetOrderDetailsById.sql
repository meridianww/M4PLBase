SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kamal          
-- Create date:               07/28/2020      
-- Description:               Get a Job Details by job id  
-- Exec :					  Exec GetOrderDetailsById1 2,14,1, 170712   
-- =============================================  
CREATE PROCEDURE [dbo].[GetOrderDetailsById] @userId BIGINT =0
	,@roleId BIGINT = 0
	,@orgId BIGINT = 1
	,@id BIGINT
AS
BEGIN
   IF OBJECT_ID('tempdb..#JobPermission') IS NOT NULL
		BEGIN
			DROP TABLE #JobPermission
		END
   CREATE TABLE #JobPermission
   (IsJobPermission BIT )
   IF (
			@userId > 0
			AND @orgId > 0
			)
	BEGIN
	   	INSERT INTO #JobPermission (IsJobPermission)
	    EXEC [dbo].[IsJobPermissionPresentForUser] @userId,@orgId,@id
		--IF EXISTS(SELECT 1 from #JobPermission WHERE IsJobPermission = 1)
		--BEGIN
		  
		--END
	END
	
	SELECT JOB.Id
		,JOB.JobCustomerSalesOrder AS CustomerSalesOrder
		,JOB.JobGatewayStatus AS GatewayStatus
		,JOB.JobDeliveryDateTimePlanned AS DeliveryDatePlanned
		,JOB.JobOriginDateTimePlanned AS ArrivalDatePlanned
		,JOB.JobBOL AS BOL
		,JOB.JobManifestNo AS ManifestNo
		,JOB.JobOrderedDate AS OrderDate
		,JOB.JobShipmentDate AS ShipmentDate
		,CUSTOMER.ID AS CustomerId
		,CUSTOMER.CustCode AS CustomerCode
		,JOB.ShipmentType AS GwyShipmentType
		,JOB.JobType AS GwyOrderType
		,Job.JobOriginSitePOC
		,Job.JobOriginSitePOCPhone
		,Job.JobOriginSitePOCEmail
		,Job.JobOriginStreetAddress
		,Job.JobOriginStreetAddress2
		,job.JobOriginStreetAddress3
		,job.JobOriginStreetAddress4
		,job.JobOriginCity
		,job.JobOriginState
		,job.JobOriginPostalCode
		,job.JobOriginCountry
		,Job.JobDeliverySitePOC
		,Job.JobDeliverySitePOCPhone
		,Job.JobDeliverySitePOCEmail
		,Job.JobDeliveryStreetAddress
		,Job.JobDeliveryStreetAddress2
		,job.JobDeliveryStreetAddress3
		,job.JobDeliveryStreetAddress4
		,job.JobDeliveryCity
		,job.JobDeliveryState
		,job.JobDeliveryPostalCode
		,job.JobDeliveryCountry
		,JOB.JobDeliveryDateTimeActual
		,JOB.JobDeliveryDateTimeBaseline 
		,Job.JobSellerSitePOC
		,Job.JobSellerSitePOCEmail
		,Job.JobSellerSitePOCPhone
		,Job.JobSellerStreetAddress
		,Job.JobSellerStreetAddress2
		,Job.JobSellerStreetAddress3
		,Job.JobSellerStreetAddress4
		,Job.JobSellerCity
		,Job.JobSellerState
		,Job.JobSellerPostalCode
		,optQtyUnitTypeId.SysOptionName AS JobCubesUnitTypeIdName
		,Job.JobTotalWeight
		,optWeightUnitTypeId.SysOptionName AS JobWeightUnitTypeIdName
		,Job.JobServiceOrder
		,Job.JobServiceActual
		,Job.JobDriverAlert
		,Job.JobQtyOrdered
		,Job.JobQtyActual
		,optQtyUnitTypeId.SysOptionName AS JobQtyUnitTypeIdName
		,Job.JobPartsOrdered
		,Job.JobPartsActual
		,Job.JobTotalCubes
		,CASE WHEN @userId = 0 AND @roleId = 0 THEN CAST(0 AS BIT) ELSE  CAST((SELECT IsJobPermission FROM #JobPermission) AS BIT) END IsJobPermission
	FROM CUST000Master CUSTOMER
	INNER JOIN PRGRM000Master PROGRAM ON PROGRAM.PrgCustID = CUSTOMER.ID
	INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = PROGRAM.ID
	LEFT JOIN SYSTM000Ref_Options optUnitTypeId ON optUnitTypeId.Id = JOB.JobCubesUnitTypeId
	LEFT JOIN SYSTM000Ref_Options optWeightUnitTypeId ON optWeightUnitTypeId.Id = JOB.JobWeightUnitTypeId
	LEFT JOIN SYSTM000Ref_Options optQtyUnitTypeId ON optQtyUnitTypeId.Id = JOB.JobQtyUnitTypeId
	WHERE CUSTOMER.StatusId = 1
		AND PROGRAM.StatusId = 1
		AND JOB.Id = @id

	SELECT GATEWAY.Id
		,GATEWAY.JobID
		,GATEWAY.GwyGatewayCode AS Code
		,GATEWAY.GwyGatewayTitle AS Title
		,GATEWAY.GwyGatewayACD AS [Date]
		,GATEWAY.GwyDDPCurrent ScheduleDate
		,GATEWAY.GwyDDPNew RescheduleDate
		,GATEWAY.GatewayTypeId AS [Type]
		,OPT.SysOptionName AS GateWayName
		,Gateway.GwyCompleted Completed
		,Gateway.GwyComment Comment
		,Gateway.GwyShipStatusReasonCode StatusCode
		,Gateway.GwyShipApptmtReasonCode AppointmentCode
	FROM JOBDL020Gateways GATEWAY
	LEFT JOIN SYSTM000Ref_Options OPT ON OPT.Id = GATEWAY.GatewayTypeId
	WHERE GATEWAY.JobID = @id AND GATEWAY.GatewayTypeId =85
END

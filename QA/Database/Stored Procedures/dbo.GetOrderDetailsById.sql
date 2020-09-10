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
-- Exec :					  Exec GetOrderDetailsById 170712   
-- =============================================  
ALTER PROCEDURE GetOrderDetailsById @userId BIGINT =0
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
		,CASE WHEN @userId = 0 AND @roleId = 0 THEN CAST(0 AS BIT) ELSE  CAST((SELECT IsJobPermission FROM #JobPermission) AS BIT) END IsJobPermission
	FROM CUST000Master CUSTOMER
	INNER JOIN PRGRM000Master PROGRAM ON PROGRAM.PrgCustID = CUSTOMER.ID
	INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = PROGRAM.ID
	WHERE CUSTOMER.StatusId = 1
		AND PROGRAM.StatusId = 1
		AND JOB.Id = @id

	SELECT GATEWAY.Id
		,GATEWAY.JobID
		,GATEWAY.GwyGatewayCode AS GatewayCode
		,GATEWAY.GwyGatewayACD AS ACD
		,GATEWAY.GwyDDPCurrent
		,GATEWAY.GwyDDPNew
		,GATEWAY.GatewayTypeId AS TypeId
		,OPT.SysOptionName AS GateWayName
	FROM JOBDL020Gateways GATEWAY
	LEFT JOIN SYSTM000Ref_Options OPT ON OPT.Id = GATEWAY.GatewayTypeId
	WHERE GATEWAY.JobID = @id AND GATEWAY.GatewayTypeId =85
END
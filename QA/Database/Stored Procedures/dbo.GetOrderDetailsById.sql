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
-- Exec :					  Exec GetOrderDetailsById 2,14,1, 1234   
-- =============================================  
ALTER PROCEDURE GetOrderDetailsById 
	-- @userId BIGINT
	--,@roleId BIGINT
	--,@orgId BIGINT = 1
	  @id BIGINT
AS
BEGIN
	SELECT JOB.Id
		,JOB.JobCustomerSalesOrder AS CustomerSalesOrder
		,JOB.JobGatewayStatus AS GatewayStatus
		,JOB.JobDeliveryDateTimePlanned AS DeliveryDatePlanned
		,JOB.JobOriginDateTimePlanned AS ArrivalDatePlanned
		,JOB.JobBOL AS BOL
		,JOB.JobManifestNo AS ManifestNo
		,JOB.JobOrderedDate AS OrderDate
		,JOB.JobShipmentDate as ShipmentDate
	FROM JOBDL000Master JOB
	WHERE Id = @id
		--AND StatusId = 1
		--AND JobCompleted = 0

	SELECT GATEWAY.Id,
	       GATEWAY.JobID,
		   GATEWAY.GwyGatewayCode AS GatewayCode,
		   GATEWAY.GwyGatewayACD AS ACD,
		   GATEWAY.GwyGatewayPCD AS PCD,
		   GATEWAY.GatewayTypeId AS TypeId,
		   OPT.SysOptionName AS GateWayName
	FROM JOBDL020Gateways GATEWAY 
	LEFT JOIN SYSTM000Ref_Options OPT ON OPT.Id = GATEWAY.GatewayTypeId
	WHERE GATEWAY.JobID = @id --AND GatewayTypeId =85 --AND StatusId = 194 
END
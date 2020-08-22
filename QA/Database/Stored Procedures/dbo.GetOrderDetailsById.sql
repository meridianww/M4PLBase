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
ALTER PROCEDURE GetOrderDetailsById @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT = 1
	,@id BIGINT
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
		,JOB.JobShipmentDate AS ShipmentDate
		,CUSTOMER.ID AS CustomerId
		,CUSTOMER.CustCode AS CustomerCode
		,JOB.ShipmentType AS GwyShipmentType
		,JOB.JobType AS GwyOrderType
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
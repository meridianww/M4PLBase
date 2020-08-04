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
		,CUSTOMER.ID AS CustomerId
		,CUSTOMER.CustCode AS CustomerCode
	FROM CUST000Master CUSTOMER
		 INNER JOIN PRGRM000Master PROGRAM ON PROGRAM.PrgCustID = CUSTOMER.ID
		 INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = PROGRAM.ID
   WHERE CUSTOMER.StatusId = 1 
	 AND PROGRAM.StatusId =1 
	 AND JOB.Id = @id
		--AND StatusId = 1
		--AND JobCompleted = 0

	SELECT GATEWAY.Id,
	       GATEWAY.JobID,
		   GATEWAY.GwyGatewayCode AS GatewayCode,
		   GATEWAY.GwyGatewayACD AS ACD,
		   --GATEWAY.GwyGatewayPCD AS PCD,
		   GATEWAY.GatewayTypeId AS TypeId,
		   OPT.SysOptionName AS GateWayName
	FROM JOBDL020Gateways GATEWAY 
	LEFT JOIN SYSTM000Ref_Options OPT ON OPT.Id = GATEWAY.GatewayTypeId
	WHERE GATEWAY.JobID = @id --AND GatewayTypeId =85 --AND StatusId = 194 

	SELECT ATT.Id,
	       DOCUMENT.JobID,
		   DOCUMENT.JdrCode ,
		   DOCUMENT.JdrTitle,
		   DOCUMENT.DocTypeId ,
		   OPT.SysOptionName AS DocTypeIdName
	FROM JOBDL040DocumentReference DOCUMENT 
	INNER JOIN [dbo].[SYSTM020Ref_Attachments] ATT ON ATT.AttPrimaryRecordID = DOCUMENT.Id AND ATT.AttTableName = 'JobDocReference' 
	LEFT JOIN SYSTM000Ref_Options OPT ON OPT.Id = DOCUMENT.DocTypeId
	WHERE DOCUMENT.JobID = @id AND ATT.StatusId = 1 AND DOCUMENT.StatusId = 1
END
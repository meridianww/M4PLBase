SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kamal          
-- Create date:               08/22/2020      
-- Description:               Get a Job Gateway Details by job id  
-- Exec :					  Exec GetOrderDetailsById 170712   
-- =============================================  
CREATE PROCEDURE GetGatewayDetailsByJobID @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT = 1
	,@id BIGINT
AS
BEGIN
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
	WHERE GATEWAY.JobID = @id 
END
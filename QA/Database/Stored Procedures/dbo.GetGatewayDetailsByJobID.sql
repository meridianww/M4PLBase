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
-- Exec :					  Exec [GetGatewayDetailsByJobID] 2,14,1,193524   
-- =============================================  
CREATE PROCEDURE [dbo].[GetGatewayDetailsByJobID] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT = 1
	,@id BIGINT
AS
BEGIN
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
	WHERE GATEWAY.JobID = @id 
END



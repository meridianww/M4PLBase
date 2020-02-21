SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Kamal           
-- Create date:               01/29/2020        
-- Description:               Get reasone code and appoinment code  
-- Execution:                 EXEC [dbo].[GetAppoinmentStatusReasoneCode]  37079,'Consignee Initiated Change'  
-- Modified on:				  
-- Modified Desc:    

CREATE PROCEDURE [dbo].[GetAppoinmentStatusReasoneCode]
@jobID BIGINT,
@pgdGatewayTitle NVARCHAR(200)
AS
BEGIN
SELECT TOP 1 PgdShipStatusReasonCode,PgdShipApptmtReasonCode from PRGRM010Ref_GatewayDefaults 
WHERE PgdProgramID IN (SELECT DISTINCT ProgramID FROM JOBDL020Gateways WHERE jobid =@jobID and ProgramID is not null)
AND PgdShipApptmtReasonCode IS NOT NULL AND PgdShipStatusReasonCode IS NOT NULL
AND PgdGatewayTitle LIKE '%'+ @pgdGatewayTitle + '%'
END
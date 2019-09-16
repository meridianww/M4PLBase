SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get all job Actions
-- Execution:                 EXEC [dbo].[GetJobActions]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetJobActions]
	     @jobId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
		SELECT DISTINCT
		shipApptCode.PacApptReasonCode,
		shipApptCode.PacApptTitle,
		shipReasonCode.PscShipReasonCode,
		shipReasonCode.PscShipTitle,
		prgGateway.PgdGatewayCode,
		prgGateway.PgdGatewayTitle,
		prgGateway.PgdGatewaySortOrder
		FROM [dbo].[JOBDL000Master] job
		JOIN [dbo].[PRGRM000Master] prg ON job.[ProgramID] = prg.Id
		JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID]-- AND prgGateway.GatewayTypeId = 86 --AND prgGateway.[StatusId] = 1 
		--AND prgGateway.PgdGatewayTitle IS NOT NULL AND prgGateway.[PgdShipApptmtReasonCode] IS NOT NULL AND prgGateway.[PgdShipStatusReasonCode] IS NOT NULL
		left JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode AND prg.Id = shipReasonCode.PscProgramID AND shipReasonCode.[StatusId] = 1 
		left JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode] AND prg.Id = shipApptCode.[PacProgramID] AND shipApptCode.[StatusId] = 1
		WHERE job.Id = @jobId ORDER BY prgGateway.PgdGatewaySortOrder ASC
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

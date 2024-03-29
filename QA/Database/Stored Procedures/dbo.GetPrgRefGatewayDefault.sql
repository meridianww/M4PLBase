SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ref Gateway Default
-- Execution:                 EXEC [dbo].[GetPrgRefGatewayDefault] 2,14,1,10524
-- Modified on:               04/27/2018
-- Modified Desc:             Added Scanner Field
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================
CREATE PROCEDURE  [dbo].[GetPrgRefGatewayDefault]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PgdProgramID]
		,prg.[PgdGatewaySortOrder]
		,prg.[PgdGatewayCode]
		,prg.[PgdGatewayTitle]
		,prg.[PgdGatewayDuration]
		,prg.[UnitTypeId]
		,prg.[PgdGatewayDefault]
		,prg.[GatewayTypeId]
		,prg.[GatewayDateRefTypeId]
		,prg.[Scanner]
		,prg.[PgdShipApptmtReasonCode]
		,prg.[PgdShipStatusReasonCode]
		,prg.[PgdOrderType]
		,prg.[PgdShipmentType]
		,prg.[PgdGatewayResponsible]
		,prg.[PgdGatewayAnalyst]
		,prg.[PgdGatewayDefaultComplete]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
		,prg.[InstallStatusId]
		,prg.[PgdGatewayStatusCode]
		,prg1.prgCustId CustomerId
		,prg.[MappingId]
		,prg.[TransitionStatusId]
		,prg.[PgdGatewayDefaultForJob]
		,prg.[PgdGatewayNavOrderOption]
  FROM   [dbo].[PRGRM010Ref_GatewayDefaults] prg
  INNER JOIN PRGRM000Master PRG1 ON PRG1.Id = prg.[PgdProgramID]
 WHERE   prg.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO

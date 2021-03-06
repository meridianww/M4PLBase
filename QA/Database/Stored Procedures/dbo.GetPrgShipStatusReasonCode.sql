SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipStatusReasonCode]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetPrgShipStatusReasonCode]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PscOrgID]
		,prg.[PscProgramID]
		,prg.[PscShipItem]
		,prg.[PscShipReasonCode]
		,prg.[PscShipLength]
		,prg.[PscShipInternalCode]
		,prg.[PscShipPriorityCode]
		,prg.[PscShipTitle]
		,prg.[PscShipCategoryCode]
		,prg.[PscShipUser01Code]
		,prg.[PscShipUser02Code]
		,prg.[PscShipUser03Code]
		,prg.[PscShipUser04Code]
		,prg.[PscShipUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM030ShipStatusReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipApptmtReasonCode]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetPrgShipApptmtReasonCode]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PacOrgID]
		,prg.[PacProgramID]
		,prg.[PacApptItem]
		,prg.[PacApptReasonCode]
		,prg.[PacApptLength]
		,prg.[PacApptInternalCode]
		,prg.[PacApptPriorityCode]
		,prg.[PacApptTitle]
		,prg.[PacApptCategoryCodeId]
		,prg.[PacApptUser01Code]
		,prg.[PacApptUser02Code]
		,prg.[PacApptUser03Code]
		,prg.[PacApptUser04Code]
		,prg.[PacApptUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM031ShipApptmtReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

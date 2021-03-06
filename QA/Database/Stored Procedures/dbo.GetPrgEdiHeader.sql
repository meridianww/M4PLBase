SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program header
-- Execution:                 EXEC [dbo].[GetPrgEdiHeader]
-- Modified on:               05/10/2018
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================
CREATE PROCEDURE  [dbo].[GetPrgEdiHeader]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PehParentEDI]
		,prg.[PehProgramID]
		,prg.[PehItemNumber]
		,prg.[PehEdiCode]
		,prg.[PehEdiTitle]
		,prg.[PehTradingPartner]
		,prg.[PehEdiDocument]
		,prg.[PehEdiVersion]
		,prg.[PehSCACCode]
		,prg.[PehSndRcv]
		,prg.[PehInsertCode]   
        ,prg.[PehUpdateCode]   
        ,prg.[PehCancelCode]   
        ,prg.[PehHoldCode]     
        ,prg.[PehOriginalCode] 
        ,prg.[PehReturnCode] 
		,prg.[UDF01]
        ,prg.[UDF02]
        ,prg.[UDF03]
        ,prg.[UDF04]
		,prg.[UDF05]
        ,prg.[UDF06]
        ,prg.[UDF07]
        ,prg.[UDF08]
		,prg.[UDF09]
        ,prg.[UDF10]        
		,prg.[PehAttachments]
		,prg.[StatusId]
		,prg.[PehDateStart]
		,prg.[PehDateEnd]	
		,prg.[PehInOutFolder]
        ,prg.[PehArchiveFolder]
		,prg.[PehProcessFolder]
		,prg.[PehFtpServerUrl]
		,prg.[PehFtpUsername]
		,prg.[PehFtpPassword]
		,prg.[PehFtpPort]	
		,prg.[IsSFTPUsed]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM070EdiHeader] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH


GO

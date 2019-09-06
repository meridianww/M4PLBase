GO
/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               10/22/2018      
-- Description:               Get PrgEdiCondition By EdiHeader
-- Execution:                 EXEC [dbo].[GetPrgEdiConditionByEdiHeader]   
-- =============================================  
CREATE PROCEDURE  [dbo].[GetPrgEdiConditionByEdiHeader]
    @userId BIGINT,
    @roleId BIGINT,
	@id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT ediCon.[Id]
		,ediCon.[PecProgramId]
		,ediCon.[PecProgramId]
		,ediCon.[PecJobField]
		,ediCon.[PecCondition]
		,ediCon.[PerLogical]
		,ediCon.[PecJobField2]
		,ediCon.[PecCondition2]
		,ediCon.[DateEntered]
		,ediCon.[EnteredBy]
	   FROM [dbo].[PRGRM072EdiConditions] ediCon
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
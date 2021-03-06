SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Janardana Behara         
-- Create date:               06/01/2018        
-- Description:               Get a update job Gateway  on complete check
-- Execution:                 EXEC [dbo].[UpdJobGatewayComplete]    
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================  
CREATE PROCEDURE  [dbo].[UpdJobGatewayComplete]  
	@userId BIGINT 
	,@roleId NVARCHAR(25)
	,@orgId BIGINT  
	,@id BIGINT  
	,@jobId BIGINT 
	,@gwyGatewayCode NVARCHAR(25)  =NULL
	,@gwyGatewayTitle NVARCHAR(50) =NULL
	,@gwyShipApptmtReasonCode  NVARCHAR(25)  =NULL
	,@gwyShipStatusReasonCode   NVARCHAR(25)  =NULL
	,@dateChanged datetime2(7) = NULL      
	,@changedBy nvarchar(50) = NULL  
	,@isFormView BIT = 0
	,@entity varchar(50)
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
   
   
   UPDATE  JOBDL020Gateways 
    SET   GwyGatewayCode    =       @gwyGatewayCode 
	     ,GwyGatewayTitle  =         @gwyGatewayTitle 
	     ,GwyShipApptmtReasonCode =   @gwyShipApptmtReasonCode   
         ,GwyShipStatusReasonCode  =  @gwyShipStatusReasonCode   
		 ,GwyCompleted = 1
		 ,DateChanged = @dateChanged
		 ,ChangedBy = @changedBy
   WHERE Id = @id;
     
   SELECT job.[Id]  
  ,job.[JobID]  
  ,job.[ProgramID]
  ,job.[GwyGatewayCode]  
  ,job.[GwyGatewayTitle]
  ,job.GwyShipApptmtReasonCode  
  ,job.GwyShipStatusReasonCode  
  
  FROM   [dbo].[JOBDL020Gateways] job  
  
 WHERE   job.[Id] = @id 
    
   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

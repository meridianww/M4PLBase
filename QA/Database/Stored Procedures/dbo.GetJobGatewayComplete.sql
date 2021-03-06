SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job Gateway  
-- Execution:                 EXEC [dbo].[GetJobGateway]    
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)      
-- Modified Desc:    
-- =============================================  
CREATE PROCEDURE  [dbo].[GetJobGatewayComplete]   
    @userId BIGINT,  
    @roleId BIGINT,  
    @orgId BIGINT,  
    @id BIGINT,  
    @parentId BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
     
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

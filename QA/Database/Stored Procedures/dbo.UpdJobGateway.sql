SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Job Gateway   
-- Execution:                 EXEC [dbo].[UpdJobGateway]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               04/27/2018
-- Modified Desc:             
-- =============================================      
CREATE PROCEDURE  [dbo].[UpdJobGateway]      
	(@userId BIGINT      
	,@roleId BIGINT  
	,@entity NVARCHAR(100)      
	,@id bigint      
	,@jobId bigint = NULL      
	,@programId bigint = NULL      
	,@gwyGatewaySortOrder int = NULL      
	,@gwyGatewayCode nvarchar(20) = NULL      
	,@gwyGatewayTitle nvarchar(50) = NULL      
	,@gwyGatewayDuration decimal(18, 2) = NULL      
	,@gwyGatewayDefault bit = NULL      
	,@gatewayTypeId int = NULL      
	,@gwyGatewayAnalyst bigint = NULL      
	,@gwyGatewayResponsible bigint = NULL      
	,@gwyGatewayPCD datetime2(7) = NULL      
	,@gwyGatewayECD datetime2(7) = NULL      
	,@gwyGatewayACD datetime2(7) = NULL      
	,@gwyCompleted bit = NULL      
	,@gatewayUnitId int = NULL      
	,@gwyAttachments int = NULL      
	,@gwyProcessingFlags nvarchar(20) = NULL      
	,@gwyDateRefTypeId int = NULL      
	,@scanner bit = NULL   
	,@gwyShipApptmtReasonCode nvarchar(20)     
	,@gwyShipStatusReasonCode nvarchar(20)   
	,@gwyOrderType nvarchar(20)     
	,@gwyShipmentType nvarchar(20)          
	,@statusId int = NULL      
	--,@gwyUpdatedStatusOn  datetime2(7)    =NULL    
	,@gwyUpdatedById int = NULL      
	,@gwyClosedOn datetime2(7) = NULL      
	,@gwyClosedBy nvarchar(50) = NULL    
	,@gwyPerson  NVARCHAR(50) = NULL
	,@gwyPhone   NVARCHAR(25) = NULL 
	,@gwyEmail    NVARCHAR(25) = NULL
	,@gwyTitle    NVARCHAR(50) = NULL
	,@gwyDDPCurrent datetime2(7) = NULL        
	,@gwyDDPNew datetime2(7) = NULL        
	,@gwyUprWindow decimal(18, 2) = NULL 
	,@gwyLwrWindow decimal(18, 2) = NULL  
	,@gwyUprDate datetime2(7) = NULL        
	,@gwyLwrDate datetime2(7) = NULL        
	,@dateChanged datetime2(7) = NULL      
	,@changedBy nvarchar(50) = NULL  
	,@isFormView BIT = 0
	,@where nvarchar(200)=NULL )       
AS      
BEGIN TRY                      
 SET NOCOUNT ON;         
   DECLARE @updatedItemNumber INT            
 -- DECLARE @where NVARCHAR(MAX) = ' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR)                    
  EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @gwyGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
      
 UPDATE [dbo].[JOBDL020Gateways]      
  SET  [JobID]              = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END     
   ,[ProgramID]             = CASE WHEN (@isFormView = 1) THEN @programId WHEN ((@isFormView = 0) AND (@programId=-100)) THEN NULL ELSE ISNULL(@programId, ProgramID)   END   
   ,[GwyGatewaySortOrder]   = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, GwyGatewaySortOrder)    END  
   ,[GwyGatewayCode]        = CASE WHEN (@isFormView = 1) THEN @gwyGatewayCode WHEN ((@isFormView = 0) AND (@gwyGatewayCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyGatewayCode, GwyGatewayCode)    END  
   ,[GwyGatewayTitle]       = CASE WHEN (@isFormView = 1) THEN @gwyGatewayTitle WHEN ((@isFormView = 0) AND (@gwyGatewayTitle='#M4PL#')) THEN NULL ELSE ISNULL(@gwyGatewayTitle, GwyGatewayTitle)    END  
   ,[GwyGatewayDuration]    = CASE WHEN (@isFormView = 1) THEN @gwyGatewayDuration WHEN ((@isFormView = 0) AND (@gwyGatewayDuration=-100.00)) THEN NULL ELSE ISNULL(@gwyGatewayDuration, GwyGatewayDuration) END     
   ,[GwyGatewayDefault]     = ISNULL(@gwyGatewayDefault, GwyGatewayDefault)  
   ,[GatewayTypeId]         = CASE WHEN (@isFormView = 1) THEN @gatewayTypeId WHEN ((@isFormView = 0) AND (@gatewayTypeId=-100)) THEN NULL ELSE ISNULL(@gatewayTypeId, GatewayTypeId)    END  
   ,[GwyGatewayAnalyst]     = CASE WHEN (@isFormView = 1) THEN @gwyGatewayAnalyst WHEN ((@isFormView = 0) AND (@gwyGatewayAnalyst=-100)) THEN NULL ELSE ISNULL(@gwyGatewayAnalyst, GwyGatewayAnalyst) END      
   ,[GwyGatewayResponsible] = CASE WHEN (@isFormView = 1) THEN @gwyGatewayResponsible WHEN ((@isFormView = 0) AND (@gwyGatewayResponsible=-100)) THEN NULL ELSE ISNULL(@gwyGatewayResponsible, GwyGatewayResponsible) END     
   ,[GwyGatewayPCD]         = CASE WHEN (@isFormView = 1) THEN @gwyGatewayPCD WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyGatewayPCD, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyGatewayPCD, GwyGatewayPCD)    END  
   ,[GwyGatewayECD]         = CASE WHEN (@isFormView = 1) THEN @gwyGatewayECD WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyGatewayECD, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyGatewayECD, GwyGatewayECD)    END  
   ,[GwyGatewayACD]         = CASE WHEN (@isFormView = 1) THEN @gwyGatewayACD WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyGatewayACD, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyGatewayACD, GwyGatewayACD)    END  
   ,[GwyCompleted]          = ISNULL(@gwyCompleted, GwyCompleted)  
   ,[GatewayUnitId]         = CASE WHEN (@isFormView = 1) THEN @gatewayUnitId WHEN ((@isFormView = 0) AND (@gatewayUnitId=-100)) THEN NULL ELSE ISNULL(@gatewayUnitId, GatewayUnitId)    END  
   --,[GwyAttachments]        = CASE WHEN (@isFormView = 1) THEN @gwyAttachments WHEN ((@isFormView = 0) AND (@gwyAttachments=-100)) THEN NULL ELSE ISNULL(@gwyAttachments, GwyAttachments)    END  
   ,[GwyProcessingFlags]    = CASE WHEN (@isFormView = 1) THEN @gwyProcessingFlags WHEN ((@isFormView = 0) AND (@gwyProcessingFlags='#M4PL#')) THEN NULL ELSE ISNULL(@gwyProcessingFlags, GwyProcessingFlags) END     


   ,[GwyDateRefTypeId]      = CASE WHEN (@isFormView = 1) THEN @gwyDateRefTypeId WHEN ((@isFormView = 0) AND (@gwyDateRefTypeId=-100)) THEN NULL ELSE ISNULL(@gwyDateRefTypeId, GwyDateRefTypeId)    END  
   ,[Scanner]          = ISNULL(@scanner, Scanner)  

   ,GwyShipApptmtReasonCode    = CASE WHEN (@isFormView = 1) THEN @gwyShipApptmtReasonCode WHEN ((@isFormView = 0) AND (@gwyShipApptmtReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipApptmtReasonCode, GwyShipApptmtReasonCode) END     
   ,GwyShipStatusReasonCode    = CASE WHEN (@isFormView = 1) THEN @gwyShipStatusReasonCode WHEN ((@isFormView = 0) AND (@gwyShipStatusReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipStatusReasonCode, GwyShipStatusReasonCode) END     
   ,[GwyOrderType]           = CASE WHEN (@isFormView = 1) THEN @gwyOrderType WHEN ((@isFormView = 0) AND (@gwyOrderType='#M4PL#')) THEN NULL ELSE ISNULL(@gwyOrderType, GwyOrderType) END  
   ,[GwyShipmentType]           = CASE WHEN (@isFormView = 1) THEN @gwyShipmentType WHEN ((@isFormView = 0) AND (@gwyShipmentType='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipmentType, GwyShipmentType) END  



   ,[StatusId]              = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)    END  
   --,[GwyUpdatedStatusOn]     =ISNULL(@gwyUpdatedStatusOn,GwyUpdatedStatusOn)    
   ,[GwyUpdatedById]        = CASE WHEN (@isFormView = 1) THEN @gwyUpdatedById WHEN ((@isFormView = 0) AND (@gwyUpdatedById=-100)) THEN NULL ELSE ISNULL(@gwyUpdatedById, GwyUpdatedById)  END    
   ,[GwyClosedOn]           = CASE WHEN (@isFormView = 1) THEN @gwyClosedOn WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyClosedOn, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyClosedOn, GwyClosedOn)  END    
   ,[GwyClosedBy]           = CASE WHEN (@isFormView = 1) THEN @gwyClosedBy WHEN ((@isFormView = 0) AND (@gwyClosedBy='#M4PL#')) THEN NULL ELSE ISNULL(@gwyClosedBy, GwyClosedBy)   END   
   
   ,[GwyPerson]           = CASE WHEN (@isFormView = 1) THEN @gwyPerson WHEN ((@isFormView = 0) AND (@gwyPerson='#M4PL#')) THEN NULL ELSE ISNULL(@gwyPerson, GwyPerson) END  
   ,[GwyPhone]           = CASE WHEN (@isFormView = 1) THEN @gwyPhone WHEN ((@isFormView = 0) AND (@gwyPhone='#M4PL#')) THEN NULL ELSE ISNULL(@gwyPhone, GwyPhone) END  
   ,[GwyEmail]           = CASE WHEN (@isFormView = 1) THEN @gwyEmail WHEN ((@isFormView = 0) AND (@gwyEmail='#M4PL#')) THEN NULL ELSE ISNULL(@gwyEmail, GwyEmail) END  
   ,[GwyTitle]           = CASE WHEN (@isFormView = 1) THEN @gwyTitle WHEN ((@isFormView = 0) AND (@gwyTitle='#M4PL#')) THEN NULL ELSE ISNULL(@gwyTitle, GwyTitle) END  
   ,[GwyDDPCurrent]         = CASE WHEN (@isFormView = 1) THEN @gwyDDPCurrent WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyDDPCurrent, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyDDPCurrent, GwyDDPCurrent)    END  
   ,[GwyDDPNew]         = CASE WHEN (@isFormView = 1) THEN @gwyDDPNew WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyDDPNew, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyDDPNew, GwyDDPNew)    END  
   ,[GwyUprDate]         = CASE WHEN (@isFormView = 1) THEN @gwyUprDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyUprDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyUprDate, GwyUprDate)    END  
   ,[GwyLwrDate]         = CASE WHEN (@isFormView = 1) THEN @gwyLwrDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyLwrDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyLwrDate, GwyLwrDate)    END  
   ,[GwyUprWindow]             = CASE WHEN (@isFormView = 1) THEN @gwyUprWindow WHEN ((@isFormView = 0) AND (@gwyUprWindow=-100.00)) THEN NULL ELSE ISNULL(@gwyUprWindow,GwyUprWindow) END  
   ,[GwyLwrWindow]             = CASE WHEN (@isFormView = 1) THEN @gwyLwrWindow WHEN ((@isFormView = 0) AND (@gwyLwrWindow=-100.00)) THEN NULL ELSE ISNULL(@gwyLwrWindow,GwyLwrWindow) END  
   
   ,[DateChanged]           = @dateChanged      
   ,[ChangedBy]             = @changedBy      
  WHERE   [Id] = @id      ;

  UPDATE  [JOBDL020Gateways] SET [GwyGatewayACD] = GETUTCDATE()
  WHERE [GwyGatewayACD] IS NULL AND [GwyCompleted] = 1 AND [Id] = @id      ;

  UPDATE  [JOBDL020Gateways] SET [GwyCompleted] = 1
  WHERE [GwyGatewayACD] IS NOT NULL AND [GwyCompleted] = 0 AND [Id] = @id      ;


 SELECT job.[Id]      
  ,job.[JobID]      
  ,job.[ProgramID]      
  ,job.[GwyGatewaySortOrder]      
  ,job.[GwyGatewayCode]      
  ,job.[GwyGatewayTitle]      
  ,job.[GwyGatewayDuration]      
  ,job.[GwyGatewayDefault]      
  ,job.[GatewayTypeId]      
  ,job.[GwyGatewayAnalyst]      
  ,job.[GwyGatewayResponsible]      
  ,job.[GwyGatewayPCD]      
  ,job.[GwyGatewayECD]      
  ,job.[GwyGatewayACD]      
  ,job.[GwyCompleted]      
  ,job.[GatewayUnitId]      
  ,job.[GwyAttachments]      
  ,job.[GwyProcessingFlags]      
  ,job.[GwyDateRefTypeId]      
  ,job.[Scanner]
  ,job.[StatusId]
  ,job.[GwyUpdatedById]      
  ,job.[GwyClosedOn]      
  ,job.[GwyClosedBy]      
  ,job.[DateEntered]      
  ,job.[EnteredBy]      
  ,job.[DateChanged]      
  ,job.[ChangedBy]  
   ,job.[GwyShipApptmtReasonCode]
  ,job.[GwyShipStatusReasonCode]
   ,job.[GwyOrderType]
  ,job.[GwyShipmentType]
      
  FROM   [dbo].[JOBDL020Gateways] job      
 WHERE   [Id] = @id      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO

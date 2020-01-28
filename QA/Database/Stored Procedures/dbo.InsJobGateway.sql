USE [M4PL_Test]
GO
/****** Object:  StoredProcedure [dbo].[InsJobGateway]    Script Date: 1/28/2020 11:32:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Ins a Job Gateway    
-- Execution:                 EXEC [dbo].[InsJobGateway]  
-- Modified on:               04/27/2018
-- Modified Desc:             Added scanner field
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)
-- =============================================        
        
ALTER PROCEDURE  [dbo].[InsJobGateway]        
	(@userId BIGINT        
	,@roleId BIGINT 
	,@entity NVARCHAR(100)        
	,@jobId bigint        
	,@programId bigint        
	,@gwyGatewaySortOrder int        
	,@gwyGatewayCode nvarchar(20)        
	,@gwyGatewayTitle nvarchar(50)        
	,@gwyGatewayDuration decimal(18, 2)        
	,@gwyGatewayDefault bit        
	,@gatewayTypeId int        
	,@gwyGatewayAnalyst bigint        
	,@gwyGatewayResponsible bigint        
	,@gwyGatewayPCD datetime2(7)        
	,@gwyGatewayECD datetime2(7)        
	,@gwyGatewayACD datetime2(7)        
	,@gwyCompleted bit        
	,@gatewayUnitId int        
	,@gwyAttachments int        
	,@gwyProcessingFlags nvarchar(20)        
	,@gwyDateRefTypeId int    
	,@scanner bit 
	,@gwyShipApptmtReasonCode nvarchar(20)     
	,@gwyShipStatusReasonCode nvarchar(20)    
	,@gwyOrderType nvarchar(20)     
	,@gwyShipmentType nvarchar(20)      
	,@statusId int        
	--,@gwyUpdatedStatusOn  datetime2(7)          
	,@gwyUpdatedById int        
	,@gwyClosedOn datetime2(7)        
	,@gwyClosedBy NVARCHAR(50) =NULL  
	,@gwyPerson  NVARCHAR(50) = NULL
	,@gwyPhone   NVARCHAR(25) = NULL 
	,@gwyEmail   NVARCHAR(25) = NULL
	,@gwyTitle   NVARCHAR(50) = NULL
	,@gwyDDPCurrent DATETIME2(7) = NULL        
	,@gwyDDPNew DATETIME2(7) = NULL        
	,@gwyUprWindow DECIMAL(18, 2) = NULL 
	,@gwyLwrWindow DECIMAL(18, 2) = NULL  
	,@gwyUprDate DATETIME2(7) = NULL        
	,@gwyLwrDate DATETIME2(7) = NULL     
	,@dateEntered datetime2(7)        
	,@enteredBy nvarchar(50)
	,@where nvarchar(200)=NULL)        
AS        
BEGIN TRY                        
 SET NOCOUNT ON;         
   DECLARE @updatedItemNumber INT  
DECLARE @GtyTypeId int             
  -- DECLARE @where NVARCHAR(MAX) = ' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR)                    
  EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @gwyGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT
 SELECT @GtyTypeId =Id FROM SYSTM000Ref_Options WHERE SysLookupCode='GatewayType' and SysOptionName='Action' 
 
  IF(@programId = 0)    
  BEGIN    
     SELECT @programId = ProgramID FROM JOBDL000Master WHERE Id = @jobId;    
  END    
         
           
 DECLARE @currentId BIGINT;        
 INSERT INTO [dbo].[JOBDL020Gateways]        
           ([JobID]        
   ,[ProgramID]        
   ,[GwyGatewaySortOrder]        
   ,[GwyGatewayCode]        
   ,[GwyGatewayTitle]        
   ,[GwyGatewayDuration]        
   ,[GwyGatewayDefault]        
   ,[GatewayTypeId]        
   ,[GwyGatewayAnalyst]        
   ,[GwyGatewayResponsible]        
   ,[GwyGatewayPCD]        
   ,[GwyGatewayECD]        
   ,[GwyGatewayACD]        
   ,[GwyCompleted]        
   ,[GatewayUnitId]        
   ,[GwyAttachments]        
   ,[GwyProcessingFlags]        
   ,[GwyDateRefTypeId]  
   ,[Scanner]  
   ,[GwyShipApptmtReasonCode]    
   ,[GwyShipStatusReasonCode] 
   ,[GwyOrderType]
   ,[GwyShipmentType]      
   ,[StatusId]       
   --,[GwyUpdatedStatusOn]         
   ,[GwyUpdatedById]        
   ,[GwyClosedOn]        
   ,[GwyClosedBy]  
   ,[GwyPerson]
   ,[GwyPhone]
   ,[GwyEmail]
   ,[GwyTitle]
   ,[GwyDDPCurrent]
   ,[GwyDDPNew]
   ,[GwyUprWindow]
   ,[GwyLwrWindow]
   ,[GwyUprDate]
   ,[GwyLwrDate]
   ,[DateEntered]        
   ,[EnteredBy])        
     VALUES        
           (@jobId        
      ,@programId        
      ,@updatedItemNumber        
      ,@gwyGatewayCode        
      ,@gwyGatewayTitle        
      ,@gwyGatewayDuration        
      ,@gwyGatewayDefault        
      ,@gatewayTypeId        
      ,@gwyGatewayAnalyst        
      ,@gwyGatewayResponsible        
      ,@gwyGatewayPCD        
      ,@gwyGatewayECD        
      ,ISNULL(@gwyGatewayACD, CASE WHEN @gwyCompleted  = 1 THEN GETUTCDATE() END)
      ,@gwyCompleted 
	  ,@gatewayUnitId        
      ,@gwyAttachments        
      ,@gwyProcessingFlags        
      ,@gwyDateRefTypeId   
	  ,@scanner  
	  ,@gwyShipApptmtReasonCode     
     ,@gwyShipStatusReasonCode
	 ,@gwyOrderType
	 ,@gwyShipmentType
      ,@statusId        
   --,@gwyUpdatedStatusOn      
      ,@gwyUpdatedById        
      ,@gwyClosedOn        
      ,@gwyClosedBy   
	  ,@gwyPerson
	  ,@gwyPhone
	  ,@gwyEmail
	  ,@gwyTitle
	  ,@gwyDDPCurrent
	  ,@gwyDDPNew
	  ,@gwyUprWindow
	  ,@gwyLwrWindow
	  ,@gwyUprDate
	  ,@gwyLwrDate
      ,@dateEntered        
      ,@enteredBy)        
   SET @currentId = SCOPE_IDENTITY();    
   
   UPDATE [JOBDL020Gateways] SET GwyCompleted =1 
   WHERE GwyCompleted =0 
      AND GwyGatewayACD IS NOT NULL 
	  AND  Id = @currentId;
 IF (@GtyTypeId = @gatewayTypeId)
 BEGIN
    UPDATE [dbo].[JOBDL020Gateways] set isActionAdded=1 where Id=@currentId
    UPDATE [dbo].[JOBDL020Gateways]
		SET GwyGatewayPCD = [dbo].[fnGetUpdateGwyGatewayPCD](GatewayUnitId, GwyGatewayDuration,@gwyDDPNew)
		WHERE JobID = @jobId AND GwyDateRefTypeId  = (SELECT TOP 1 id from SYSTM000Ref_Options where  SysOptionName= 'Delivery Date')
 END      
 SELECT * FROM [dbo].[JOBDL020Gateways] WHERE Id = @currentId;           
END TRY                      
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH

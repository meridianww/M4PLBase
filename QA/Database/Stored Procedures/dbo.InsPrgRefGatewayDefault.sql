SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Ins a  Program Ref Gateway Default  
-- Execution:                 EXEC [dbo].[InsPrgRefGatewayDefault]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================     
    
CREATE PROCEDURE  [dbo].[InsPrgRefGatewayDefault]    
	(@userId BIGINT    
	,@roleId BIGINT 
	,@entity NVARCHAR(100)    
	,@pgdProgramId bigint    
	,@pgdGatewaySortOrder int    
	,@pgdGatewayCode nvarchar(20)    
	,@pgdGatewayTitle nvarchar(50)    
	,@pgdGatewayDuration decimal(18, 0)    
	,@unitTypeId int    
	,@pgdGatewayDefault bit    
	,@gatewayTypeId int    
	,@gatewayDateRefTypeId int   
	,@scanner bit  
	,@pgdShipApptmtReasonCode nvarchar(20)   
	,@pgdShipStatusReasonCode nvarchar(20)   
	,@pgdOrderType nvarchar(20)     
	,@pgdShipmentType nvarchar(20)      
	,@pgdGatewayResponsible bigint
	,@pgdGatewayAnalyst bigint
	,@pgdGatewayDefaultComplete bit = 0
	,@statusId int    
	,@dateEntered datetime2(7)    
	,@enteredBy nvarchar(50)
	,@where nvarchar(200)=NULL 
	,@PgdGatewayStatusCode nvarchar(20) = NULL)    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;      
 --DECLARE @updatedItemNumber INT          
 --DECLARE @where NVARCHAR(MAX) =' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR) + ' AND PgdOrderType ='''  +  CAST(@pgdOrderType AS VARCHAR)  +''' AND PgdShipmentType ='''  +  CAST(@pgdShipmentType AS VARCHAR) +''''
 --EXEC [dbo].[ResetItemNumber] @userId, 0, @pgdProgramId, @entity, @pgdGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
 --EXEC [dbo].[GetLineNumberForProgramGateways] NULL,@pgdProgramId, @gatewayTypeId,@pgdOrderType,@pgdShipmentType,@updatedItemNumber OUTPUT 
 
 DECLARE @currentId BIGINT;    
 INSERT INTO [dbo].[PRGRM010Ref_GatewayDefaults]    
           ([PgdProgramID]    
   ,[PgdGatewaySortOrder]    
   ,[PgdGatewayCode]    
   ,[PgdGatewayTitle]    
   ,[PgdGatewayDuration]    
   ,[UnitTypeId]    
   ,[PgdGatewayDefault]    
   ,[GatewayTypeId]    
   ,[GatewayDateRefTypeId]  
   ,[Scanner]
   ,[PgdShipApptmtReasonCode]
   ,[PgdShipStatusReasonCode]
   ,[PgdOrderType]
   ,[PgdShipmentType]     
   ,[PgdGatewayResponsible]
   ,[PgdGatewayDefaultComplete]
   ,[PgdGatewayAnalyst]
   ,[PgdGatewayStatusCode]
   ,[StatusId]    
   ,[DateEntered]    
   ,[EnteredBy])    
     VALUES    
           (@pgdProgramID    
   ,@pgdGatewaySortOrder    
   ,@pgdGatewayCode    
   ,@pgdGatewayTitle    
      ,@pgdGatewayDuration    
      ,@unitTypeId    
      ,@pgdGatewayDefault    
      ,@gatewayTypeId    
      ,@gatewayDateRefTypeId    
	  ,@scanner
	  ,@pgdShipApptmtReasonCode
      ,@pgdShipStatusReasonCode
	  ,@pgdOrderType
      ,@pgdShipmentType    
	  ,@pgdGatewayResponsible 
	  ,@pgdGatewayDefaultComplete
      ,@pgdGatewayAnalyst
	  ,@PgdGatewayStatusCode 
      ,@statusId    
      ,@dateEntered    
      ,@enteredBy)    

SET @currentId = SCOPE_IDENTITY(); 
      
SELECT * FROM [dbo].[PRGRM010Ref_GatewayDefaults] WHERE Id = @currentId;     
END TRY                  
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH

GO

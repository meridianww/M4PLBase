SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group          
   All Rights Reserved Worldwide */          
-- =============================================                  
-- Author:                    Janardana Behara                   
-- Create date:               06/06/2018                
-- Description:               Copy ActRole On ProgramCreate      
-- Execution:                 EXEC [dbo].[CopyActRoleOnProgramCreate]          
-- Modified on:            
-- Modified Desc:            
-- =============================================          
          
CREATE  PROCEDURE  [dbo].[CopyProgramGatewaysAndAttributesFromParent]          
(   
 @userId BIGINT          
 ,@roleId BIGINT          
 ,@orgId bigint          
 ,@programId bigint        
 ,@parentId bigint        
 ,@dateEntered datetime2(7)          
 ,@enteredBy nvarchar(50)           
    )          
AS          
BEGIN TRY                          
 SET NOCOUNT ON;            
         
  -- Copy Program Gateways  
   INSERT INTO [dbo].[PRGRM010Ref_GatewayDefaults]  
   (  [PgdProgramID]  
      ,[PgdGatewaySortOrder]  
      ,[PgdGatewayCode]  
      ,[PgdGatewayTitle]  
      ,[PgdGatewayDescription]  
      ,[PgdGatewayDuration]  
      ,[UnitTypeId]  
      ,[PgdGatewayDefault]  
      ,[GatewayTypeId]  
      ,[GatewayDateRefTypeId]  
      ,[Scanner]  
      ,[PgdShipStatusReasonCode]  
      ,[PgdShipApptmtReasonCode]  
      ,[PgdOrderType]  
      ,[PgdShipmentType]  
      ,[PgdGatewayResponsible]  
      ,[PgdGatewayAnalyst]  
      ,[StatusId]  
      ,[PgdGatewayComment]  
      ,[DateEntered]  
      ,[EnteredBy]  
   )  
  
   SELECT   
       @programId  
       ,[PgdGatewaySortOrder] --ROW_Number() OVER ( Partition By GatewayTypeId, PgdOrderType,PgdShipmentType  Order By  [PgdGatewaySortOrder])   
      ,[PgdGatewayCode]  
      ,[PgdGatewayTitle]  
      ,[PgdGatewayDescription]  
      ,[PgdGatewayDuration]  
      ,[UnitTypeId]  
      ,[PgdGatewayDefault]  
      ,[GatewayTypeId]  
      ,[GatewayDateRefTypeId]  
      ,[Scanner]  
      ,[PgdShipStatusReasonCode]  
      ,[PgdShipApptmtReasonCode]  
      ,[PgdOrderType]  
      ,[PgdShipmentType]  
      ,[PgdGatewayResponsible]  
      ,[PgdGatewayAnalyst]  
      ,[StatusId]  
      ,[PgdGatewayComment]  
      ,@dateEntered  
      ,@enteredBy        
   FROM [PRGRM010Ref_GatewayDefaults] WHERE PgdProgramID= @parentId 
   --AND  StatusId in (1,2)  
   ORDER BY PgdGatewaySortOrder;  
  
   -- Copy Program Attributs  
  
   INSERT INTO [dbo].[PRGRM020Ref_AttributesDefault]  
   (  
       [ProgramID]  
      ,[AttItemNumber]  
      ,[AttCode]  
      ,[AttTitle]  
      ,[AttDescription]  
      ,[AttComments]  
      ,[AttQuantity]  
      ,[UnitTypeId]  
      ,[AttDefault]  
      ,[StatusId]  
      ,[DateEntered]  
      ,[EnteredBy]  
   )  
  
   SELECT   
       @programId  
      ,ROW_Number() OVER (Order By  [AttItemNumber])  
      ,[AttCode]  
      ,[AttTitle]  
      ,[AttDescription]  
      ,[AttComments]  
      ,[AttQuantity]  
      ,[UnitTypeId]  
      ,[AttDefault]  
      ,[StatusId]  
      ,@dateEntered  
      ,@enteredBy     
  FROM .[dbo].[PRGRM020Ref_AttributesDefault] WHERE ProgramID= @parentId 
  --AND  StatusId in (1,2)  
          
END TRY                        
BEGIN CATCH                          
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                          
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                          
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                          
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                          
END CATCH
GO

USE [M4PL_Dev]
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgRefGatewayDefault]    Script Date: 3/17/2019 9:51:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Program Ref Gateway Default  
-- Execution:                 EXEC [dbo].[UpdPrgRefGatewayDefault]  
-- Modified on:               04/27/2018
-- Modified Desc:             Added Scanner Field
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.) 
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdPrgRefGatewayDefault]  
(@userId BIGINT  
,@roleId BIGINT  
,@entity NVARCHAR(100)  
,@id bigint  
,@pgdProgramId bigint = NULL  
,@pgdGatewaySortOrder int = NULL  
,@pgdGatewayCode nvarchar(20) = NULL  
,@pgdGatewayTitle nvarchar(50) = NULL  
,@pgdGatewayDuration decimal(18, 0) = NULL  
,@unitTypeId int = NULL  
,@pgdGatewayDefault bit = NULL  
,@gatewayTypeId int = NULL  
,@scanner bit = NULL  
,@pgdShipApptmtReasonCode nvarchar(20)    = NULL
,@pgdShipStatusReasonCode nvarchar(20)  = NULL
,@pgdOrderType nvarchar(20)      = NULL
,@pgdShipmentType nvarchar(20)    = NULL
,@pgdGatewayResponsible bigint = NULL
,@pgdGatewayAnalyst bigint = NULL
,@statusId int = NULL  
,@gatewayDateRefTypeId int = NULL  
,@dateChanged datetime2(7) = NULL  
,@changedBy nvarchar(50) = NULL  
,@isFormView BIT = 0
,@where nvarchar(MAX)=NULL)   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT 
    
--DECLARE @where NVARCHAR(MAX) =' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR) + ' AND PgdOrderType ='''  +  CAST(@pgdOrderType AS VARCHAR)  +''' AND PgdShipmentType ='''  +  CAST(@pgdShipmentType AS VARCHAR) +''''
 EXEC [dbo].[ResetItemNumber] @userId, @id, @pgdProgramId, @entity, @pgdGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
 
     
 UPDATE [dbo].[PRGRM010Ref_GatewayDefaults]  
  SET  [PgdProgramID]              = CASE WHEN (@isFormView = 1) THEN @pgdProgramId WHEN ((@isFormView = 0) AND (@pgdProgramId=-100)) THEN  PgdProgramID ELSE  @pgdProgramId  END  
   ,[PgdGatewaySortOrder]       = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN PgdGatewaySortOrder  ELSE @updatedItemNumber  END  
   ,[PgdGatewayCode]            = CASE WHEN (@isFormView = 1) THEN @pgdGatewayCode WHEN ((@isFormView = 0) AND (@pgdGatewayCode='#M4PL#'))  THEN  PgdGatewayCode ELSE @pgdGatewayCode END  
   ,[PgdGatewayTitle]           = CASE WHEN (@isFormView = 1) THEN @pgdGatewayTitle WHEN ((@isFormView = 0) AND (@pgdGatewayTitle='#M4PL#')) THEN PgdGatewayTitle ELSE @pgdGatewayTitle END  
   ,[PgdGatewayDuration]        = CASE WHEN (@isFormView = 1) THEN @pgdGatewayDuration WHEN ((@isFormView = 0) AND (@pgdGatewayDuration=-100.00)) THEN PgdGatewayDuration ELSE @pgdGatewayDuration END  
   ,[UnitTypeId]     = CASE WHEN (@isFormView = 1) THEN @unitTypeId WHEN ((@isFormView = 0) AND (@unitTypeId=-100)) THEN UnitTypeId ELSE @unitTypeId END  
   ,[PgdGatewayDefault]         = ISNULL(@pgdGatewayDefault, PgdGatewayDefault)  
   ,[GatewayTypeId]             = CASE WHEN (@isFormView = 1) THEN @gatewayTypeId WHEN ((@isFormView = 0) AND (@gatewayTypeId=-100)) THEN GatewayTypeId ELSE @gatewayTypeId END  
   ,[GatewayDateRefTypeId]      = CASE WHEN (@isFormView = 1) THEN @gatewayDateRefTypeId WHEN ((@isFormView = 0) AND (@gatewayDateRefTypeId=-100)) THEN GatewayDateRefTypeId ELSE @gatewayDateRefTypeId END  
   ,[Scanner]          = ISNULL(@scanner, Scanner) 

   ,[PgdShipApptmtReasonCode]           = CASE WHEN (@isFormView = 1) THEN @pgdShipApptmtReasonCode WHEN ((@isFormView = 0) AND (@pgdShipApptmtReasonCode='#M4PL#')) THEN PgdShipApptmtReasonCode ELSE @pgdShipApptmtReasonCode END  
   ,[PgdShipStatusReasonCode]           = CASE WHEN (@isFormView = 1) THEN @pgdShipStatusReasonCode WHEN ((@isFormView = 0) AND (@pgdShipStatusReasonCode='#M4PL#')) THEN PgdShipStatusReasonCode ELSE @pgdShipStatusReasonCode END  
   ,[PgdOrderType]           = CASE WHEN (@isFormView = 1) THEN @pgdOrderType WHEN ((@isFormView = 0) AND (@pgdOrderType='#M4PL#')) THEN PgdOrderType ELSE @pgdOrderType END  
   ,[PgdShipmentType]           = CASE WHEN (@isFormView = 1) THEN @pgdShipmentType WHEN ((@isFormView = 0) AND (@pgdShipmentType='#M4PL#')) THEN PgdShipmentType ELSE @pgdShipmentType END  
   ,[PgdGatewayResponsible]     = CASE WHEN (@isFormView = 1) THEN @pgdGatewayResponsible WHEN ((@isFormView = 0) AND (@pgdGatewayResponsible=-100)) THEN PgdGatewayResponsible ELSE @pgdGatewayResponsible END  
   ,[PgdGatewayAnalyst]     = CASE WHEN (@isFormView = 1) THEN @pgdGatewayAnalyst WHEN ((@isFormView = 0) AND (@pgdGatewayAnalyst=-100)) THEN PgdGatewayAnalyst ELSE @pgdGatewayAnalyst END  


   ,[StatusId]                  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN StatusId ELSE @statusId END  
   ,[DateChanged]               = @dateChanged  
   ,[ChangedBy]                 = @changedBy  
  WHERE   [Id] = @id  
 SELECT prg.[Id]  
  ,prg.[PgdProgramID]  
  ,prg.[PgdGatewaySortOrder]  
  ,prg.[PgdGatewayCode]  
  ,prg.[PgdGatewayTitle]  
  ,prg.[PgdGatewayDuration]  
  ,prg.[UnitTypeId]  
  ,prg.[PgdGatewayDefault]  
  ,prg.[GatewayTypeId]  
  ,prg.[GatewayDateRefTypeId]  
  ,prg.[Scanner]  
  ,prg.[PgdShipApptmtReasonCode]
  ,prg.[PgdShipStatusReasonCode]
  ,prg.[PgdOrderType]
  ,prg.[PgdShipmentType]
  ,prg.[PgdGatewayResponsible]
  ,prg.[PgdGatewayAnalyst]
  ,prg.[StatusId]   
  ,prg.[DateEntered]  
  ,prg.[EnteredBy]  
  ,prg.[DateChanged]  
  ,prg.[ChangedBy]  
  FROM   [dbo].[PRGRM010Ref_GatewayDefaults] prg  
 WHERE   [Id] = @id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH

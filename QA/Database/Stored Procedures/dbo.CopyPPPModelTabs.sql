SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Janardana Behara                 
-- Create date:               09/14/2018              
-- Description:               Ins a Job            
-- Execution:                 EXEC [dbo].[[CopyPPPModelTabs]]        
-- Modified on:          
-- Modified Desc:          
-- =============================================    
      
CREATE PROCEDURE [dbo].[CopyPPPModelTabs]                          
 @recordId BIGINT,        
 @newProgramId BIGINT,      
 @configurationIds NVARCHAR(MAX) = NULL,  -- comma seperated tab pagename ids      
 @enteredBy NVARCHAR(50),
 @PacificDateTime DATETIME2(7)      
AS        
BEGIN      
SET NOCOUNT ON;      
      
 DECLARE @ConfigIdTables TABLE(      
       PrimaryId INT PRIMARY KEY IDENTITY(1,1)      
   ,TableName NVARCHAR(100)  
 );      
      
 INSERT INTO @ConfigIdTables(TableName)      
 SELECT item FROM [dbo].[fnSplitString](@configurationIds,',');     
 
 IF EXISTS(SELECT TableName FROM @ConfigIdTables WHERE TableName = 'PrgRefGatewayDefault')
 BEGIN 

	 IF NOT EXISTS(SELECT TableName FROM @ConfigIdTables WHERE TableName = 'PrgShipStatusReasonCode')
	 BEGIN
		 INSERT INTO @ConfigIdTables(TableName) Values('PrgShipStatusReasonCode');
	 END
	 IF NOT EXISTS(SELECT TableName FROM @ConfigIdTables WHERE TableName = 'PrgShipApptmtReasonCode')
	 BEGIN
		 INSERT INTO @ConfigIdTables(TableName) Values('PrgShipApptmtReasonCode');
	 END
  
END   
 DECLARE @pId INT =1      
    
 DECLARE @tabTableName NVARCHAR(100)      
 SELECT @tabTableName = TableName  FROM @ConfigIdTables Where PrimaryId = @pId;      
      
   While(@tabTableName IS NOT NULL)      
   BEGIN     
    
    IF @tabTableName='PrgRefGatewayDefault'      
    BEGIN      
        EXEC ProgramGatewayCopy @newProgramId, @enteredBy, @recordId ,@PacificDateTime 
       END     
    ELSE IF @tabTableName='PrgRole'      
    BEGIN      
        EXEC PrgRoleCopy @newProgramId, @enteredBy, @recordId  ,@PacificDateTime
       END   
    ELSE IF @tabTableName='PrgBillableRate'      
    BEGIN      
        EXEC ProgramBillableRateCopy @newProgramId, @enteredBy, @recordId ,@PacificDateTime 
       END   
    ELSE IF @tabTableName='PrgVendLocation'      
    BEGIN      
        EXEC PrgVendLocationCopy @newProgramId, @enteredBy, @recordId ,@PacificDateTime 
       END   
    ELSE IF @tabTableName='PrgCostRate'      
    BEGIN      
        EXEC ProgramCostRateCopy @newProgramId, @enteredBy, @recordId  ,@PacificDateTime
       END   
    ELSE IF @tabTableName='PrgShipStatusReasonCode'      
    BEGIN      
        EXEC PrgShipStatusReasonCodeCopy @newProgramId, @enteredBy, @recordId  ,@PacificDateTime
       END   
    ELSE IF @tabTableName='PrgShipApptmtReasonCode'      
    BEGIN      
        EXEC PrgShipApptmtReasonCodeCopy @newProgramId, @enteredBy, @recordId ,@PacificDateTime 
       END   
    ELSE IF @tabTableName='PrgRefAttributeDefault'      
    BEGIN      
        EXEC PrgRefAttributeDefaultCopy @newProgramId, @enteredBy, @recordId  ,@PacificDateTime
       END    
          ELSE IF @tabTableName='PrgMvoc'      
    BEGIN      
        EXEC PrgMvocCopy @newProgramId, @enteredBy, @recordId  ,@PacificDateTime
       END   
    ELSE IF @tabTableName='ScrCatalogList'      
    BEGIN      
        EXEC ScrCatalogListCopy @newProgramId, @enteredBy, @recordId  ,@PacificDateTime
       END    
        
    SET @pId = @pId + 1;      
    SET @tabTableName = NULL;    
    SELECT @tabTableName = TableName  FROM @ConfigIdTables Where PrimaryId = @pId;   
   END  
END
GO

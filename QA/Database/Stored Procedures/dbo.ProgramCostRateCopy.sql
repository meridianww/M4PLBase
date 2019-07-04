SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
  
  CREATE  PROCEDURE [dbo].[ProgramCostRateCopy]  
  (  
    @programId BIGINT,  
 @enteredBy NVARCHAR(50),  
 @fromRecordId BIGINT  
  )  
  AS   
  BEGIN  
   SET NOCOUNT ON;     
  
  INSERT INTO [dbo].[PRGRM041ProgramCostRate]  
           ( [PcrPrgrmID]  
   ,[PcrCode]  
   ,[PcrVendorCode]  
   ,[PcrEffectiveDate]  
   ,[PcrTitle]  
   ,[RateCategoryTypeId]  
   ,[RateTypeId]  
   ,[PcrCostRate]  
   ,[RateUnitTypeId]  
   ,[PcrFormat]  
   ,[PcrExpression01]  
   ,[PcrLogic01]  
   ,[PcrExpression02]  
   ,[PcrLogic02]  
   ,[PcrExpression03]  
   ,[PcrLogic03]  
   ,[PcrExpression04]  
   ,[PcrLogic04]  
   ,[PcrExpression05]  
   ,[PcrLogic05]  
   ,[StatusId]  
   ,[PcrCustomerID]  
   ,[EnteredBy]  
   ,[DateEntered])    
        
   SELECT         
    @programId        
   ,[PcrCode]  
   ,[PcrVendorCode]  
   ,[PcrEffectiveDate]  
   ,[PcrTitle]  
   ,[RateCategoryTypeId]  
   ,[RateTypeId]  
   ,[PcrCostRate]  
   ,[RateUnitTypeId]  
   ,[PcrFormat]  
   ,[PcrExpression01]  
   ,[PcrLogic01]  
   ,[PcrExpression02]  
   ,[PcrLogic02]  
   ,[PcrExpression03]  
   ,[PcrLogic03]  
   ,[PcrExpression04]  
   ,[PcrLogic04]  
   ,[PcrExpression05]  
   ,[PcrLogic05]  
   ,[StatusId]  
   ,[PcrCustomerID]     
      
   ,@enteredBy   
   ,GETUTCDATE()                
   FROM [PRGRM041ProgramCostRate] WHERE [PcrPrgrmID]= @fromRecordId   AND StatusId IN(1,2)     
     
END
GO

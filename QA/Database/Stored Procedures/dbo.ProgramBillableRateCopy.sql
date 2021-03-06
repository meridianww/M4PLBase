SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
  
  CREATE  PROCEDURE [dbo].[ProgramBillableRateCopy]  
  (  
    @programId BIGINT,  
 @enteredBy NVARCHAR(50),  
 @fromRecordId BIGINT,
 @PacificDateTime DATETIME2(7)  
  )  
  AS   
  BEGIN  
   SET NOCOUNT ON;     

  INSERT INTO [dbo].[PRGRM040ProgramBillableRate]     
     ([Id]  
   ,[PbrCode]  
   ,[PbrCustomerCode]  
   ,[PbrEffectiveDate]  
   ,[PbrTitle]  
   ,[RateCategoryTypeId]  
   ,[RateTypeId]  
   ,[PbrBillablePrice]  
   ,[RateUnitTypeId]  
   ,[PbrFormat]  
   ,[PbrExpression01]  
   ,[PbrLogic01]  
   ,[PbrExpression02]  
   ,[PbrLogic02]  
   ,[PbrExpression03]  
   ,[PbrLogic03]  
   ,[PbrExpression04]  
   ,[PbrLogic04]  
   ,[PbrExpression05]  
   ,[PbrLogic05]  
   ,[StatusId]  
   ,[PbrVendLocationID]  
   ,[EnteredBy]  
   ,[DateEntered]        
     )        
        
   SELECT         
    @programId        
   ,[PbrCode]  
   ,[PbrCustomerCode]  
   ,[PbrEffectiveDate]  
   ,[PbrTitle]  
   ,[RateCategoryTypeId]  
   ,[RateTypeId]  
   ,[PbrBillablePrice]  
   ,[RateUnitTypeId]  
   ,[PbrFormat]  
   ,[PbrExpression01]  
   ,[PbrLogic01]  
   ,[PbrExpression02]  
   ,[PbrLogic02]  
   ,[PbrExpression03]  
   ,[PbrLogic03]  
   ,[PbrExpression04]  
   ,[PbrLogic04]  
   ,[PbrExpression05]  
   ,[PbrLogic05]  
   ,[StatusId]  
   ,[PbrVendLocationID] 
   ,@enteredBy       
   ,@PacificDateTime 
   FROM [PRGRM040ProgramBillableRate] WHERE [Id]= @fromRecordId   AND StatusId IN(1,2)     
     
END
GO

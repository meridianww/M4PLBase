SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[InsJobRefCostSheet]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsJobRefCostSheet]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@cstLineItem nvarchar(20)
	,@cstChargeId int
	,@cstChargeCode nvarchar(25)
	,@cstTitle nvarchar(50)
	,@cstSurchargeOrder bigint
	,@cstSurchargePercent float
	,@chargeTypeId int
	,@cstNumberUsed int
	,@cstDuration decimal(18, 2)
	,@cstQuantity decimal(18, 2)
	,@costUnitId int
	,@cstCostRate decimal(18, 2)
	,@cstCost decimal(18, 2)
	,@cstMarkupPercent float
	,@cstRevenueRate decimal(18, 2)
	,@cstRevDuration decimal(18, 2)
	,@cstRevQuantity decimal(18, 2)
	,@cstRevBillable decimal(18, 2)
	,@statusId int
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;
    DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @cstLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 
    
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL060Ref_CostSheetJob]
           ([JobID]
			,[CstLineItem]
			,[CstChargeID]
			,[CstChargeCode]
			,[CstTitle]
			,[CstSurchargeOrder]
			,[CstSurchargePercent]
			,[ChargeTypeId]
			,[CstNumberUsed]
			,[CstDuration]
			,[CstQuantity]
			,[CostUnitId]
			,[CstCostRate]
			,[CstCost]
			,[CstMarkupPercent]
			,[CstRevenueRate]
			,[CstRevDuration]
			,[CstRevQuantity]
			,[CstRevBillable]
			,[StatusId]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@jobID
		   	,@updatedItemNumber
		   	,@cstChargeID
		   	,@cstChargeCode
		   	,@cstTitle
		   	,@cstSurchargeOrder
		   	,@cstSurchargePercent
		   	,@chargeTypeId
		   	,@cstNumberUsed
		   	,@cstDuration
		   	,@cstQuantity
		   	,@costUnitId
		   	,@cstCostRate
		   	,@cstCost
		   	,@cstMarkupPercent
		   	,@cstRevenueRate
		   	,@cstRevDuration
		   	,@cstRevQuantity
		   	,@cstRevBillable
		   	,@statusId
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL060Ref_CostSheetJob] WHERE Id = @currentId; 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

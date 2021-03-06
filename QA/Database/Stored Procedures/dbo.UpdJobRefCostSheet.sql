SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[UpdJobRefCostSheet]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdJobRefCostSheet]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@Id bigint
	,@JobId bigint = NULL
	,@CstLineItem nvarchar(20) = NULL
	,@CstChargeId int = NULL
	,@CstChargeCode nvarchar(25) = NULL
	,@CstTitle nvarchar(50) = NULL
	,@CstSurchargeOrder bigint = NULL
	,@CstSurchargePercent float = NULL
	,@chargeTypeId int = NULL
	,@CstNumberUsed int = NULL
	,@CstDuration decimal(18, 2) = NULL
	,@CstQuantity decimal(18, 2) = NULL
	,@costUnitId int = NULL
	,@CstCostRate decimal(18, 2) = NULL
	,@CstCost decimal(18, 2) = NULL
	,@CstMarkupPercent float = NULL
	,@CstRevenueRate decimal(18, 2) = NULL
	,@CstRevDuration decimal(18, 2) = NULL
	,@CstRevQuantity decimal(18, 2) = NULL
	,@CstRevBillable decimal(18, 2) = NULL
	,@statusId int = NULL
	,@ChangedBy nvarchar(50) = NULL
	,@DateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
    DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @cstLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  
 UPDATE [dbo].[JOBDL060Ref_CostSheetJob]
		SET  [JobID]                 = CASE WHEN (@isFormView = 1) THEN @JobID WHEN ((@isFormView = 0) AND (@JobID=-100)) THEN NULL ELSE ISNULL(@JobID, JobID) END
			,[CstLineItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CstLineItem)END
			,[CstChargeID]           = CASE WHEN (@isFormView = 1) THEN @CstChargeID WHEN ((@isFormView = 0) AND (@CstChargeID=-100)) THEN NULL ELSE ISNULL(@CstChargeID, CstChargeID) END
			,[CstChargeCode]         = CASE WHEN (@isFormView = 1) THEN @CstChargeCode WHEN ((@isFormView = 0) AND (@CstChargeCode='#M4PL#')) THEN NULL ELSE ISNULL(@CstChargeCode, CstChargeCode) END
			,[CstTitle]              = CASE WHEN (@isFormView = 1) THEN @CstTitle WHEN ((@isFormView = 0) AND (@CstTitle='#M4PL#')) THEN NULL ELSE ISNULL(@CstTitle, CstTitle) END
			,[CstSurchargeOrder]     = CASE WHEN (@isFormView = 1) THEN @CstSurchargeOrder WHEN ((@isFormView = 0) AND (@CstSurchargeOrder=-100)) THEN NULL ELSE ISNULL(@CstSurchargeOrder, CstSurchargeOrder) END
			,[CstSurchargePercent]   = CASE WHEN (@isFormView = 1) THEN @CstSurchargePercent WHEN ((@isFormView = 0) AND (@CstSurchargePercent=-100.00)) THEN NULL ELSE ISNULL(@CstSurchargePercent, CstSurchargePercent) END
			,[ChargeTypeId]          = CASE WHEN (@isFormView = 1) THEN @chargeTypeId WHEN ((@isFormView = 0) AND (@chargeTypeId=-100)) THEN NULL ELSE ISNULL(@chargeTypeId, ChargeTypeId) END
			,[CstNumberUsed]         = CASE WHEN (@isFormView = 1) THEN @CstNumberUsed WHEN ((@isFormView = 0) AND (@CstNumberUsed=-100)) THEN NULL ELSE ISNULL(@CstNumberUsed, CstNumberUsed) END
			,[CstDuration]           = CASE WHEN (@isFormView = 1) THEN @CstDuration WHEN ((@isFormView = 0) AND (@CstDuration=-100.00)) THEN NULL ELSE ISNULL(@CstDuration, CstDuration) END
			,[CstQuantity]           = CASE WHEN (@isFormView = 1) THEN @CstQuantity WHEN ((@isFormView = 0) AND (@CstQuantity=-100.00)) THEN NULL ELSE ISNULL(@CstQuantity, CstQuantity) END
			,[CostUnitId]            = CASE WHEN (@isFormView = 1) THEN @costUnitId WHEN ((@isFormView = 0) AND (@costUnitId=-100)) THEN NULL ELSE ISNULL(@costUnitId, CostUnitId) END
			,[CstCostRate]           = CASE WHEN (@isFormView = 1) THEN @CstCostRate WHEN ((@isFormView = 0) AND (@CstCostRate=-100.00)) THEN NULL ELSE ISNULL(@CstCostRate, CstCostRate) END
			,[CstCost]               = CASE WHEN (@isFormView = 1) THEN @CstCost WHEN ((@isFormView = 0) AND (@CstCost=-100.00)) THEN NULL ELSE ISNULL(@CstCost, CstCost) END
			,[CstMarkupPercent]      = CASE WHEN (@isFormView = 1) THEN @CstMarkupPercent WHEN ((@isFormView = 0) AND (@CstMarkupPercent=-100.00)) THEN NULL ELSE ISNULL(@CstMarkupPercent, CstMarkupPercent) END
			,[CstRevenueRate]        = CASE WHEN (@isFormView = 1) THEN @CstRevenueRate WHEN ((@isFormView = 0) AND (@CstRevenueRate=-100.00)) THEN NULL ELSE ISNULL(@CstRevenueRate, CstRevenueRate) END
			,[CstRevDuration]        = CASE WHEN (@isFormView = 1) THEN @CstRevDuration WHEN ((@isFormView = 0) AND (@CstRevDuration=-100.00)) THEN NULL ELSE ISNULL(@CstRevDuration, CstRevDuration) END
			,[CstRevQuantity]        = CASE WHEN (@isFormView = 1) THEN @CstRevQuantity WHEN ((@isFormView = 0) AND (@CstRevQuantity=-100.00)) THEN NULL ELSE ISNULL(@CstRevQuantity, CstRevQuantity) END
			,[CstRevBillable]        = CASE WHEN (@isFormView = 1) THEN @CstRevBillable WHEN ((@isFormView = 0) AND (@CstRevBillable=-100.00)) THEN NULL ELSE ISNULL(@CstRevBillable, CstRevBillable) END
			,[StatusId]              = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[ChangedBy]             = @ChangedBy
			,[DateChanged]           = @DateChanged
	 WHERE   [Id] = @id
	SELECT job.[Id]
		,job.[JobID]
		,job.[CstLineItem]
		,job.[CstChargeID]
		,job.[CstChargeCode]
		,job.[CstTitle]
		,job.[CstSurchargeOrder]
		,job.[CstSurchargePercent]
		,job.[ChargeTypeId]
		,job.[CstNumberUsed]
		,job.[CstDuration]
		,job.[CstQuantity]
		,job.[CostUnitId]
		,job.[CstCostRate]
		,job.[CstCost]
		,job.[CstMarkupPercent]
		,job.[CstRevenueRate]
		,job.[CstRevDuration]
		,job.[CstRevQuantity]
		,job.[CstRevBillable]
		,job.[StatusId]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
  FROM   [dbo].[JOBDL060Ref_CostSheetJob] job WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

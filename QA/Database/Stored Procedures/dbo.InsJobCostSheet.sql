SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Prashant Aggarwal                
-- Create date:               10/30/2019              
-- Description:               Insert Job Cost Sheet                      
-- =============================================              
CREATE PROCEDURE [dbo].[InsJobCostSheet] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@JobID [bigint]
	,@CstLineItem [nvarchar](20)
	,@CstChargeCode [nvarchar](25)
	,@CstTitle [nvarchar](50)
	,@CstChargeID [int]
	,@CstSurchargeOrder [bigint]
	,@CstSurchargePercent [float]
	,@ChargeTypeId [int]
	,@CstNumberUsed [int]
	,@CstDuration [decimal](18, 2)
	,@CstQuantity [decimal](18, 2)
	,@costUnitId [int]
	,@cstCostRate [decimal](18, 2)
	,@cstCost [decimal](18, 2)
	,@cstMarkupPercent [float]
	,@statusId [int]
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@cstElectronicBilling BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentId BIGINT
		,@updatedItemNumber INT

	--SELECT @LineNumber = CASE 
	--		WHEN ISNULL(MAX(LineNumber), 0) = 0
	--			THEN 10000
	--		ELSE MAX(LineNumber) + 1
	--		END
	--FROM [dbo].[JOBDL062CostSheet]
	--WHERE JobId = @JobID
	--	AND StatusId IN (
	--		1
	--		,2
	--		)

 	EXEC [dbo].[ResetItemNumber] @userId
		,0
		,@JobID
		,@entity
		,null
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	INSERT INTO [dbo].[JOBDL062CostSheet] (
		 [JobID]
		,[CstLineItem]
		,[CstChargeCode]
		,[CstTitle]
		,[CstChargeID]
		,[CstSurchargeOrder]
		,[CstSurchargePercent]
		,[ChargeTypeId]
		,[CstNumberUsed]
		,[CstDuration]
		,[CstQuantity]
		,[CstUnitId]
		,[CstRate]
		,[CstAmount]
		,[CstMarkupPercent]
		,[CstElectronicBilling]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	VALUES (
		@JobID
		,@updatedItemNumber
		,@CstChargeCode
		,@CstTitle
		,@CstChargeID
		,@CstSurchargeOrder
		,@CstSurchargePercent
		,@ChargeTypeId
		,@CstNumberUsed
		,@CstDuration
		,@CstQuantity
		,@costUnitId
		,@cstCostRate
		,@cstCost
		,@cstMarkupPercent
		,@cstElectronicBilling
		,@statusId
		,@enteredBy
		,@dateEntered
		)

	SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[UpdateLineNumberForJobCostSheet] @JobID
	EXEC [dbo].[GetJobCostSheet] @userId
		,@roleId
		,0
		,@currentId
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO

